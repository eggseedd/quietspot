import '../domain/noise_log_repository.dart';
import 'local/noise_log_local_data_source.dart';
import 'remote/noise_log_remote_data_source.dart';
import 'models/noise_log_model.dart';

class NoiseLogRepositoryImpl implements NoiseLogRepository {
  final NoiseLogLocalDataSource localDataSource;
  final NoiseLogRemoteDataSource remoteDataSource;

  NoiseLogRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<void> addNoiseLog(NoiseLogModel log) async {
    // Delete old logs at the same location (both locally and in Firestore)
    final deletedIds = await deleteOldLogsAtLocation(log.userId, log.latitude, log.longitude);
    
    // Soft-delete old logs in Firestore asynchronously
    for (final logId in deletedIds) {
      _softDeleteOldLogRemotelyAsync(logId);
    }
    
    // Add the new log locally
    await localDataSource.insertNoiseLog(log);
    // Sync to Firestore asynchronously (don't await - fire and forget)
    _syncLogToFirestore(log);
  }

  @override
  Future<void> deleteNoiseLog(String logId) async {
    // Soft delete locally by marking as deleted
    await localDataSource.deleteNoiseLog(logId);
    // Soft-delete from Firestore asynchronously
    _softDeleteOldLogRemotelyAsync(logId);
  }

  @override
  Future<List<NoiseLogModel>> fetchNoiseLogs(String userId) async {
    // Clean up expired logs before fetching
    await deleteExpiredLogs();
    
    // Sync logs from Firestore to local DB (for users who reinstalled app)
    await _syncLogsFromFirestore(userId);
    
    // Return logs from local DB
    return localDataSource.fetchLogsForUser(userId);
  }

  @override
  Future<void> updateNoiseLog(NoiseLogModel log) async {
    await localDataSource.updateNoiseLog(log);
    // Sync update to Firestore asynchronously
    _updateRemoteNoiseLogAsync(log);
  }

  @override
  Future<void> deleteExpiredLogs() async {
    await localDataSource.deleteExpiredLogs();
  }

  @override
  Future<List<String>> deleteOldLogsAtLocation(
    String userId,
    double latitude,
    double longitude,
  ) async {
    return await localDataSource.deleteOldLogsAtLocation(userId, latitude, longitude);
  }

  // ============ Remote Operations ============

  @override
  Future<void> syncNoiseLogsToFirestore(String userId) async {
    try {
      // Fetch all local logs for this user that haven't been synced yet
      final localLogs = await localDataSource.fetchLogsForUser(userId);

      if (localLogs.isEmpty) return;

      // Batch upload to Firestore
      await remoteDataSource.batchUploadNoiseLogs(localLogs);
    } catch (e) {
      print('Error syncing logs to Firestore: $e');
      rethrow;
    }
  }

  @override
  Future<List<NoiseLogModel>> fetchRemoteNoiseLogs() async {
    try {
      return await remoteDataSource.fetchAllNoiseLogs();
    } catch (e) {
      print('Error fetching remote logs: $e');
      rethrow;
    }
  }

  @override
  Future<List<NoiseLogModel>> fetchNearbyNoiseLogs(
    double latitude,
    double longitude,
    double radiusInKm,
  ) async {
    try {
      return await remoteDataSource.fetchNearbyNoiseLogs(
        latitude: latitude,
        longitude: longitude,
        radiusInKm: radiusInKm,
      );
    } catch (e) {
      print('Error fetching nearby logs: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateRemoteNoiseLog(NoiseLogModel log) async {
    try {
      await remoteDataSource.updateNoiseLog(log);
    } catch (e) {
      print('Error updating remote log: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteRemoteNoiseLog(String logId) async {
    try {
      await remoteDataSource.softDeleteNoiseLog(logId);
    } catch (e) {
      print('Error deleting remote log: $e');
      rethrow;
    }
  }

  // ============ Async Background Sync ============

  /// Sync a single log to Firestore without blocking the main operation
  Future<void> _syncLogToFirestore(NoiseLogModel log) async {
    try {
      await remoteDataSource.uploadNoiseLog(log);
    } catch (e) {
      print('Background sync failed: $e');
      // Don't throw - let the app continue, will retry on next sync
    }
  }

  /// Update remote log without blocking
  Future<void> _updateRemoteNoiseLogAsync(NoiseLogModel log) async {
    try {
      await remoteDataSource.updateNoiseLog(log);
    } catch (e) {
      print('Background update failed: $e');
      // Don't throw
    }
  }

  /// Soft-delete old log from Firestore without blocking
  Future<void> _softDeleteOldLogRemotelyAsync(String logId) async {
    try {
      await remoteDataSource.softDeleteNoiseLog(logId);
    } catch (e) {
      print('Background deletion failed: $e');
      // Don't throw - let the app continue
    }
  }

  /// Sync logs from Firestore to local DB (e.g., after app reinstall)
  /// Filters out expired logs (older than 3 hours)
  Future<void> _syncLogsFromFirestore(String userId) async {
    try {
      final remoteLogs = await remoteDataSource.fetchLogsForUser(userId);
      if (remoteLogs.isEmpty) return;

      // Filter out expired logs (keep only logs within 3 hours)
      final now = DateTime.now();
      final threeHoursAgo = now.subtract(const Duration(hours: 3));
      
      final validLogs = remoteLogs.where((log) {
        // Skip deleted logs
        if (log.isDeleted) return false;
        // Skip logs older than 3 hours
        return log.timestamp.isAfter(threeHoursAgo);
      }).toList();

      // Insert or update valid logs to local DB (handles duplicates gracefully)
      for (final log in validLogs) {
        await localDataSource.insertOrUpdateNoiseLog(log);
      }
    } catch (e) {
      print('Error syncing logs from Firestore: $e');
      // Don't throw - let the app continue with whatever is in local DB
    }
  }
}

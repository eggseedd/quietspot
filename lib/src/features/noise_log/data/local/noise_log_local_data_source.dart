import 'package:drift/drift.dart';
import '../../../../data/local/app_database.dart';
import '../models/noise_log_model.dart';

class NoiseLogLocalDataSource {
  final AppDatabase _database = AppDatabase();

  Future<void> insertNoiseLog(NoiseLogModel log) async {
    await _database.into(_database.noiseLogs).insert(
      NoiseLogsCompanion(
        id: Value(log.id),
        userId: Value(log.userId),
        timestamp: Value(log.timestamp),
        latitude: Value(log.latitude),
        longitude: Value(log.longitude),
        locationName: Value(log.locationName),
        rmsValue: Value(log.rmsValue),
        estimatedDb: Value(log.estimatedDb),
        classification: Value(log.classification.name),
        manualLabel: Value(log.manualLabel),
        notes: Value(log.notes),
        isDeleted: Value(log.isDeleted),
      ),
    );
  }

  Future<List<NoiseLogModel>> fetchLogsForUser(String userId) async {
    final query = _database.select(_database.noiseLogs)
      ..where((tbl) => tbl.userId.equals(userId))
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.timestamp, mode: OrderingMode.desc)]);

    final rows = await query.get();
    return rows.map((entry) {
      return NoiseLogModel(
        id: entry.id,
        userId: entry.userId,
        timestamp: entry.timestamp,
        latitude: entry.latitude,
        longitude: entry.longitude,
        locationName: entry.locationName,
        rmsValue: entry.rmsValue,
        estimatedDb: entry.estimatedDb,
        classification: NoiseClassification.values.firstWhere(
          (value) => value.name == entry.classification,
          orElse: () => NoiseClassification.moderate,
        ),
        manualLabel: entry.manualLabel,
        notes: entry.notes,
        isDeleted: entry.isDeleted,
      );
    }).toList();
  }

  Future<void> updateNoiseLog(NoiseLogModel log) async {
    final entity = _database.noiseLogs;
    await _database.update(entity).replace(
      NoiseLogsCompanion(
        id: Value(log.id),
        userId: Value(log.userId),
        timestamp: Value(log.timestamp),
        latitude: Value(log.latitude),
        longitude: Value(log.longitude),
        locationName: Value(log.locationName),
        rmsValue: Value(log.rmsValue),
        estimatedDb: Value(log.estimatedDb),
        classification: Value(log.classification.name),
        manualLabel: Value(log.manualLabel),
        notes: Value(log.notes),
        isDeleted: Value(log.isDeleted),
      ),
    );
  }

  Future<void> deleteNoiseLog(String logId) async {
    final entity = _database.noiseLogs;
    await (entity.delete()..where((tbl) => tbl.id.equals(logId))).go();
  }

  /// Delete all old logs at the same location (keeping only the latest one)
  Future<void> deleteOldLogsAtLocation(String userId, double latitude, double longitude) async {
    const locationThreshold = 0.00009; // ~10 meters
    
    // Fetch all logs at the same location
    final query = _database.select(_database.noiseLogs)
      ..where((tbl) => tbl.userId.equals(userId));
    
    final allLogs = await query.get();
    
    // Filter logs at same location
    final logsAtLocation = allLogs.where((log) =>
      (log.latitude - latitude).abs() <= locationThreshold &&
      (log.longitude - longitude).abs() <= locationThreshold
    ).toList();
    
    // Delete all logs at this location (the new one will replace them all)
    for (final log in logsAtLocation) {
      await deleteNoiseLog(log.id);
    }
  }

  /// Delete logs older than 3 hours
  Future<void> deleteExpiredLogs() async {
    final now = DateTime.now();
    final threeHoursAgo = now.subtract(const Duration(hours: 3));
    
    final entity = _database.noiseLogs;
    await (entity.delete()..where((tbl) => tbl.timestamp.isSmallerThanValue(threeHoursAgo))).go();
  }

  /// Fetch logs for user and clean up expired logs
  Future<List<NoiseLogModel>> fetchLogsForUserWithCleanup(String userId) async {
    // Clean up expired logs first
    await deleteExpiredLogs();
    return fetchLogsForUser(userId);
  }
}

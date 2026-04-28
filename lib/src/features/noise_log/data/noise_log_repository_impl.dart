import '../domain/noise_log_repository.dart';
import 'local/noise_log_local_data_source.dart';
import 'models/noise_log_model.dart';

class NoiseLogRepositoryImpl implements NoiseLogRepository {
  final NoiseLogLocalDataSource localDataSource;

  NoiseLogRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addNoiseLog(NoiseLogModel log) async {
    // Delete old logs at the same location
    await deleteOldLogsAtLocation(log.userId, log.latitude, log.longitude);
    // Add the new log
    await localDataSource.insertNoiseLog(log);
  }

  @override
  Future<void> deleteNoiseLog(String logId) async {
    await localDataSource.deleteNoiseLog(logId);
  }

  @override
  Future<List<NoiseLogModel>> fetchNoiseLogs(String userId) async {
    // Clean up expired logs before fetching
    await deleteExpiredLogs();
    return localDataSource.fetchLogsForUser(userId);
  }

  @override
  Future<void> updateNoiseLog(NoiseLogModel log) async {
    await localDataSource.updateNoiseLog(log);
  }

  @override
  Future<void> deleteExpiredLogs() async {
    await localDataSource.deleteExpiredLogs();
  }

  @override
  Future<void> deleteOldLogsAtLocation(String userId, double latitude, double longitude) async {
    await localDataSource.deleteOldLogsAtLocation(userId, latitude, longitude);
  }
}

import '../data/models/noise_log_model.dart';

abstract class NoiseLogRepository {
  // Local operations
  Future<void> addNoiseLog(NoiseLogModel log);
  Future<List<NoiseLogModel>> fetchNoiseLogs(String userId);
  Future<void> updateNoiseLog(NoiseLogModel log);
  Future<void> deleteNoiseLog(String logId);
  Future<void> deleteExpiredLogs();
  Future<List<String>> deleteOldLogsAtLocation(String userId, double latitude, double longitude);
  
  // Remote operations (Firestore)
  Future<void> syncNoiseLogsToFirestore(String userId);
  Future<List<NoiseLogModel>> fetchRemoteNoiseLogs();
  Future<List<NoiseLogModel>> fetchNearbyNoiseLogs(
    double latitude,
    double longitude,
    double radiusInKm,
  );
  Future<void> updateRemoteNoiseLog(NoiseLogModel log);
  Future<void> deleteRemoteNoiseLog(String logId);
}

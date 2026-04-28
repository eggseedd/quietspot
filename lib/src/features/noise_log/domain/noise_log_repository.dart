import '../data/models/noise_log_model.dart';

abstract class NoiseLogRepository {
  Future<void> addNoiseLog(NoiseLogModel log);
  Future<List<NoiseLogModel>> fetchNoiseLogs(String userId);
  Future<void> updateNoiseLog(NoiseLogModel log);
  Future<void> deleteNoiseLog(String logId);
}

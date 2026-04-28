import '../domain/noise_log_repository.dart';
import 'local/noise_log_local_data_source.dart';
import 'models/noise_log_model.dart';

class NoiseLogRepositoryImpl implements NoiseLogRepository {
  final NoiseLogLocalDataSource localDataSource;

  NoiseLogRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addNoiseLog(NoiseLogModel log) async {
    await localDataSource.insertNoiseLog(log);
  }

  @override
  Future<void> deleteNoiseLog(String logId) async {
    await localDataSource.deleteNoiseLog(logId);
  }

  @override
  Future<List<NoiseLogModel>> fetchNoiseLogs(String userId) {
    return localDataSource.fetchLogsForUser(userId);
  }

  @override
  Future<void> updateNoiseLog(NoiseLogModel log) async {
    await localDataSource.updateNoiseLog(log);
  }
}

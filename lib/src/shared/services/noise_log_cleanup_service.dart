import 'dart:async';
import '../../features/noise_log/data/noise_log_repository_impl.dart';

class NoiseLogCleanupService {
  final NoiseLogRepositoryImpl repository;
  Timer? _cleanupTimer;
  
  static const Duration _cleanupInterval = Duration(minutes: 10);
  
  NoiseLogCleanupService({required this.repository});
  
  /// Start periodic cleanup of expired logs
  void startPeriodicCleanup() {
    // Run cleanup immediately on start
    cleanupExpiredLogs();
    
    // Then run every 10 minutes
    _cleanupTimer = Timer.periodic(_cleanupInterval, (_) {
      cleanupExpiredLogs();
    });
  }
  
  /// Stop the periodic cleanup
  void stopPeriodicCleanup() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }
  
  /// Manually trigger cleanup of expired logs
  Future<void> cleanupExpiredLogs() async {
    try {
      await repository.deleteExpiredLogs();
    } catch (e) {
      // Log error silently to avoid print in production
    }
  }
  
  /// Dispose resources
  void dispose() {
    stopPeriodicCleanup();
  }
}

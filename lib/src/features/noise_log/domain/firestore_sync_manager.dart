import 'dart:async';
import '../domain/noise_log_repository.dart';

/// Handles background synchronization of local logs to Firestore
class FirestoreSyncManager {
  final NoiseLogRepository repository;
  Timer? _syncTimer;
  bool _isSyncing = false;
  bool _isRunning = false;

  FirestoreSyncManager({required this.repository});

  /// Start periodic sync to Firestore
  /// Syncs every 30 minutes by default (or custom interval)
  void startPeriodicSync({
    required String userId,
    Duration interval = const Duration(minutes: 30),
  }) {
    if (_isRunning) return;

    _isRunning = true;

    // Sync immediately
    _performSync(userId);

    // Then sync periodically
    _syncTimer = Timer.periodic(interval, (_) {
      _performSync(userId);
    });

    print('Firestore sync started for user: $userId (interval: ${interval.inMinutes}m)');
  }

  /// Stop periodic sync
  void stopPeriodicSync() {
    _syncTimer?.cancel();
    _isRunning = false;
    print('Firestore sync stopped');
  }

  /// Manual sync
  Future<void> syncNow(String userId) async {
    await _performSync(userId);
  }

  /// Internal sync method
  Future<void> _performSync(String userId) async {
    if (_isSyncing) {
      print('Sync already in progress, skipping...');
      return;
    }

    _isSyncing = true;

    try {
      print('Starting Firestore sync for user: $userId');
      await repository.syncNoiseLogsToFirestore(userId);
      print('Firestore sync completed successfully');
    } catch (e) {
      print('Error during Firestore sync: $e');
      // Don't throw - let the timer retry
    } finally {
      _isSyncing = false;
    }
  }

  /// Check if currently syncing
  bool get isSyncing => _isSyncing;

  /// Check if sync service is running
  bool get isRunning => _isRunning;

  /// Cleanup
  void dispose() {
    stopPeriodicSync();
  }
}

import 'dart:async';
import 'noise_log_repository.dart';
import '../data/models/noise_log_model.dart';

/// Service to periodically fetch and refresh nearby noise logs
class SurroundingNoiseService {
  final NoiseLogRepository repository;
  Timer? _fetchTimer;
  bool _isRunning = false;

  // Callbacks for state updates
  final List<Function(List<NoiseLogModel>)> _listeners = [];

  SurroundingNoiseService({required this.repository});

  /// Start periodic fetching of nearby logs
  void startPeriodicFetch({
    required double latitude,
    required double longitude,
    required double radiusInKm,
    Duration interval = const Duration(hours: 1),
  }) {
    if (_isRunning) return;

    _isRunning = true;

    // Fetch immediately
    _fetchNearby(latitude, longitude, radiusInKm);

    // Then fetch periodically
    _fetchTimer = Timer.periodic(interval, (_) {
      _fetchNearby(latitude, longitude, radiusInKm);
    });
  }

  /// Stop periodic fetching
  void stopPeriodicFetch() {
    _fetchTimer?.cancel();
    _isRunning = false;
  }

  /// Manual fetch of nearby logs
  Future<List<NoiseLogModel>> fetchNearbyNow({
    required double latitude,
    required double longitude,
    required double radiusInKm,
  }) async {
    return _fetchNearby(latitude, longitude, radiusInKm);
  }

  /// Internal fetch method
  Future<List<NoiseLogModel>> _fetchNearby(
    double latitude,
    double longitude,
    double radiusInKm,
  ) async {
    try {
      final logs = await repository.fetchNearbyNoiseLogs(
        latitude,
        longitude,
        radiusInKm,
      );

      // Notify all listeners
      for (final listener in _listeners) {
        listener(logs);
      }

      return logs;
    } catch (e) {
      print('Error fetching nearby logs: $e');
      return [];
    }
  }

  /// Register a listener for nearby logs updates
  void addListener(Function(List<NoiseLogModel>) listener) {
    _listeners.add(listener);
  }

  /// Remove a listener
  void removeListener(Function(List<NoiseLogModel>) listener) {
    _listeners.remove(listener);
  }

  /// Cleanup
  void dispose() {
    stopPeriodicFetch();
    _listeners.clear();
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/data/firebase_auth_data_source.dart';
import '../features/auth/data/firebase_auth_repository.dart';
import '../features/auth/domain/auth_repository.dart';
import '../features/noise_log/data/local/noise_log_local_data_source.dart';
import '../features/noise_log/data/remote/noise_log_remote_data_source.dart';
import '../features/noise_log/data/noise_log_repository_impl.dart';
import '../features/noise_log/domain/surrounding_noise_service.dart';
import '../features/noise_log/domain/firestore_sync_manager.dart';
import '../shared/services/location_service.dart';
import '../shared/services/microphone_service.dart';
import '../shared/services/notification_service.dart';
import '../shared/services/noise_log_cleanup_service.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => FirebaseAuthRepository(dataSource: FirebaseAuthDataSource()),
);

final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(firebaseAuthProvider).authStateChanges(),
);

final noiseLogLocalDataSourceProvider = Provider<NoiseLogLocalDataSource>(
  (ref) => NoiseLogLocalDataSource(),
);

final noiseLogRemoteDataSourceProvider = Provider<NoiseLogRemoteDataSource>(
  (ref) => NoiseLogRemoteDataSource(),
);

final noiseLogRepositoryProvider = Provider(
  (ref) => NoiseLogRepositoryImpl(
    localDataSource: ref.watch(noiseLogLocalDataSourceProvider),
    remoteDataSource: ref.watch(noiseLogRemoteDataSourceProvider),
  ),
);

final noiseLogCleanupServiceProvider = Provider<NoiseLogCleanupService>((ref) {
  final repository = ref.watch(noiseLogRepositoryProvider);
  final cleanupService = NoiseLogCleanupService(repository: repository);
  
  // Start periodic cleanup when the provider is first accessed
  cleanupService.startPeriodicCleanup();
  
  // Stop cleanup when the provider is disposed
  ref.onDispose(() {
    cleanupService.dispose();
  });
  
  return cleanupService;
});

final microphoneServiceProvider = Provider<MicrophoneService>(
  (ref) {
    final service = MicrophoneService();
    return service;
  },
);

final locationServiceProvider = Provider<LocationService>(
  (ref) => LocationService(),
);

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);

final surroundingNoiseServiceProvider = Provider<SurroundingNoiseService>((ref) {
  final repository = ref.watch(noiseLogRepositoryProvider);
  final service = SurroundingNoiseService(repository: repository);

  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

final firestoreSyncManagerProvider = Provider<FirestoreSyncManager>((ref) {
  final repository = ref.watch(noiseLogRepositoryProvider);
  final syncManager = FirestoreSyncManager(repository: repository);

  ref.onDispose(() {
    syncManager.dispose();
  });

  return syncManager;
});

/// Fetch all remote noise logs (all users)
final remoteNoiseLogsProvider = FutureProvider<List>((ref) async {
  final repository = ref.watch(noiseLogRepositoryProvider);
  return repository.fetchRemoteNoiseLogs();
});

/// Fetch nearby noise logs within radius
/// Usage: ref.watch(nearbyNoiseLogsProvider(latitude, longitude, radiusKm))
final nearbyNoiseLogsProvider =
    FutureProvider.family<List, (double, double, double)>((ref, params) async {
  final repository = ref.watch(noiseLogRepositoryProvider);
  final (latitude, longitude, radiusKm) = params;
  return repository.fetchNearbyNoiseLogs(latitude, longitude, radiusKm);
});

/// Sync local logs to Firestore for a specific user
final syncNoiseLogsProvider =
    FutureProvider.family<void, String>((ref, userId) async {
  final repository = ref.watch(noiseLogRepositoryProvider);
  await repository.syncNoiseLogsToFirestore(userId);
});

final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(data: (user) => user?.uid, orElse: () => null);
});

final noiseLogsProvider = FutureProvider.family<List, String>((ref, userId) async {
  final repository = ref.watch(noiseLogRepositoryProvider);
  // Trigger cleanup service to ensure it's running
  ref.watch(noiseLogCleanupServiceProvider);
  return repository.fetchNoiseLogs(userId);
});

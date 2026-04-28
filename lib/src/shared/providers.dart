import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/data/firebase_auth_data_source.dart';
import '../features/auth/data/firebase_auth_repository.dart';
import '../features/auth/domain/auth_repository.dart';
import '../features/noise_log/data/local/noise_log_local_data_source.dart';
import '../features/noise_log/data/noise_log_repository_impl.dart';
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

final noiseLogRepositoryProvider = Provider(
  (ref) => NoiseLogRepositoryImpl(localDataSource: ref.watch(noiseLogLocalDataSourceProvider)),
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

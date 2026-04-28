import '../domain/auth_repository.dart';
import 'firebase_auth_data_source.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuthDataSource dataSource;

  FirebaseAuthRepository({required this.dataSource});

  @override
  Future<String> signInWithEmail(String email, String password) async {
    final result = await dataSource.signIn(email, password);
    return result.user?.uid ?? '';
  }

  @override
  Future<String> registerWithEmail(String email, String password) async {
    final result = await dataSource.register(email, password);
    return result.user?.uid ?? '';
  }

  @override
  Future<void> signOut() async {
    await dataSource.signOut();
  }

  @override
  String? get currentUserId => dataSource.currentUser?.uid;
}

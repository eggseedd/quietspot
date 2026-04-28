abstract class AuthRepository {
  Future<String> signInWithEmail(String email, String password);
  Future<String> registerWithEmail(String email, String password);
  Future<void> signOut();
  String? get currentUserId;
}

import '../entities/auth_user.dart';

abstract interface class AuthRepository {
  Future<AuthUser?> currentUser();

  Future<AuthUser> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();
}

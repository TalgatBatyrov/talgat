import 'package:basic_registration/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialise();
  AuthUser? get currentUser;
  Future<AuthUser> logIn({required email, required password});
  Future<AuthUser> createUser({required email, required password});
  Future<void> logOut();
  Future<void> sendEmailVerification();
}

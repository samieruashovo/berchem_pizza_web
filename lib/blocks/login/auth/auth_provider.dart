import 'auth_user.dart';

abstract class AuthProvider {
  //Future<void> initialize();
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser(
      {required String email,
      required String password,
      required String name,
      required String city,
      required String street,
      required String apartment,
      required String optional});
  Future<void> logOut();
  Future<void> sendEmailVerification();
}

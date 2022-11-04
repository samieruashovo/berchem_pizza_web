import 'auth_provider.dart';
import 'auth_user.dart';
import 'firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(
        FirebaseAuthProvider(),
      );
  @override
  Future<AuthUser> createUser(
          {required String email,
          required String password,
          required String name,
          required String city,
          required String street,
          required String apartment,
          required String optional}) =>
      provider.createUser(
          email: email,
          password: password,
          apartment: apartment,
          city: city,
          name: name,
          optional: optional,
          street: street);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(email: email, password: password);

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  // @override
  // Future<void> initialize() => provider.initialize();
}

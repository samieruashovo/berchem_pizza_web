// ignore_for_file: unused_local_variable

import 'package:berchem_pizza_web/blocks/login/auth/add_user_info.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, UserCredential;

import 'auth_exceptions.dart';
import 'auth_provider.dart';
import 'auth_user.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      UserCredential cred =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        UserInfoCreateUpdate().addUser(
          firstName: firstName,
          lastName: lastName,
          uid: user.id,
          email: email,
        );
        return user;
      } else {
        throw UserNotLoggedInAuthExceptions();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthExceptions();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthExceptions();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthExceptions();
      } else {
        throw GenericAuthExceptions();
      }
    } catch (_) {
      throw GenericAuthExceptions();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthExceptions();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthExceptions();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthExceptions();
      } else {
        throw GenericAuthExceptions();
      }
    } catch (_) {
      throw GenericAuthExceptions();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthExceptions();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthExceptions();
    }
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'firebase_auth/invalid-email':
          throw InvalidEmailAuthExceptions();
        case 'firebase_auth/user-not-found':
          throw UserNotFoundAuthExceptions();
        default:
          throw GenericAuthExceptions();
      }
    } catch (_) {
      throw GenericAuthExceptions();
    }
  }
}

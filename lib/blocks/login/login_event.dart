import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogIn(this.email, this.password);
}

class AuthEventRegister extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String city;
  final String street;
  final String apartment;
  final String optional;
  const AuthEventRegister(this.email, this.password, this.city, this.street,
      this.apartment, this.optional, this.firstName, this.lastName);
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventAdmin extends AuthEvent {
  const AuthEventAdmin();
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}

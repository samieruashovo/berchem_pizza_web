import 'package:bloc/bloc.dart';

import 'auth/auth_provider.dart';
import 'login_event.dart';
import 'login_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    on<AuthEventSendEmailVerification>((event, emit) async {
      // await provider.sendEmailVerification();
      // emit(state);
      emit(AuthStateRegistering(exception: null, isLoading: false));
    });
    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(
        exception: null,
        isLoading: false,
      ));
    });
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      final name = event.name;
      final city = event.city;
      final apartment = event.apartment;
      final street = event.street;
      final optional = event.optional;
      try {
        await provider.createUser(
          email: email,
          password: password,
          apartment: apartment,
          city: city,
          name: name,
          optional: optional,
          street: street,
        );
        await provider.sendEmailVerification();
        //emit(const AuthStateNeedsVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e, isLoading: false));
      }
    });
    on<AuthEventInitialize>((event, emit) async {
      //await provider.initialize();
      final user = provider.currentUser;
      emit(AuthStateRegistering(exception: null, isLoading: false));
      // if (user == null) {
      //   emit(
      //     const AuthStateLoggedOut(
      //       exception: null,
      //       isLoading: false,
      //     ),
      //   );
      // } else if (!user.isEmailVerified) {
      //   //emit(const AuthStateNeedsVerification(isLoading: false));
      // } else {
      //   emit(AuthStateLoggedIn(
      //     user: user,
      //     isLoading: false,
      //   ));

      // }
    });
    on<AuthEventLogIn>((event, emit) async {
      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
          loadingText: 'Please wait while logging in',
        ),
      );
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(email: email, password: password);

        if (!user.isEmailVerified) {
          emit(const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ));
          //emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ));
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ));

        on<AuthEventLogOut>((event, emit) async {
          emit(const AuthStateUninitialized(isLoading: false));
          try {
            await provider.logOut();
            emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          } on Exception catch (e) {
            emit(AuthStateLoggedOut(
              exception: e,
              isLoading: false,
            ));
          }
        });
      }
    });
  }
}

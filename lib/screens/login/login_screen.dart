import 'package:berchem_pizza_web/screens/login/login_page.dart';
import 'package:berchem_pizza_web/screens/login/sign_up.dart';
import 'package:berchem_pizza_web/screens/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocks/login/login_bloc.dart';
import '../../blocks/login/login_event.dart';
import '../../blocks/login/login_state.dart';

class UserLoginView extends StatelessWidget {
  const UserLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());

    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state.isLoading) {
        // LoadingScreen().show(
        //   context: context,
        //   text: state.loadingText ?? 'Please wait a moment',
        // );
      } else {
        // LoadingScreen().hide();
      }
    }, builder: (context, state) {
      if (state is AuthStateLoggedIn) {
        return const ProfileScreen();
      } else if (state is AuthStateNeedsVerification) {
        return const Text("Needs Verification");
        // return const VerifyEmailView();
      } else if (state is AuthStateLoggedOut) {
        return const LoginPage();
      } else if (state is AuthStateRegistering) {
        return const RegisterView();
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    });
  }
}

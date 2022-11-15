import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocks/login/auth/auth_exceptions.dart';
import '../../blocks/login/login_bloc.dart';
import '../../blocks/login/login_event.dart';
import '../../blocks/login/login_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/show_error_dialog.dart';
import '../widgets/text_widget.dart';
import '../widgets/wsized.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);
  static const String routeName = 'register';

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => const RegisterView(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _firstName = TextEditingController();
    _lastName = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
    _firstName.dispose();
    _lastName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthExceptions) {
            await showErrorDialog(context, 'Weak Passowrd');
          } else if (state.exception is EmailAlreadyInUseAuthExceptions) {
            await showErrorDialog(context, 'Email already in use');
          } else if (state.exception is GenericAuthExceptions) {
            await showErrorDialog(context, 'Failed to register');
          } else if (state.exception is InvalidEmailAuthExceptions) {
            await showErrorDialog(context, 'Invalid email');
          }
        }
      },
      child: Scaffold(
        body: Container(
          height: size.height,
          // it will take full width
          width: size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.lightGreen,
                        shape: BoxShape.circle,
                      ),
                      height: 40,
                      width: 40,
                    ),
                    TextWidget(
                      text: '  Berchem Pizza',
                      textcolor: Colors.black,
                      textsize: 45,
                      fontWeight: FontWeight.normal,
                    ),
                  ],
                ),
                WSizedBox(wval: 0, hval: 0.2),
                Row(
                  children: [
                    WSizedBox(wval: 0.05, hval: 0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WSizedBox(wval: 0, hval: 0.02),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextWidget(
                              text: 'Create new account',
                              textcolor: Colors.black,
                              textsize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        WSizedBox(wval: 0, hval: 0.03),
                        Row(
                          children: [
                            TextWidget(
                              text: 'Already have an account?',
                              textcolor: Colors.grey,
                              textsize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                            InkWell(
                              onTap: () {
                                
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => const LoginPage(),

                                //     ),
                                //     );
                              },
                              child: TextWidget(
                                text: ' Log in',
                                textcolor: Colors.blue,
                                textsize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        WSizedBox(wval: 0, hval: 0.03),
                        Row(
                          children: [
                            CustomTextField(
                                controller: _firstName,
                                borderradius: 20,
                                bordercolor: Colors.white,
                                widh: 0.15,
                                height: 0.05,
                                icon: Icons.person,
                                iconColor: Colors.grey,
                                hinttext: 'First name ',
                                fontsize: 15,
                                obscureText: false),
                            WSizedBox(wval: 0.02, hval: 0),
                            CustomTextField(
                                controller: _lastName,
                                borderradius: 20,
                                bordercolor: Colors.white,
                                widh: 0.15,
                                height: 0.05,
                                icon: Icons.person,
                                iconColor: Colors.grey,
                                hinttext: 'Last name',
                                fontsize: 15,
                                obscureText: false),
                          ],
                        ),
                        WSizedBox(wval: 0, hval: 0.02),
                        CustomTextField(
                            controller: _email,
                            borderradius: 20,
                            bordercolor: Colors.white,
                            widh: 0.32,
                            height: 0.05,
                            icon: Icons.mail,
                            iconColor: Colors.grey,
                            hinttext: 'Email (required)',
                            fontsize: 15,
                            obscureText: false),
                        WSizedBox(wval: 0, hval: 0.02),
                        CustomTextField(
                            controller: _password,
                            borderradius: 20,
                            bordercolor: Colors.white,
                            widh: 0.32,
                            height: 0.05,
                            icon: Icons.lock,
                            iconColor: Colors.grey,
                            hinttext: 'Password (required)',
                            fontsize: 15,
                            obscureText: false),
                        WSizedBox(wval: 0, hval: 0.02),
                        CustomButton(
                          buttontext: 'Create account',
                          width: 0.20,
                          height: 0.05,
                          bordercolor: Colors.white,
                          borderradius: 25,
                          fontsize: 12,
                          fontweight: FontWeight.bold,
                          fontcolor: Colors.lightGreen,
                          onPressed: () async {
                            final fName = _firstName.text;
                            final lName = _lastName.text;
                            final email = _email.text;
                            final password = _password.text;

                            context.read<AuthBloc>().add(AuthEventRegister(
                                email, password, fName, lName));
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventSendEmailVerification());
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

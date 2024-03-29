import 'package:berchem_pizza_web/languages/language_constants.dart';
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
import 'sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthExceptions) {
            await showErrorDialog(context, 'User not found ');
          } else if (state.exception is WrongPasswordAuthExceptions) {
            await showErrorDialog(context, 'Wrong credentials');
          } else if (state.exception is GenericAuthExceptions) {
            await showErrorDialog(context, 'Authentication error');
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
                      text: translation(context).berchemPizzaText,
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
                              text: translation(context).loginText,
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
                              text:
                                  "${translation(context).dontHaveAnAccountText}?",
                              textcolor: Colors.grey,
                              textsize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(RegisterView.routeName);
                              },
                              child: TextWidget(
                                text: translation(context).signUpText,
                                textcolor: Colors.blue,
                                textsize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        WSizedBox(wval: 0, hval: 0.03),
                        WSizedBox(wval: 0, hval: 0.02),
                        CustomTextField(
                            controller: _email,
                            borderradius: 20,
                            bordercolor: Colors.white,
                            widh: 0.32,
                            height: 0.05,
                            icon: Icons.mail,
                            iconColor: Colors.grey,
                            hinttext: translation(context).email,
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
                            hinttext: translation(context).passwordText,
                            fontsize: 15,
                            obscureText: false),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: CustomButton(
                            buttontext: translation(context).loginText,
                            width: 0.20,
                            height: 0.05,
                            bordercolor: Colors.white,
                            borderradius: 25,
                            fontsize: 12,
                            fontweight: FontWeight.bold,
                            fontcolor: Colors.lightGreen,
                            onPressed: () async {
                              final email = _email.text;
                              final password = _password.text;
                              context.read<AuthBloc>().add(AuthEventLogIn(
                                    email,
                                    password,
                                  ));
                              print("pressed");
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextButton(
                            child:
                                Text(translation(context).forgotPassowrdText),
                            onPressed: () async {
                              final email = _email.text;

                              if (email.isNotEmpty) {
                                context
                                    .read<AuthBloc>()
                                    .add(AuthEventForgotPassword(email));
                              } else {
                                showErrorDialog(
                                    context, "Please Provide Email");
                              }
                            },
                          ),
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

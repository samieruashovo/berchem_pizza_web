import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocks/login/auth/auth_exceptions.dart';
import '../../blocks/login/login_bloc.dart';
import '../../blocks/login/login_event.dart';
import '../../blocks/login/login_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/text_widget.dart';
import '../widgets/wsized.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _cellNo;
  late final TextEditingController _city;
  late final TextEditingController _street;
  late final TextEditingController _apartment;
  late final TextEditingController
      _optional; //floor or apt no or tell us how we can reach you

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _cellNo = TextEditingController();
    _city = TextEditingController();
    _street = TextEditingController();
    _apartment = TextEditingController();
    _optional = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _cellNo.dispose();
    _city.dispose();
    _street.dispose();
    _apartment.dispose();
    _optional.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthExceptions) {
            //await showErrorDialog(context, 'Weak Passowrd');
          } else if (state.exception is EmailAlreadyInUseAuthExceptions) {
            //await showErrorDialog(context, 'Email already in use');
          } else if (state.exception is GenericAuthExceptions) {
            //await showErrorDialog(context, 'Failed to register');
          } else if (state.exception is InvalidEmailAuthExceptions) {
            //await showErrorDialog(context, 'Invalid email');
          }
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.all(50),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.blue,
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
                                    TextWidget(
                                      text: ' Log in',
                                      textcolor: Colors.blue,
                                      textsize: 18,
                                      fontWeight: FontWeight.normal,
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
                                        icon: Icons.credit_card,
                                        iconColor: Colors.grey,
                                        hinttext: 'first name',
                                        hintColor: Colors.grey,
                                        fontsize: 15,
                                        obscureText: false),
                                    WSizedBox(wval: 0.02, hval: 0),
                                    CustomTextField(
                                        controller: _lastName,
                                        borderradius: 20,
                                        bordercolor: Colors.white,
                                        widh: 0.15,
                                        height: 0.05,
                                        icon: Icons.credit_card,
                                        iconColor: Colors.grey,
                                        hinttext: 'last name',
                                        hintColor: Colors.grey,
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
                                    hinttext: 'email',
                                    hintColor: Colors.grey,
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
                                    hinttext: 'password',
                                    hintColor: Colors.grey,
                                    fontsize: 15,
                                    obscureText: true),
                                WSizedBox(wval: 0, hval: 0.02),
                                CustomTextField(
                                  controller: _city,
                                  borderradius: 20,
                                  bordercolor: Colors.white,
                                  widh: 0.32,
                                  height: 0.05,
                                  icon: Icons.lock,
                                  iconColor: Colors.grey,
                                  hinttext: 'city',
                                  hintColor: Colors.grey,
                                  fontsize: 15,
                                  obscureText: false,
                                ),
                                WSizedBox(wval: 0, hval: 0.02),
                                CustomTextField(
                                  controller: _street,
                                  borderradius: 20,
                                  bordercolor: Colors.white,
                                  widh: 0.32,
                                  height: 0.05,
                                  icon: Icons.lock,
                                  iconColor: Colors.grey,
                                  hinttext: 'street',
                                  hintColor: Colors.grey,
                                  fontsize: 15,
                                  obscureText: false,
                                ),
                                WSizedBox(wval: 0, hval: 0.02),
                                CustomTextField(
                                  controller: _apartment,
                                  borderradius: 20,
                                  bordercolor: Colors.white,
                                  widh: 0.32,
                                  height: 0.05,
                                  icon: Icons.lock,
                                  iconColor: Colors.grey,
                                  hinttext: 'apartment',
                                  hintColor: Colors.grey,
                                  fontsize: 15,
                                  obscureText: false,
                                ),
                                WSizedBox(wval: 0, hval: 0.02),
                                CustomTextField(
                                  controller: _optional,
                                  borderradius: 20,
                                  bordercolor: Colors.white,
                                  widh: 0.32,
                                  height: 0.05,
                                  icon: Icons.lock,
                                  iconColor: Colors.grey,
                                  hinttext: 'optional',
                                  hintColor: Colors.grey,
                                  fontsize: 15,
                                  obscureText: false,
                                ),
                                WSizedBox(wval: 0, hval: 0.02),
                                CustomButton(
                                  buttontext: 'create account',
                                  width: 0.20,
                                  height: 0.05,
                                  bordercolor: Colors.white,
                                  borderradius: 25,
                                  fontsize: 12,
                                  fontweight: FontWeight.bold,
                                  fontcolor: Colors.white,
                                  onPressed: () async {
                                    final name = _firstName.text;
                                    final email = _email.text;
                                    final password = _password.text;
                                    final city = _city.text;
                                    final street = _street.text;
                                    final apartment = _apartment.text;
                                    final optional = _optional.text;
                                    context.read<AuthBloc>().add(
                                        AuthEventRegister(email, password, name,
                                            city, street, apartment, optional));
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
            ],
          ),
        ),
      ),
      /*
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter your name',
              ),
              controller: _name,
              enableSuggestions: false,
              autocorrect: false,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Enter your email'),
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter your password',
              ),
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter your apartment',
              ),
              controller: _apartment,
              
              enableSuggestions: false,
              autocorrect: false,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter your city',
              ),
              controller: _city,
              enableSuggestions: false,
              autocorrect: false,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter your street',
              ),
              controller: _street,
              enableSuggestions: false,
              autocorrect: false,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter your optional',
              ),
              controller: _optional,
              enableSuggestions: false,
              autocorrect: false,
            ),
            TextButton(
                onPressed: () async {
                  final name = _name.text;
                  final email = _email.text;
                  final password = _password.text;
                  final city = _city.text;
                  final street = _street.text;
                  final apartment = _apartment.text;
                  final optional = _optional.text;
                  context.read<AuthBloc>().add(AuthEventRegister(email,
                      password, name, city, street, apartment, optional));
                },
                child: const Text('Register')),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEventLogOut());
              },
              child: const Text('Already registered? Login Here!'),
            ),
          ],
        ),
      ),*/
    );
  }
}

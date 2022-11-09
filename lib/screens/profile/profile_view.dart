// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_typing_uninitialized_variables

import 'package:berchem_pizza_web/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blocks/login/login_bloc.dart';
import '../../blocks/login/login_event.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userSnap;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      // setState(() {
      //   userSnap = usersnap;
      // });
    } catch (e) {
      //print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _fNameController = TextEditingController();
    TextEditingController _lNameController = TextEditingController();
    TextEditingController _emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Berchem Pizzza",
          style: TextStyle(color: kPrimaryColor, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Center(
                    child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "MY PROFILE",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      padding: const EdgeInsets.all(15),
                      child: TextField(
                        controller: _fNameController,
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.black),
                          ),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          labelText: userSnap['firstName'],
                          hintText: userSnap['firstName'],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      padding: const EdgeInsets.all(15),
                      child: TextField(
                        controller: _lNameController,
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.black),
                          ),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          hintText: userSnap['lastName'],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      padding: const EdgeInsets.all(15),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.black),
                          ),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          //labelText: userSnap['firstName'],
                          hintText: userSnap['email'],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userSnap['uid'])
                            .update({"firstName": _fNameController.text});
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userSnap['uid'])
                            .update({"lastName": _lNameController.text});
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                      child: const Text("Update Info"),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final email = userSnap['email'];
                        context.read<AuthBloc>().add(AuthEventForgotPassword(
                              email,
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                      child: const Text("Send password reset link"),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                    
                        context.read<AuthBloc>().add(const AuthEventLogOut());
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                      child: const Text("Logout"),
                    ),
                  ],
                ));
              default:
                return const Center(
                    child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    backgroundColor: kPrimaryColor,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ));
            }
          }),
    );
  }
}

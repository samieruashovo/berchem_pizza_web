import 'package:berchem_pizza_web/screens/widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userSnap;
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    try {
      var usersnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      setState(() {
        userSnap = usersnap;
      });
      print(FirebaseAuth.instance.currentUser!.uid);
      print(userSnap['firstName']);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _fNameController = TextEditingController();
    TextEditingController _lNameController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _mobileController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: const Text(
          "Berchem Pizzza",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
            "MY PROFILE",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 50,
          ),
          CustomTextField(
              controller: _fNameController,
              borderradius: 20,
              bordercolor: Colors.grey[300]!,
              widh: 0.32,
              height: 0.05,
              iconColor: Colors.grey,
              hinttext: userSnap['firstName'],
              hintColor: Colors.black,
              fontsize: 15,
              obscureText: false),
          const SizedBox(
            height: 5,
          ),
          CustomTextField(
              controller: _lNameController,
              borderradius: 20,
              bordercolor: Colors.grey[300]!,
              widh: 0.32,
              height: 0.05,
              iconColor: Colors.grey,
              hinttext: userSnap['lastName'],
              hintColor: Colors.black,
              fontsize: 15,
              obscureText: false),
          const SizedBox(
            height: 5,
          ),
          CustomTextField(
              controller: _emailController,
              borderradius: 20,
              bordercolor: Colors.grey[300]!,
              widh: 0.32,
              height: 0.05,
              iconColor: Colors.grey,
              hinttext: userSnap['email'],
              hintColor: Colors.black,
              fontsize: 15,
              obscureText: false),
          const SizedBox(
            height: 5,
          ),
          CustomButton(
            buttontext: 'Update Info',
            width: 0.20,
            height: 0.05,
            bordercolor: Colors.white,
            borderradius: 25,
            fontsize: 12,
            fontweight: FontWeight.bold,
            fontcolor: Colors.lightGreen,
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
          ),
        ],
      )),
    );
  }
}

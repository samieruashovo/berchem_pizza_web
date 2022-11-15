// ignore_for_file: avoid_web_libraries_in_flutter, prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers

import 'package:berchem_pizza_web/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'dart:html';

import '../screens/widgets/custom_textfield.dart';

class UploadItem extends StatefulWidget {
  const UploadItem({super.key});

  @override
  State<UploadItem> createState() => _UploadItemState();
}

class _UploadItemState extends State<UploadItem> {
  bool imageAvailable = false;
  String? imgUrl;
  FirebaseStorage storage = FirebaseStorage.instance;
  var file;
  var fileName;
  @override
  Widget build(BuildContext context) {
    uploadToStorage() {
      String? downloadUrl;
      FileUploadInputElement input = FileUploadInputElement()
        ..accept = 'image/*';
      FirebaseStorage fs = FirebaseStorage.instance;
      input.click();
      input.onChange.listen((event) {
        file = input.files!.first;
        fileName = input.files!.first.name;
        final reader = FileReader();
        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen((event) async {
          var snapshot = await fs.ref().child(fileName).putBlob(file);
          downloadUrl = await snapshot.ref.getDownloadURL();
          imgUrl = "";
          if (downloadUrl != null) {
            setState(() {
              imgUrl = downloadUrl;
            });
          }
        });
      });
    }

    Future<void> _upload(String imgLink, String name, String priceId,
        String price, String category, String description) async {
      String postId = const Uuid().v1();
      try {
        Product post = Product(
          id: postId,
          priceId: priceId,
          name: name,
          category: category,
          description: description,
          imageUrl: imgLink,
          price: price,
          // extra: "",
        );
        FirebaseFirestore.instance
            .collection('products')
            .doc(postId)
            .set(post.toJson());
        Fluttertoast.showToast(msg: "Uploaded Successfully");
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
        //print(e.toString());
      }
    }

    Widget? addDescription() {
      TextEditingController? _name = TextEditingController();
      TextEditingController? _priceId = TextEditingController();
      TextEditingController? _details = TextEditingController();
      TextEditingController? _price = TextEditingController();
      TextEditingController? _category = TextEditingController();
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                // _pickImage();
                uploadToStorage();
              },
              child: imgUrl == null
                  ? Container(
                      height: 300,
                      width: 300,
                      color: Colors.grey[300],
                    )
                  : SizedBox(
                      height: 300,
                      width: 300,
                      child: Image.network(
                        imgUrl!,
                        fit: BoxFit.contain,
                      ),
                    ),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
                controller: _name,
                borderradius: 20,
                bordercolor: Colors.white,
                widh: 0.32,
                height: 0.05,
                // icon: Icons.lock,
                iconColor: Colors.grey,
                hinttext: 'Product name',
                fontsize: 15,
                obscureText: false),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
                controller: _priceId,
                borderradius: 20,
                bordercolor: Colors.white,
                widh: 0.32,
                height: 0.05,
                // icon: Icons.lock,
                iconColor: Colors.grey,
                hinttext: 'Price Id',
                fontsize: 15,
                obscureText: false),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
                controller: _price,
                borderradius: 20,
                bordercolor: Colors.white,
                widh: 0.32,
                height: 0.05,
                //icon: Icons.lock,
                iconColor: Colors.grey,
                hinttext: 'Product price',
                fontsize: 15,
                obscureText: false),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
                controller: _details,
                borderradius: 20,
                bordercolor: Colors.white,
                widh: 0.32,
                height: 0.05,
                //icon: Icons.lock,
                iconColor: Colors.grey,
                hinttext: 'Product details',
                fontsize: 15,
                obscureText: false),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
                controller: _category,
                borderradius: 20,
                bordercolor: Colors.white,
                widh: 0.32,
                height: 0.05,
                //icon: Icons.,
                iconColor: Colors.grey,
                hinttext: 'Product category',
                fontsize: 15,
                obscureText: false),
            ElevatedButton(
                onPressed: () {
                  _upload(imgUrl!, _name.text, _priceId.text, _price.text,
                      _category.text, _details.text);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    textStyle: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
                child: const Text("Upload"))
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        title: const Text("Upload product"),
      ),
      body: addDescription(),
    );
  }
}

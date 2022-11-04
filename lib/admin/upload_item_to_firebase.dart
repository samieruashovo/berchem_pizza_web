import 'package:berchem_pizza_web/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
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
        final reader = FileReader();
        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen((event) async {
          var snapshot = await fs.ref().child('newfile').putBlob(file);
          downloadUrl = await snapshot.ref.getDownloadURL();
          if (downloadUrl != null) {
            setState(() {
              imgUrl = downloadUrl;
            });
          }
        });
      });
    }

    Future<void> _upload(String imgLink, String name, String price,
        String category, String description) async {
      String postId = const Uuid().v1();
      try {
        Product post = Product(
            id: postId,
            name: name,
            category: category,
            description: description,
            imageUrl: imgLink,
            price: price);
        FirebaseFirestore.instance
            .collection('products')
            .doc(postId)
            .set(post.toJson());
        Fluttertoast.showToast(msg: "Uploaded Successfully");
      } catch (e) {
        print(e.toString());
      }
    }

    Widget? addDescription() {
      TextEditingController? _name = TextEditingController();
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
                  ? const Placeholder(
                      fallbackHeight: 200,
                      fallbackWidth: 400,
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
                hintColor: Colors.grey,
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
                hintColor: Colors.grey,
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
                hintColor: Colors.grey,
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
                hintColor: Colors.grey,
                fontsize: 15,
                obscureText: false),
            ElevatedButton(
                onPressed: () {
                  _upload(imgUrl!, _name.text, _price.text, _category.text,
                      _details.text);
                },
                child: const Icon(Icons.upload))
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload product"),
      ),
      body: addDescription(),
    );
  }
}

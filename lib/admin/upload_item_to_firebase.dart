import 'dart:convert';
import 'dart:io';

import 'package:berchem_pizza_web/models/product_model.dart';
import 'package:berchem_pizza_web/screens/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import '../screens/widgets/custom_textfield.dart';
import 'upload_image.dart';

class UploadItem extends StatefulWidget {
  const UploadItem({super.key});

  @override
  State<UploadItem> createState() => _UploadItemState();
}

class _UploadItemState extends State<UploadItem> {
  @override
  Widget build(BuildContext context) {
    FirebaseStorage storage = FirebaseStorage.instance;
    Uint8List? imageFile;
    bool imageAvailable = false;
    //String? photoUrl;

    var fileName;
    var fileBytes;
    _pickImage() async {
      try {
        var result = await FilePicker.platform.pickFiles();
        //print(result);
        if (result!.files.first.bytes != null) {
          setState(() {
            imageAvailable = true;

            fileBytes = result.files.first.bytes;
            fileName = result.files.first.name;
            imageFile = result.files.first.bytes!;
            //imageFile = Image(Utf8Decoder().convert(fileBytes));
          });
        }
        // TaskSnapshot uploadTask =
        //     await FirebaseStorage.instance.ref(fileName).putData(fileBytes);
        // String downloadUrl = await uploadTask.ref.getDownloadURL();
        // if (downloadUrl != null) {
        //   setState(() {
        //     photoUrl = downloadUrl;
        //     print(photoUrl);
        //     print("p");
        //   });
        // }
        // print(photoUrl);
      } catch (e) {
        print(e.toString());
      }
      //return photoUrl;
    }

    Future<void> _upload(
        String name, String price, String category, String description) async {
      String postId = const Uuid().v1();
      try {
        print(fileBytes);
        String photoUrl = await uploadImageToStorage(fileName, fileBytes);
        // if (photoUrl != null) {
        //   setState(() {
        //     purl = photoUrl;
        //   });
        //   print(purl);
        // }
        Product post = Product(
            id: postId,
            name: name,
            category: category,
            description: description,
            imageUrl:photoUrl,
            price: price);
        FirebaseFirestore.instance
            .collection('products')
            .doc('postId')
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
                _pickImage();
              },
              child: Container(
                height: 120,
                width: 120,
                color: Colors.grey,
                child:
                    imageAvailable ? Image.memory(imageFile!) : const SizedBox(),
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
                onPressed: () async {
                  // print(photoUrl);
                  print(_name.text);
                  print(_price.text);
                  print(_category.text);
                  print(_details.text);
                  await _upload(
                      _name.text, _price.text, _category.text, _details.text);
                },
                child: const Icon(Icons.upload))
            // ElevatedButton.icon(
            //   onPressed: () => _upload(imageFile!, _name.text, _price.text,
            //       _category.text, _details.text),
            //   icon: const Icon(Icons.backup_outlined),
            //   label: const Text('Upload'),
            // )
          ],
        ),
      );
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Sell your items'),
      //   backgroundColor: AppColors.deep_orange,
      // ),
      appBar: AppBar(
        title: const Text("Upload product"),
      ),

      body: addDescription(),
      //body: imageFile == null ? _pickImage() : addDescription(),
    );
  }
}

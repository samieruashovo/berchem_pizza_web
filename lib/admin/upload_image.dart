import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';

Future<String> uploadImageToStorage(var fileName, var fileBytes) async {
  print(fileName);
  print(fileBytes);
  TaskSnapshot uploadTask =
      await FirebaseStorage.instance.ref(fileName).putData(fileBytes);
  String downloadUrl = await uploadTask.ref.getDownloadURL();
  print(downloadUrl);
  return downloadUrl;
}


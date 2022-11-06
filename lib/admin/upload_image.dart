import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadImageToStorage(var fileName, var fileBytes) async {
  TaskSnapshot uploadTask =
      await FirebaseStorage.instance.ref(fileName).putData(fileBytes);
  String downloadUrl = await uploadTask.ref.getDownloadURL();
  //print(downloadUrl);
  return downloadUrl;
}


import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> UploadImagetoStorage(
      {required String childName,
      required Uint8List file,
      required bool isPost}) async {
    Reference ref = storage.ref().child(childName).child(auth.currentUser!.uid);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask;
    String downloadURL = await snap.ref.getDownloadURL();
    return downloadURL;
  }

  Future<String> UploadPostIMageToStorage({
    required String childName,
    required Uint8List file,
    required String postID,
  }) async {
    Reference ref = storage
        .ref()
        .child(childName)
        .child(auth.currentUser!.uid)
        .child(postID);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask;
    String downloadURL = await snap.ref.getDownloadURL();
    // print(downloadURL);
    return downloadURL;
  }
}

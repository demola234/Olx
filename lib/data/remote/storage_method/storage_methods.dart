import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageMethods {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(String childName, File file) async {
    Reference _ref = _firebaseStorage.ref().child(_auth.currentUser!.uid);

    UploadTask _uploadTask = _ref.putFile(file);

    TaskSnapshot _snapshot = await _uploadTask;
    String downloadUrl = await _snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}

class StorageMultipleUploadMethods {
  Future<List<String>> uploadImage(List<File> _imageFile) async {
    List<String> _urllist = [];
    try {
      for (var image in _imageFile) {
        Reference reference = FirebaseStorage.instance
            .ref()
            .child('products/${DateTime.now().microsecondsSinceEpoch}');
        UploadTask uploadTask = reference.putFile(image);
        TaskSnapshot downloadUrl = await uploadTask;
        String _url = await downloadUrl.ref.getDownloadURL();
        _urllist.add(_url);
      }
      return _urllist;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    throw (e) {};
  }
}

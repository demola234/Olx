import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/data/remote/storage_method/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/utils/custom_toasts.dart';
import '../../../core/utils/navigator.dart';
import '../../../features/authentication/presentation/view/setprofile/set_profile.dart';

abstract class GoogleAuthServices {
  Future googleAuthentication();
  Future saveDetails(String fullName, File file, String phoneNumber);
  Future saveAddress(String address, double latitude, double longitude);
}

class GoogleAuthServiceImpl implements GoogleAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  CollectionReference users = FirebaseFirestore.instance.collection("user");
  @override
  Future googleAuthentication() async {
    final googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final googleSignInAuth = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuth.accessToken,
        idToken: googleSignInAuth.idToken,
      );

      try {
        final UserCredential _userCredential =
            await _auth.signInWithCredential(credential);
        QuerySnapshot result =
            await users.where("uid", isEqualTo: _auth.currentUser!.uid).get();
        List<DocumentSnapshot> document = result.docs;

        // final User user = _userCredential.user!;

        if (document.isEmpty) {
          Toasts.showSuccessToast("Provide Details");
          NavigationService().replaceScreen(SetProfile(
            isPhone: false,
          ));
        }
        return _userCredential.user;
      } on FirebaseAuthException catch (err) {
        Toasts.showErrorToast(err.toString());
      }
    }
  }

  @override
  Future saveDetails(String fullName, File file, String phoneNumber) async {
    // UserParams userParams;
    String profileImage =
        await StorageMethods().uploadImageToStorage("profileImage", file);
    try {
      FirebaseFirestore.instance
          .collection("user")
          .doc(_auth.currentUser!.uid)
          .set({
        "fullName": fullName,
        "profileImage": profileImage,
        "uid": _auth.currentUser!.uid,
        "emailAddress": _auth.currentUser!.email,
        "phone": phoneNumber,
      });
    } catch (e) {
      Toasts.showErrorToast("Unable to Upload Details");
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  Future saveAddress(String address, double latitude, double longitude) async {
    try {
      FirebaseFirestore.instance
          .collection("user")
          .doc(_auth.currentUser!.uid)
          .update(
              {"address": address, "location": GeoPoint(latitude, longitude)});
    } catch (e) {
      Toasts.showErrorToast("Unable to Set Address");
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}

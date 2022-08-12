// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../../core/utils/custom_toasts.dart';
import '../../../core/utils/navigator.dart';
import '../../../features/authentication/presentation/view/setprofile/set_profile.dart';
import '../storage_method/storage_methods.dart';

abstract class PhoneAuthService {
  Future verifyPhoneNumber(String phoneNumber,
      {required void Function(PhoneAuthCredential)? completed,
      required void Function(FirebaseAuthException)? failed,
      required void Function(String, int?)? codeSent,
      required void Function(String)? codeAutoRetrievalTimeout});

  Future phoneCredential(String verificationId, String otp, String phone);
  Future saveDetails(String fullName, String email, File file);
  Future saveAddress(String address, double latitude, double longitude);
}

class PhoneAuthServiceImpl implements PhoneAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection("user");
  String? verifyId;
  @override
  Future<void> verifyPhoneNumber(String phone,
      {required void Function(PhoneAuthCredential)? completed,
      required void Function(FirebaseAuthException)? failed,
      required void Function(String, int?)? codeSent,
      required void Function(String)? codeAutoRetrievalTimeout}) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: completed!,
      verificationFailed: failed!,
      codeSent: codeSent!,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout!,
    );
  }

  @override
  Future phoneCredential(
      String verificationId, String otp, String phone) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      final authCredential = await _auth.signInWithCredential(credential);
      final User user = authCredential.user!;

      if (user != null) {
        Toasts.showSuccessToast("Verification Completed");
        NavigationService().replaceScreen(const SetProfile(
          isPhone: true,
        ));
      } else {
        Toasts.showErrorToast("Invalid OTP");
      }
    } catch (e) {
      Toasts.showErrorToast("Invalid OTP");
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  Future saveDetails(String fullName, String email, File file) async {
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
        "emailAddress": email,
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

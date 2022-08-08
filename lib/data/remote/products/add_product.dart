import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/features/authentication/data/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../../core/utils/custom_nav_bar.dart';
import '../../../core/utils/custom_toasts.dart';
import '../../../core/utils/navigator.dart';
import '../../../features/add_product/presentation/view/review_details.dart';
import '../storage_method/storage_methods.dart';

abstract class AddProductService {
  Future addProducts(String productName, int price, String category,
      String shippingType, String desc, List<File> file);

  Future fetchUsersDetails();
  Future updateUserDetails(
      String fullName, String phone, String emailAddress, String address);
}

class AddProductServiceImpl extends AddProductService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future addProducts(String productName, int price, String category,
      String shippingType, String desc, List<File> file) async {
    try {
      var productImage = await StorageMultipleUploadMethods().uploadImage(file);
      final productId = FirebaseFirestore.instance.collection("product").doc();
      await productId.set({
        "id": productId.id,
        "user_id": _auth.currentUser!.uid,
        "product_name": productName,
        "price": price,
        "category": category,
        "shipping_type": shippingType,
        "description": desc,
        "images": productImage,
        "created_at": DateTime.now(),
      });
      NavigationService().navigateToScreen(const ReviewDetails());
    } catch (e) {
      Toasts.showErrorToast("Unable to Upload Product Details");
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  Future<UserParams> fetchUsersDetails() async {
    DocumentSnapshot<Map<String, dynamic>> user =
        await _db.collection("user").doc(_auth.currentUser!.uid).get();

    if (user.exists || user.data != null) {
      return UserParams();
    }
    return UserParams.fromMap(user);
  }

  @override
  Future updateUserDetails(String fullName, String phone, String emailAddress,
      String address) async {
    try {
      FirebaseFirestore.instance
          .collection("user")
          .doc(_auth.currentUser!.uid)
          .update({
        "fullName": fullName,
        "phone": phone,
        "emailAddress": emailAddress,
        "address": address,
      });

      FirebaseFirestore.instance
          .collection("user")
          .doc(_auth.currentUser!.uid)
          .update({
        "details": {
          "fullName": fullName,
          "phone": phone,
          "emailAddress": emailAddress,
          "address": address,
        }
      });
      NavigationService().replaceScreen(NavBar());
    } catch (e) {
      Toasts.showErrorToast("Details Unable to be Updated");
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}

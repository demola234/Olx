// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserParams {
  String? uid;
  String? fullName;
  String? emailAddress;
  String? profileImage;
  String? address;
  String? phone;
  GeoPoint? location;

  UserParams({
    this.uid,
    this.fullName,
    this.emailAddress,
    this.profileImage,
    this.address,
    this.phone,
    this.location,
  });

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "fullName": fullName,
        "emailAddress": emailAddress,
        "profileImage": profileImage,
        "address": address,
        "location": location,
         "phone": phone,
      };

  UserParams.fromMap(DocumentSnapshot<Map<String, dynamic>> map)
      : uid = map['uid'] as String,
        fullName = map['fullName'] as String,
        emailAddress = map['emailAddress'] as String,
        profileImage = map['profileImage'] as String,
        address = map['address'] as String,
        phone = map['phone'] as String,
        location = map['location'];
}

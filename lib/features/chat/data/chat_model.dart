import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String message;
  String sentBy;
  Timestamp time;

  MessageModel({
    required this.message,
    required this.sentBy,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'sentBy': sentBy,
      'time': time
    };
  }

  MessageModel.fromMap(DocumentSnapshot<Map<String, dynamic>> map)
      : message = map['message'] as String,
        sentBy = map['sentBy'] as String,
        time = map['time'];

  String toJson() => json.encode(toMap());
}

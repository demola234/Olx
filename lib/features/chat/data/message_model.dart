// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailsModel {
  String sellerId;
  String buyerId;
  String productImage;
  String productName;
  int price;
  ProductDetailsModel({
    required this.sellerId,
    required this.buyerId,
    required this.productImage,
    required this.productName,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sellerId': sellerId,
      'buyerId': buyerId,
      'productImage': productImage,
      'productName': productName,
      'price': price,
    };
  }

  ProductDetailsModel.fromMap(Map<String, dynamic> map)
      : sellerId = map['sellerId'] as String,
        buyerId = map['buyerId'] as String,
        productImage = map['productImage'] as String,
        productName = map['productName'] as String,
        price = map['price'] as int;

  String toJson() => json.encode(toMap());
}

class ChatModel {
  String uid;
  String roomId;
  List<ProductDetailsModel> product;
  Timestamp lastChat;
  String? lastMessage;
  ChatModel({
    required this.uid,
    required this.roomId,
    required this.product,
    required this.lastChat,
    required this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'roomId': roomId,
      'product': product.map((x) => x.toMap()).toList(),
      'lastChat': lastChat,
      'lastMessage': lastMessage,
    };
  }

  ChatModel.fromMap(DocumentSnapshot<Map<String, dynamic>> map)
      : uid = map['uid'] as String,
        roomId = map['roomId'] as String,
        product = List<ProductDetailsModel>.from(
            map["product"].map((x) => ProductDetailsModel.fromMap(x))),
        lastChat = map['lastChat'],
        lastMessage = map['lastMessage'];

  String toJson() => json.encode(toMap());
}

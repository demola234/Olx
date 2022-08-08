import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String id;
  String productName;
  Timestamp createdAt;
  String shippingType;
  List<String> images;
  String userId;
  int price;
  String description;
  String category;
  ProductModel({
    required this.id,
    required this.productName,
    required this.createdAt,
    required this.shippingType,
    required this.images,
    required this.userId,
    required this.price,
    required this.description,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'productName': productName,
      'createdAt': createdAt,
      'shippingType': shippingType,
      'images': images,
      'userId': userId,
      'price': price,
      'description': description,
      'category': category,
    };
  }

  ProductModel.fromMap(DocumentSnapshot<Map<String, dynamic>> map)
      : id = map['id'] as String,
        productName = map['product_name'] as String,
        createdAt = map['created_at'] as Timestamp,
        shippingType = map['shipping_type'] as String,
        images = List<String>.from((map['images'])),
        userId = map['user_id'] as String,
        price = map['price'] as int,
        description = map['description'] as String,
        category = map['category'] as String;
}

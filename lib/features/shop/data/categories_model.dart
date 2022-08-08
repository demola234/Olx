import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String? id;
  String category;
  String image;

  CategoryModel({
    this.id,
    required this.category,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'Category': category,
      'Image': image,
    };
  }

  CategoryModel.fromMap(DocumentSnapshot<Map<String, dynamic>> map)
      : category = map['Category'] as String,
        id = map['id'] as String,
        image = map['Image'] as String;
}

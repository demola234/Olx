import 'dart:convert';

import 'package:ecommerce/core/constants/image_assets.dart';

class ProductModel {
  int uid;
  String productName;
  ImageType image;
  String price;
  String description;
  String category;
  User user;

  ProductModel({
    required this.uid,
    required this.productName,
    required this.image,
    required this.price,
    required this.description,
    required this.category,
    required this.user,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'product_name': productName,
      'image': image,
      'price': price,
      'description': description,
      'category': category,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      uid: map['uid'] as int,
      productName: map['product_name'] as String,
      image: ImageType.fromMap(map['image'] as Map<String, dynamic>),
      price: map['price'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      user: User.fromMap(map['user'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ImageType {
  List<String> image;
  ImageType({
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image': image,
    };
  }

  factory ImageType.fromMap(Map<String, dynamic> map) {
    return ImageType(
        image: List<String>.from(
      (map['image'] as List<String>),
    ));
  }

  String toJson() => json.encode(toMap());

  factory ImageType.fromJson(String source) =>
      ImageType.fromMap(json.decode(source) as Map<String, dynamic>);
}

class User {
  String username;
  String userLocation;
  String userNumber;
  User({
    required this.username,
    required this.userLocation,
    required this.userNumber,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'user_location': userLocation,
      'user_number': userNumber,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] as String,
      userLocation: map['user_location'] as String,
      userNumber: map['user_number'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}

List<ProductModel> products = <ProductModel>[
  ProductModel(
      uid: 1,
      productName: "MacBook Air M1",
      price: "860,999",
      description:
          "With the M2 chip get more out of your MacBook Pro 13inch 2022 as it begins the next generation of Apple silicon, with even more of the speed and power efficiency introduced by M1. So you can rip through workflows with a more powerful 8-core CPU. Create stunning graphics with a lightning‑fast 10‑core GPU. Work with more streams of 4K and 8K ProRes video with the high-performance media engine. And do it all at once with up to 24GB of faster-unified memory. Up to 1.4x faster than M1 model Up to 6x faster than the Intel-based model Up to 20 hours of battery life Thermal efficiency. Active cooling sustains blazing‑fast performance. Thanks to its advanced thermal system and the efficiency of Apple silicon, MacBook Pro 13inch can sustain pro levels of performance, so you can run CPU and GPU intensive tasks for hours on end. New Security. The M2 chip and macOS give MacBook Pro 13inch 2022 more security and privacy features beyond anything in its class. With built‑in protection against malware and viruses, the freedom to choose what you share and how you share it, and silicon‑level features like Touch ID and Apple Pay. Built to safeguard your privacy and data at every stage.",
      category: "Laptop",
      image: ImageType(
        image: [
          ImagesAsset.product1,
          "",
          "",
          "",
        ],
      ),
      user: User(
        username: "Ademola",
        userLocation: "Okene, Lagos, Nigeria",
        userNumber: "08032323232",
      )),
  ProductModel(
      uid: 2,
      productName: "MacBook Air M1",
      price: "860,999",
      description:
          "With the M2 chip get more out of your MacBook Pro 13inch 2022 as it begins the next generation of Apple silicon, with even more of the speed and power efficiency introduced by M1. So you can rip through workflows with a more powerful 8-core CPU. Create stunning graphics with a lightning‑fast 10‑core GPU. Work with more streams of 4K and 8K ProRes video with the high-performance media engine. And do it all at once with up to 24GB of faster-unified memory. Up to 1.4x faster than M1 model Up to 6x faster than the Intel-based model Up to 20 hours of battery life Thermal efficiency. Active cooling sustains blazing‑fast performance. Thanks to its advanced thermal system and the efficiency of Apple silicon, MacBook Pro 13inch can sustain pro levels of performance, so you can run CPU and GPU intensive tasks for hours on end. New Security. The M2 chip and macOS give MacBook Pro 13inch 2022 more security and privacy features beyond anything in its class. With built‑in protection against malware and viruses, the freedom to choose what you share and how you share it, and silicon‑level features like Touch ID and Apple Pay. Built to safeguard your privacy and data at every stage.",
      category: "Laptop",
      image: ImageType(
        image: [
          ImagesAsset.product1,
          ImagesAsset.product3,
          ImagesAsset.product2,
        ],
      ),
      user: User(
        username: "Ademola",
        userLocation: "Okene, Lagos, Nigeria",
        userNumber: "08032323232",
      )),
  ProductModel(
      uid: 3,
      productName: "MacBook Air M1",
      price: "860,999",
      description:
          "With the M2 chip get more out of your MacBook Pro 13inch 2022 as it begins the next generation of Apple silicon, with even more of the speed and power efficiency introduced by M1. So you can rip through workflows with a more powerful 8-core CPU. Create stunning graphics with a lightning‑fast 10‑core GPU. Work with more streams of 4K and 8K ProRes video with the high-performance media engine. And do it all at once with up to 24GB of faster-unified memory. Up to 1.4x faster than M1 model Up to 6x faster than the Intel-based model Up to 20 hours of battery life Thermal efficiency. Active cooling sustains blazing‑fast performance. Thanks to its advanced thermal system and the efficiency of Apple silicon, MacBook Pro 13inch can sustain pro levels of performance, so you can run CPU and GPU intensive tasks for hours on end. New Security. The M2 chip and macOS give MacBook Pro 13inch 2022 more security and privacy features beyond anything in its class. With built‑in protection against malware and viruses, the freedom to choose what you share and how you share it, and silicon‑level features like Touch ID and Apple Pay. Built to safeguard your privacy and data at every stage.",
      category: "Laptop",
      image: ImageType(
        image: [
          ImagesAsset.product1,
          "",
          "",
          "",
        ],
      ),
      user: User(
        username: "Ademola",
        userLocation: "Okene, Lagos, Nigeria",
        userNumber: "08032323232",
      )),
  ProductModel(
      uid: 4,
      productName: "MacBook Air M1",
      price: "860,999",
      description:
          "With the M2 chip get more out of your MacBook Pro 13inch 2022 as it begins the next generation of Apple silicon, with even more of the speed and power efficiency introduced by M1. So you can rip through workflows with a more powerful 8-core CPU. Create stunning graphics with a lightning‑fast 10‑core GPU. Work with more streams of 4K and 8K ProRes video with the high-performance media engine. And do it all at once with up to 24GB of faster-unified memory. Up to 1.4x faster than M1 model Up to 6x faster than the Intel-based model Up to 20 hours of battery life Thermal efficiency. Active cooling sustains blazing‑fast performance. Thanks to its advanced thermal system and the efficiency of Apple silicon, MacBook Pro 13inch can sustain pro levels of performance, so you can run CPU and GPU intensive tasks for hours on end. New Security. The M2 chip and macOS give MacBook Pro 13inch 2022 more security and privacy features beyond anything in its class. With built‑in protection against malware and viruses, the freedom to choose what you share and how you share it, and silicon‑level features like Touch ID and Apple Pay. Built to safeguard your privacy and data at every stage.",
      category: "Laptop",
      image: ImageType(
        image: [
          ImagesAsset.product1,
          "",
          "",
          "",
        ],
      ),
      user: User(
        username: "Ademola",
        userLocation: "Okene, Lagos, Nigeria",
        userNumber: "08032323232",
      )),
];

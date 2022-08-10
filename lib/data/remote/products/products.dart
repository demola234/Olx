import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/features/authentication/data/user_model.dart';
import 'package:ecommerce/features/shop/data/product_model.dart';

abstract class ProductService {
  Future<List<ProductModel>> fetchAllProducts();

  Future<ProductModel> fetchSingleProduct(String documentId);

  Future updateProduct(ProductModel productModel);

  Future deleteProduct(String documentId);

  Future addProduct(ProductModel productModel);

  Future<UserParams> fetchSingleUser(String userId);

  searchForProducts(String item);

  Future<List<ProductModel>>? fetchProductbyCategory(String category);

  Future<List<ProductModel>>? fetchMyProduct(String userId);

  Future<List<ProductModel>>? getFavoriteItems(String userId);

  Future addBookmarkedItems(String productId, String userId);
}

class ProductServiceImpl implements ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<List<ProductModel>> fetchAllProducts() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("product").get();
    return snapshot.docs
        .map((docSnapshot) => ProductModel.fromMap(docSnapshot))
        .toList();
  }

  @override
  Future deleteProduct(String documentId) async {
    await _db.collection("product").doc(documentId).delete();
  }

  @override
  Future<ProductModel> fetchSingleProduct(String documentId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("product").doc(documentId).get();
    return ProductModel.fromMap(snapshot);
  }

  @override
  Future<List<ProductModel>>? fetchProductbyCategory(String category) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("product")
        .where("category", isEqualTo: category)
        .get();
    print(snapshot.docs);
    return snapshot.docs
        .map((docSnapshot) => ProductModel.fromMap(docSnapshot))
        .toList();
  }

  @override
  Future<List<ProductModel>>? getFavoriteItems(String userId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("product")
        .where("bookmarked", arrayContainsAny: [userId]).get();
    print(snapshot.docs);
    return snapshot.docs
        .map((docSnapshot) => ProductModel.fromMap(docSnapshot))
        .toList();
  }

  @override
  Future addBookmarkedItems(String productId, String userId) async {
    await _db.collection("product").doc(productId).update({
      "bookedmarked": FieldValue.arrayUnion([userId])
    });
  }

  @override
  Future deleteBookmarkedItems(String productId, String userId) async {
    await _db.collection("product").doc(productId).update({
      "bookedmarked": FieldValue.arrayRemove([userId])
    });
  }

  @override
  Future updateProduct(ProductModel productModel) async {
    await _db
        .collection("product")
        .doc(productModel.id)
        .update(productModel.toMap());
  }

  @override
  Future addProduct(ProductModel productModel) async {
    await _db.collection("product").add(productModel.toMap());
  }

  @override
  Future<UserParams> fetchSingleUser(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("user").doc(userId).get();
    return UserParams.fromMap(snapshot);
  }

  @override
  searchForProducts(String item) async {
    var snapshot = await _db
        .collection('items')
        .where("searchKeywords", arrayContains: item)
        .snapshots();
    return snapshot.toList();
  }

  @override
  Future<List<ProductModel>>? fetchMyProduct(String userId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("product")
        .where("user_id", isEqualTo: userId)
        .get();
    print(snapshot.docs);
    return snapshot.docs
        .map((docSnapshot) => ProductModel.fromMap(docSnapshot))
        .toList();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../features/shop/data/categories_model.dart';

abstract class CategoriesService {
  Future<List<CategoryModel>> fetchAllCategories();

  Future fetchSingleCategory(String documentId);

  Future updateCategory(CategoryModel categoryModel);

  Future deleteCategory(String documentId);

  Future addCategory(CategoryModel categoryModel);
}

class CategoriesServiceImpl implements CategoriesService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<List<CategoryModel>> fetchAllCategories() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("categories").get();
    return snapshot.docs
        .map((docSnapshot) => CategoryModel.fromMap(docSnapshot))
        .toList();
  }

  @override
  Future deleteCategory(String documentId) async {
    await _db.collection("categories").doc(documentId).delete();
  }

  @override
  Future fetchSingleCategory(String documentId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("categories").doc(documentId).get();
    return snapshot;
  }

  @override
  Future updateCategory(CategoryModel categoryModel) async {
    await _db
        .collection("categories")
        .doc(categoryModel.id)
        .update(categoryModel.toMap());
  }

  @override
  Future addCategory(CategoryModel categoryModel) async {
    await _db.collection("categories").add(categoryModel.toMap());
  }
}

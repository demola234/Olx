import 'dart:io';
import 'package:ecommerce/features/add_product/presentation/provider/product_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../data/remote/products/add_product.dart';
import '../../../../di/di.dart';
import '../../../shop/data/categories_model.dart';

class CategoriesProvider with ChangeNotifier {
  var productServices = getIt<AddProductService>();

  ProductState _productState = ProductState.initial;

  ProductState get productState => _productState;

  set productStateChange(ProductState productState) {
    _productState = productState;
    notifyListeners();
  }

  late AsyncSnapshot<List<CategoryModel>> docs;
  late String selectedCategories;
  List<String> urlList = [];


  Future addProduct(String productName, String price, String category,
      String shippingType, String desc, List<File> file) async {
    productStateChange = ProductState.loading;
    try {
      await productServices.addProducts(
          productName, int.parse(price), category, shippingType, desc, file);

      notifyListeners();
      productStateChange = ProductState.success;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future updateDetails(String fullName, String phone, String emailAddress,
      String address) async {
    productStateChange = ProductState.loading;
    try {
      await productServices.updateUserDetails(
          fullName, phone, emailAddress, address);
      notifyListeners();
      productStateChange = ProductState.success;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}

import 'package:ecommerce/features/add_product/presentation/provider/product_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../data/remote/products/products.dart';
import '../../../../di/di.dart';
import '../../../shop/data/categories_model.dart';

class SaveProductProvider with ChangeNotifier {
  var productServices = getIt<ProductService>();

  ProductState _productState = ProductState.initial;

  ProductState get productState => _productState;

  set productStateChange(ProductState productState) {
    _productState = productState;
    notifyListeners();
  }

  late AsyncSnapshot<List<CategoryModel>> docs;
  late String selectedCategories;
  List<String> urlList = [];

  Future delete(String productId) async {
    productStateChange = ProductState.loading;
    try {
      await productServices.deleteProduct(productId);

      notifyListeners();
      productStateChange = ProductState.success;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:ecommerce/core/utils/config.dart';
import 'package:ecommerce/features/shop/data/product_model.dart';
import 'package:ecommerce/features/shop/presentation/view/home.dart';
import 'package:flutter/material.dart';

import '../../../../data/remote/products/products.dart';
import '../../../../di/di.dart';
import '../../../authentication/presentation/view/setprofile/set_location.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({Key? key}) : super(key: key);

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  var productService = getIt<ProductService>();

  Future<List<ProductModel>>? productList;
  List<ProductModel>? retrievedProductList;
  var currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _initProductsRetrieval();
  }

  Future<void> _initProductsRetrieval() async {
    productList = productService.fetchMyProduct(currentUser!.uid);
    retrievedProductList =
        await productService.fetchMyProduct(currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: FutureBuilder(
          future: productList,
          builder: (BuildContext context,
              AsyncSnapshot<List<ProductModel>> snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 1 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext ctx, index) {
                  // print(snapshot.data![index].category);
                  return ProductItem(
                      isHotSales: false, products: snapshot.data![index]);
                },
              );
            } else if (snapshot.connectionState == ConnectionState.done &&
                retrievedProductList!.isEmpty) {
              return Center(
                child: ListView(
                  children: const <Widget>[
                    Align(
                        alignment: AlignmentDirectional.center,
                        child: Text('No data available')),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

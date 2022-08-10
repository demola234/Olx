import 'package:ecommerce/core/constants/colors.dart';
import 'package:ecommerce/core/utils/navigator.dart';
import 'package:ecommerce/core/utils/ripple.dart';
import 'package:ecommerce/features/save_product/presentation/provider/save_product_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:ecommerce/core/utils/config.dart';
import 'package:ecommerce/features/shop/data/product_model.dart';
import 'package:ecommerce/features/shop/presentation/view/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    var deleted = Provider.of<SaveProductProvider>(context, listen: false);
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
                  return GestureDetector(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Delete'),
                            content: const Text(
                                'Are you sure you will like to delete this product'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: Text(
                                  'Cancel',
                                  style: Config.b3(context)
                                      .copyWith(color: OlxColor.black),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    deleted.delete(snapshot.data![index].id);
                                    NavigationService().popToFirst();
                                  });
                                },
                                child: Text(
                                  'Delete',
                                  style: Config.b3(context)
                                      .copyWith(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                      print('d');
                    },
                    child: ProductItem(
                        isHotSales: false, products: snapshot.data![index]),
                  );
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

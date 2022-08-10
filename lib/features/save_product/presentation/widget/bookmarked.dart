import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/core/constants/colors.dart';
import 'package:ecommerce/core/utils/config.dart';
import 'package:ecommerce/core/utils/ripple.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/utils/navigator.dart';
import '../../../../data/remote/products/products.dart';
import '../../../../di/di.dart';
import '../../../shop/data/product_model.dart';
import '../../../shop/presentation/view/category_page.dart';
import '../../../shop/presentation/view/product_details.dart';

class Bookmarked extends StatefulWidget {
  const Bookmarked({Key? key}) : super(key: key);

  @override
  State<Bookmarked> createState() => _BookmarkedState();
}

class _BookmarkedState extends State<Bookmarked> {
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
    productList = productService.getFavoriteItems(currentUser!.uid);
    retrievedProductList =
        await productService.fetchMyProduct(currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: productList,
        builder:
            (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: ((context, index) {
                print(snapshot.data![0].productName);
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 15),
                    height: 105,
                    width: context.screenWidth(),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: const Color(0xFFF4F4F4)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: const Color(0xFFF4F4F4)),
                            color: const Color(0xFFF4F4F4),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: snapshot.data![index].images[0]),
                          ),
                        ),
                        const XMargin(8.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data![index].productName,
                              style: Config.b1(context).copyWith(fontSize: 14),
                            ),
                            Text(
                              snapshot.data![index].category,
                              style: Config.b3(context).copyWith(
                                fontSize: 10,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ).ripple(
                    () {
                      NavigationService().navigateToScreen(ProductDetails(
                        productId: snapshot.data![index].id,
                        userId: snapshot.data![index].userId,
                      ));
                    },
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                );
              }),
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
        });
  }
}

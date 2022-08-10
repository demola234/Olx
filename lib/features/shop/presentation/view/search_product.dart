// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/utils/ripple.dart';
import 'package:ecommerce/features/shop/presentation/view/home.dart';
import 'package:ecommerce/features/shop/presentation/view/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:search_page/search_page.dart';

import '../../../../core/constants/image_assets.dart';
import '../../../../core/utils/config.dart';
import '../../../../core/utils/navigator.dart';
import '../../../../data/remote/products/products.dart';
import '../../../../di/di.dart';

class Search {
  var productService = getIt<ProductService>();
  String? searched;
  search(context, List<Product> productsList) {
    showSearch(
      context: context,
      delegate: SearchPage<Product>(
        onQueryUpdate: (s) {
          searched = s;
        },
        items: productsList,
        searchLabel: 'Search people',
        barTheme: ThemeData(
            backgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.amber))),
        searchStyle: TextStyle(
            backgroundColor: Colors.white,
            color: Colors.white,
            decoration: TextDecoration.none),
        suggestion: Center(
          child: Text('Filter people by name, surname or age'),
        ),
        failure: Center(
          child: Text('No person found :('),
        ),
        filter: (p) => [
          p.product_name,
          p.description,
          p.price.toString(),
        ],
        builder: (products) => Column(
          children: [
            YMargin(20),
            GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 1 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount: productsList.length,
                itemBuilder: (BuildContext ctx, index) {
                  return SearchedProduct(products: products);
                }),
          ],
        ),
      ),
    );
  }
}

class SearchedProduct extends StatelessWidget {
  Product products;
  SearchedProduct({
    required this.products,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          Container(
            height: 170,
            width: 170,
            decoration: BoxDecoration(
                color: const Color(0xFFFADEE3),
                borderRadius: BorderRadius.circular(10.5),
                border: Border.all(
                  color: const Color(0xFFF4F4F4),
                )),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.5),
                  child: CachedNetworkImage(
                    imageUrl: products.image,
                    fit: BoxFit.cover,
                  ),
                ).ripple(() {
                  NavigationService().navigateToScreen(ProductDetails(
                    productId: products.id,
                    userId: products.user_id,
                  ));
                }),
                Positioned(
                  top: 10,
                  right: 15,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFF4F4F4)),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: SvgPicture.asset(ImagesAsset.bookmark),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const YMargin(5.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: 80,
                        child: Text(
                          products.product_name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Config.b1(context).copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      NumberFormat.simpleCurrency(name: '₦ ', decimalDigits: 0)
                          .format(products.price),
                      style: Config.b1(context).copyWith(
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const YMargin(5.0),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        products.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Config.b3(context).copyWith(
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Product {
  final String category;
  final Timestamp created_at;
  final DocumentSnapshot document;
  final String description;
  final String id;
  final String image;
  final int price;
  final String product_name;
  final String shipping_type;
  final String user_id;
  Product({
    required this.category,
    required this.created_at,
    required this.description,
    required this.document,
    required this.id,
    required this.image,
    required this.price,
    required this.product_name,
    required this.shipping_type,
    required this.user_id,
  });
}

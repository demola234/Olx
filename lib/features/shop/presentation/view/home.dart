import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/utils/config.dart';
import 'package:ecommerce/core/utils/navigator.dart';
import 'package:ecommerce/features/shop/data/product_model.dart';
import 'package:ecommerce/features/shop/presentation/view/product_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../data/remote/products/categories_services.dart';
import '../../../../data/remote/products/products.dart';
import '../../../../di/di.dart';
import '../../data/categories_model.dart';
import 'categories.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var categoriesService = getIt<CategoriesService>();
  var productService = getIt<ProductService>();
  Future<List<CategoryModel>>? categoryList;
  List<CategoryModel>? retrievedCategoriesList;
  Future<List<ProductModel>>? productList;
  List<ProductModel>? retrievedProductList;

  @override
  void initState() {
    super.initState();
    _initCategoriesRetrieval();
    _initProductsRetrieval();
  }

  Future<void> _initCategoriesRetrieval() async {
    categoryList = categoriesService.fetchAllCategories();
    retrievedCategoriesList = await categoriesService.fetchAllCategories();
  }

  Future<void> _initProductsRetrieval() async {
    productList = productService.fetchAllProducts();
    retrievedProductList = await productService.fetchAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const YMargin(10),
                Row(
                  children: [
                    Container(
                        height: 27,
                        // width: 98,
                        decoration: BoxDecoration(
                            color: const Color(0xFFFAFAFA),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            border: Border.all(color: const Color(0xFFF2F2F2))),
                        child:
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance
                                    .collection("user")
                                    .where("uid",
                                        isEqualTo: FirebaseAuth
                                            .instance.currentUser!.uid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data!.docs.isNotEmpty) {
                                    print(snapshot.data!.docs[0]["address"]);
                                    return Row(
                                      children: [
                                        Icon(Icons.location_on_outlined),
                                        Text(snapshot.data!.docs[0]["address"])
                                      ],
                                    );
                                  } else if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      retrievedCategoriesList!.isEmpty) {
                                    return Center(
                                      child: ListView(
                                        children: const <Widget>[
                                          Align(
                                              alignment:
                                                  AlignmentDirectional.center,
                                              child:
                                                  Text('Location not found')),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return const Center(
                                        child: Text("Loading Location"));
                                  }
                                })),
                  ],
                ),
                const YMargin(20),
                const OlxTextFormField(
                  hintText: "Search for products",
                  prefixIcon: Icon(Icons.search),
                ),
                const YMargin(20),
                ReuseableTitle(
                  name: "Categories",
                  onTap: () {
                    NavigationService().navigateToScreen(const Categories());
                  },
                ),
                const YMargin(20),
                SizedBox(
                  height: 57,
                  width: context.screenWidth(),
                  child: FutureBuilder(
                      future: categoryList,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<CategoryModel>> snapshot) {
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: retrievedCategoriesList!.skip(2).length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return CategoriesTab(
                                  categoryModel: snapshot.data![index]);
                            },
                          );
                        } else if (snapshot.connectionState ==
                                ConnectionState.done &&
                            retrievedCategoriesList!.isEmpty) {
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
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),
                ),
                const YMargin(30),
                ReuseableTitle(
                  name: "Hot Sales",
                  onTap: () {},
                ),
                const YMargin(20),
                SizedBox(
                  height: 250,
                  width: context.screenWidth(),
                  child: FutureBuilder(
                      future: productList,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<ProductModel>> snapshot) {
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: retrievedProductList!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return snapshot.data![index].shippingType ==
                                      "Free Shipping"
                                  ? ProductItem(
                                      isHotSales: true,
                                      products: snapshot.data![index])
                                  : SizedBox.shrink();
                            },
                          );
                        } else if (snapshot.connectionState ==
                                ConnectionState.done &&
                            retrievedCategoriesList!.isEmpty) {
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
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),
                ),
                ReuseableTitle(
                  name: "Recommendation",
                  onTap: () {},
                ),
                const YMargin(20),
                SizedBox(
                  height: 250,
                  width: context.screenWidth(),
                  child: FutureBuilder(
                      future: productList,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<ProductModel>> snapshot) {
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: retrievedProductList!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              // if (snapshot.data[index].shippingType ==)
                              return snapshot.data![index].category ==
                                          "Phone" ||
                                      snapshot.data![index].category == "Laptop"
                                  ? ProductItem(
                                      isHotSales: false,
                                      products: snapshot.data![index])
                                  : SizedBox.shrink();
                            },
                          );
                        } else if (snapshot.connectionState ==
                                ConnectionState.done &&
                            retrievedCategoriesList!.isEmpty) {
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
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final bool isHotSales;
  final ProductModel products;
  const ProductItem({
    required this.isHotSales,
    required this.products,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (kDebugMode) {
          print(products.id);
        }
        NavigationService().navigateToScreen(ProductDetails(
          productId: products.id,
          userId: products.userId,
        ));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 15.0),
        height: 250,
        width: 170,
        child: Column(
          children: [
            Container(
              height: 170,
              width: 170,
              decoration: BoxDecoration(
                  color: const Color(0xFFFADEE3),
                  borderRadius: BorderRadius.circular(10.5)),
              child: Column(
                children: [
                  const YMargin(15.0),
                  SizedBox(
                    width: 127,
                    height: 116,
                    child: CachedNetworkImage(imageUrl: products.images[0]),
                  ),
                  isHotSales
                      ? Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                height: 20,
                                width: 80,
                                decoration: BoxDecoration(
                                    color: const Color(0xFFD8ECEA),
                                    borderRadius: BorderRadius.circular(3.5)),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Free shipping",
                                    style: Config.b2(context).copyWith(
                                      fontSize: 8,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox.shrink()
                ],
              ),
            ),
            const YMargin(5.0),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: 80,
                        child: Text(
                          products.productName,
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
            )
          ],
        ),
      ),
    );
  }
}

class CategoriesTab extends StatelessWidget {
  final CategoryModel categoryModel;
  const CategoriesTab({
    required this.categoryModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Container(
        width: 135,
        height: 54,
        padding: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          border: Border.all(
            color: const Color(0xFFF4F4F4),
          ),
        ),
        child: Row(
          children: [
            Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                    color: OlxColor.olxTextPrimary,
                    borderRadius: BorderRadius.circular(10.5)),
                child: CachedNetworkImage(
                  fit: BoxFit.contain,
                  imageUrl: categoryModel.image,
                )),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                categoryModel.category,
                style: Config.b1(context).copyWith(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReuseableTitle extends StatelessWidget {
  final String name;
  final Function() onTap;
  const ReuseableTitle({
    required this.name,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: Config.b1(context).copyWith(
            fontSize: 16,
          ),
        ),
        InkWell(
          onTap: onTap,
          child: Text(
            "see all",
            style: Config.b2(context).copyWith(
              color: const Color(0xFF6B6B6B),
            ),
          ),
        )
      ],
    );
  }
}

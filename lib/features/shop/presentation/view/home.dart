import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/constants/image_assets.dart';
import 'package:ecommerce/core/utils/config.dart';
import 'package:ecommerce/core/utils/navigator.dart';
import 'package:ecommerce/core/utils/ripple.dart';
import 'package:ecommerce/features/shop/data/product_model.dart';
import 'package:ecommerce/features/shop/presentation/view/product_details.dart';
import 'package:ecommerce/features/shop/presentation/view/search_product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../data/remote/products/categories_services.dart';
import '../../../../data/remote/products/products.dart';
import '../../../../di/di.dart';
import '../../data/categories_model.dart';
import '../widget/search_widget.dart';
import 'categories.dart';
import 'category_page.dart';

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

  Search search = Search();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
          preferredSize: const Size(0, 0)),
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
                        padding: EdgeInsets.all(5),
                        // height: 20,
                        // width: 98,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            border: Border.all(color: const Color(0xFFF2F2F2))),
                        child: StreamBuilder<
                                QuerySnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection("user")
                                .where("uid",
                                    isEqualTo:
                                        FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data!.docs.isNotEmpty) {
                                print(snapshot.data!.docs[0]["address"]);
                                return Row(
                                  children: [
                                    SvgPicture.asset(ImagesAsset.locationIcon),
                                    XMargin(5),
                                    Text(
                                      snapshot.data!.docs[0]["address"],
                                      style: Config.b2(context),
                                    )
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
                                          child: Text('Location not found')),
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
                SearchWidget(),
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

class ProductItem extends StatefulWidget {
  final bool isHotSales;
  final ProductModel products;
  ProductItem({
    required this.isHotSales,
    required this.products,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  var currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (kDebugMode) {
            print(widget.products.id);
          }
        },
        child: Container(
          padding: const EdgeInsets.only(left: 15.0),
          height: 200,
          width: 170,
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
                      child: Container(
                        height: 170,
                        width: 170,
                        child: CachedNetworkImage(
                          imageUrl: widget.products.images[0],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ).ripple(() {
                      NavigationService().navigateToScreen(ProductDetails(
                        productId: widget.products.id,
                        userId: widget.products.userId,
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
                          child: !widget.products.bookmarked
                                  .contains(currentUser!.uid)
                              ? SvgPicture.asset(ImagesAsset.bookmark)
                              : SvgPicture.asset(
                                  ImagesAsset.bookmarkActive,
                                  color: OlxColor.olxPrimary,
                                ),
                        ),
                      ),
                    ),
                    widget.isHotSales
                        ? Positioned(
                            bottom: 10,
                            left: 15,
                            child: Container(
                              height: 20,
                              width: 80,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4.0),
                                  ),
                                  color: Color(0xFFD8ECEA)),
                              child: Center(
                                child: Text(
                                  "Free Shipping",
                                  style: Config.b3(context).copyWith(
                                    fontSize: 8,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
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
                            widget.products.productName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Config.b1(context).copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        NumberFormat.simpleCurrency(
                                name: '₦ ', decimalDigits: 0)
                            .format(widget.products.price),
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
                          widget.products.description,
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
        ));
  }

  void isLikedUnlike(
    isLiked,
  ) async {
    var liked = isLiked;

    setState(() {
      isLiked = !isLiked;

      try {
        if (isLiked) {
          
        } else {}
      } catch (e) {}
    });
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
    ).ripple(() {
      NavigationService().navigateToScreen(CategoryPage(
        name: categoryModel.category,
      ));
    });
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

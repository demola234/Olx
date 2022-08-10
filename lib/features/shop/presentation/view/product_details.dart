// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/utils/custom_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart' as map;
import 'package:photo_view/photo_view.dart';

import 'package:ecommerce/core/constants/colors.dart';
import 'package:ecommerce/core/constants/image_assets.dart';
import 'package:ecommerce/core/utils/config.dart';
import 'package:ecommerce/core/utils/navigator.dart';
import 'package:ecommerce/features/authentication/data/user_model.dart';
import 'package:ecommerce/features/chat/presentation/view/message_screen.dart';
import 'package:ecommerce/features/profile/presentation/view/view_other_profiles.dart';
import 'package:ecommerce/features/shop/data/product_model.dart';

import '../../../../data/remote/chat/chat_service.dart';
import '../../../../data/remote/products/products.dart';
import '../../../../di/di.dart';
import '../../../authentication/presentation/view/setprofile/set_location.dart';
import '../../../chat/data/message_model.dart';

class ProductDetails extends StatefulWidget {
  final String productId;
  final String userId;
  const ProductDetails(
      {required this.productId, required this.userId, Key? key})
      : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Completer<GoogleMapController> _controller = Completer();
  var productService = getIt<ProductService>();
  var chatServices = getIt<ChatServices>();
  var currentUser = FirebaseAuth.instance.currentUser;
  Future<ProductModel>? productList;
  Future<UserParams>? userDetails;
  ChatModel? chatModel;
  ProductDetailsModel? productDetailsModel;

  int _index = 0;
  @override
  void initState() {
    _initProductsRetrieval();
    super.initState();
  }

  Future<void> _initProductsRetrieval() async {
    productList = productService.fetchSingleProduct(widget.productId);
    userDetails = productService.fetchSingleUser(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: CustomAppBar(
          title: "Product Details",
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          Container(
              height: 100,
              width: context.screenWidth(),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: FutureBuilder(
                  future: userDetails,
                  builder: (context, AsyncSnapshot<UserParams> snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!.uid! != currentUser!.uid
                          ? Row(
                              children: [
                                FloatingOlxButtons(
                                    color: OlxColor.olxPrimary,
                                    name: "Call",
                                    onTap: () {}),
                                FloatingOlxButtons(
                                    color: Color(0xFF82A3A1),
                                    name: "Message",
                                    onTap: () {}),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FloatingOlxButtons(
                                    color: Color(0xFF82A3A1),
                                    onTap: () {},
                                    name: "Edit Product"),
                              ],
                            );
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return Center(
                        child: ListView(
                          shrinkWrap: true,
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
                  })),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: FutureBuilder(
              future: productList,
              builder: (context, AsyncSnapshot<ProductModel> snapshot) {
                if (snapshot.hasData) {
                  productDetailsModel = ProductDetailsModel(
                      productName: snapshot.data!.productName,
                      productImage: snapshot.data!.images[0],
                      sellerId: snapshot.data!.id,
                      buyerId: currentUser!.uid,
                      price: snapshot.data!.price);
                  return Column(
                    children: [
                      const YMargin(20),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 265,
                          width: 360,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(color: const Color(0xFFF4F4F4)),
                            color: const Color(0xFFE4F2FB),
                          ),
                          child: GestureDetector(
                            onTap: () {},
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(17),
                                child: PhotoView(
                                    backgroundDecoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    initialScale: 0.3,
                                    tightMode: true,
                                    customSize: Size(360, 265),
                                    imageProvider: NetworkImage(
                                        snapshot.data!.images[_index]))),
                          ),
                        ),
                      ),
                      const YMargin(15),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 85,
                        width: context.screenWidth(),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data!.images.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _index = index;
                                });
                                if (kDebugMode) {
                                  print(_index);
                                }
                              },
                              child: ListedItem(
                                isActive: index == _index,
                                images: snapshot.data!.images[index],
                              ),
                            );
                          },
                        ),
                      ),
                      const YMargin(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: SizedBox(
                                width: 150,
                                child: Text(
                                  snapshot.data!.productName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Config.b1(context).copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              NumberFormat.simpleCurrency(
                                      name: '₦ ', decimalDigits: 0)
                                  .format(snapshot.data!.price),
                              style: Config.b1(context).copyWith(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const YMargin(12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Container(
                              height: 25,
                              width: 80,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  snapshot.data!.shippingType,
                                  style: Config.b2(context).copyWith(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ),
                            ),
                            const XMargin(10),
                            Container(
                              height: 25,
                              width: 80,
                              decoration: BoxDecoration(
                                  color: OlxColor.olxSecondary,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  snapshot.data!.category,
                                  style: Config.b2(context).copyWith(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const YMargin(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Description",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Config.b1(context).copyWith(
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            const YMargin(5.0),
                            GestureDetector(
                              onTap: () {
                                description(
                                    context, snapshot.data!.description);
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          snapshot.data!.description,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: Config.b3(context).copyWith(
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Read More",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Config.b1(context).copyWith(
                                          fontSize: 13,
                                          color: OlxColor.olxPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const YMargin(20),
                      FutureBuilder(
                          future: userDetails,
                          builder:
                              (context, AsyncSnapshot<UserParams> snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 15),
                                  height: 105,
                                  width: context.screenWidth(),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18.0),
                                    border: Border.all(
                                        color: const Color(0xFFF4F4F4)),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  snapshot.data!.profileImage!),
                                        ),
                                      ),
                                      const XMargin(10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data!.fullName!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Config.b3(context).copyWith(
                                              fontSize: 15,
                                            ),
                                          ),
                                          const YMargin(10),
                                          Row(
                                            children: [
                                              OlxSmallButton(
                                                  text: "View Profile",
                                                  onTap: () {
                                                    NavigationService()
                                                        .navigateToScreen(
                                                            ViewProfile(
                                                                uid: snapshot
                                                                    .data!
                                                                    .uid!));
                                                  },
                                                  color: OlxColor.olxPrimary,
                                                  icon: ImagesAsset.profile),
                                              XMargin(10),
                                              snapshot.data!.uid! !=
                                                      currentUser!.uid
                                                  ? OlxSmallButton(
                                                      text: "Message",
                                                      color: Color(0xFF82A3A1),
                                                      icon: ImagesAsset.chat,
                                                      onTap: () {
                                                        String roomId =
                                                            "${currentUser!.uid}.${snapshot.data!.uid!}";
                                                        chatModel = ChatModel(
                                                            uid: snapshot
                                                                .data!.uid!,
                                                            roomId: roomId,
                                                            product: [
                                                              productDetailsModel!
                                                            ],
                                                            lastMessage: null,
                                                            lastChat: Timestamp
                                                                .now());

                                                        chatServices
                                                            .createRoom(
                                                                chatModel!)
                                                            .then((value) {
                                                          NavigationService()
                                                              .navigateToScreen(
                                                                  MessageScreen(
                                                                      chatId:
                                                                          roomId));
                                                        });
                                                      },
                                                    )
                                                  : SizedBox.shrink(),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Center(
                                child: ListView(
                                  shrinkWrap: true,
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
                      const YMargin(15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Text(
                              "Product Posted At:",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Config.b1(context).copyWith(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const YMargin(10.0),
                      FutureBuilder(
                          future: userDetails,
                          builder:
                              (context, AsyncSnapshot<UserParams> snapshot) {
                            if (snapshot.hasData) {
                              if (kDebugMode) {
                                print(snapshot.data!.location!.latitude);
                              }
                              return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: GestureDetector(
                                    onTap: () => _mapLauncher(
                                        snapshot.data!.location!,
                                        snapshot.data!.fullName!),
                                    child: Container(
                                        height: 130,
                                        width: context.screenWidth(),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color(0xFF9BA7B5)
                                                  .withOpacity(0.3)),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Stack(
                                          children: [
                                            GoogleMap(
                                              myLocationButtonEnabled: false,
                                              initialCameraPosition:
                                                  CameraPosition(
                                                      zoom: 15,
                                                      target: LatLng(
                                                          snapshot
                                                              .data!
                                                              .location!
                                                              .longitude,
                                                          snapshot
                                                              .data!
                                                              .location!
                                                              .latitude)),
                                              mapType: MapType.normal,
                                              onMapCreated: (GoogleMapController
                                                  controller) {
                                                _controller
                                                    .complete(controller);
                                              },
                                            ),
                                            Center(
                                              child: SvgPicture.asset(
                                                  ImagesAsset.currentLocation,
                                                  height: 50,
                                                  width: 50),
                                            ),
                                          ],
                                        )),
                                  ));
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Center(
                                child: ListView(
                                  shrinkWrap: true,
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
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
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
        ),
      ),
    );
  }

  _mapLauncher(GeoPoint location, String shopOwner) async {
    final availableMaps = await map.MapLauncher.installedMaps;

    await availableMaps.first.showMarker(
      coords: map.Coords(location.latitude, location.latitude),
      title: shopOwner,
    );
  }

  Future<dynamic> description(BuildContext context, String desc) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SizedBox(
            height: context.screenHeight() / 1.8,
            child: Column(
              children: [
                const YMargin(10),
                Container(
                  height: 6,
                  width: context.screenWidth() / 2.5,
                  decoration: BoxDecoration(
                      color: const Color(0xFFDEDEDE),
                      borderRadius: BorderRadius.circular(23)),
                ),
                const YMargin(15),
                Text(
                  "Description",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Config.b1(context).copyWith(
                    fontSize: 20,
                  ),
                ),
                const YMargin(5),
                Expanded(
                  child: ListView(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        desc,
                        style: Config.b2(context).copyWith(
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          );
        },
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0))));
  }
}

class FloatingOlxButtons extends StatelessWidget {
  final String name;
  final void Function()? onTap;
  final Color color;
  const FloatingOlxButtons({
    Key? key,
    required this.name,
    this.onTap,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: const Color(0xFF1F2421).withOpacity(0.3)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const XMargin(5),
            ],
          ),
        ),
      ),
    );
  }
}

class OlxButtonEditProduct extends StatelessWidget {
  final String name;
  final void Function()? onTap;
  final Color color;
  const OlxButtonEditProduct({
    Key? key,
    required this.name,
    this.onTap,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        height: context.screenHeight() - 100,
        width: 150,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: const Color(0xFF1F2421).withOpacity(0.3)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const XMargin(5),
            ],
          ),
        ),
      ),
    );
  }
}

class OlxSmallButton extends StatelessWidget {
  final String icon;
  final String text;
  final Color color;
  final Function()? onTap;

  const OlxSmallButton({
    required this.text,
    required this.icon,
    required this.color,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: 49,
        // width: 85,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(8.0)),
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                height: 12,
                width: 12,
                color: Colors.white,
              ),
              const XMargin(3),
              Text(
                text,
                style: Config.b2(context).copyWith(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListedItem extends StatelessWidget {
  final bool isActive;
  final String images;

  const ListedItem({
    required this.isActive,
    required this.images,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
              width: isActive ? 1 : 0,
              color: isActive ? const Color(0xFF9BA7B5) : Colors.transparent),
          color: const Color(0xFFE4F2FB),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: CachedNetworkImage(fit: BoxFit.cover, imageUrl: images)),
      ),
    );
  }
}

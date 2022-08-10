// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:ecommerce/core/constants/colors.dart';
import 'package:ecommerce/core/utils/config.dart';
import 'package:ecommerce/core/utils/custom_buttons.dart';
import 'package:ecommerce/features/authentication/data/user_model.dart';

import '../../../../data/remote/products/products.dart';
import '../../../../di/di.dart';
import '../../../authentication/presentation/view/setprofile/set_location.dart';
import '../../../chat/data/message_model.dart';
import '../../../shop/presentation/view/product_details.dart';

class ViewProfile extends StatefulWidget {
  final String uid;
  const ViewProfile({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  Future<UserParams>? userDetails;
  // UserParams? userParams;
  var productService = getIt<ProductService>();

  @override
  void initState() {
    super.initState();
    _initProfileRetrieval();
  }

  Future<void> _initProfileRetrieval() async {
    userDetails = productService.fetchProductOwner(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: CustomAppBar(
          title: "View Profile",
        ),
      ),
      body: FutureBuilder(
          future: userDetails,
          builder: (context, AsyncSnapshot<UserParams> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  YMargin(40),
                  Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data!.profileImage!,
                          ),
                        ),
                      )),
                  YMargin(20),
                  Flexible(
                    child: FloatingOlxButtons(
                        color: OlxColor.olxPrimary, name: "Call", onTap: () {}),
                  ),
                  YMargin(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Contact Details",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Config.b3(context).copyWith(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        YMargin(20),
                        Row(
                          children: [
                            Text(
                              "Your Name:",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Config.b3(context).copyWith(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        YMargin(5),
                        Row(
                          children: [
                            Text(
                              snapshot.data!.fullName!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Config.b3(context).copyWith(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        YMargin(20),
                        Row(
                          children: [
                            Text(
                              "Your Mobile Number:",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Config.b3(context).copyWith(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        YMargin(5),
                        Row(
                          children: [
                            Text(
                              snapshot.data!.phone!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Config.b3(context).copyWith(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        YMargin(20),
                        Row(
                          children: [
                            Text(
                              "Your Email:",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Config.b3(context).copyWith(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        YMargin(5),
                        Row(
                          children: [
                            Text(
                              snapshot.data!.emailAddress!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Config.b3(context).copyWith(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        YMargin(20),
                        Row(
                          children: [
                            Text(
                              "Your Address:",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Config.b3(context).copyWith(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        YMargin(5),
                        Row(
                          children: [
                            Text(
                              snapshot.data!.address!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Config.b3(context).copyWith(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
    );
  }
}

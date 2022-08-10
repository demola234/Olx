import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/config.dart';
import '../../../../core/utils/custom_buttons.dart';
import '../../../../data/remote/products/products.dart';
import '../../../../di/di.dart';
import '../../../authentication/data/user_model.dart';
import '../../../authentication/presentation/view/setprofile/set_location.dart';
import '../../../shop/presentation/view/product_details.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<UserParams>? userDetails;
  // UserParams? userParams;
  var productService = getIt<ProductService>();
  var currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _initProfileRetrieval();
  }

  Future<void> _initProfileRetrieval() async {
    userDetails = productService.fetchProductOwner(currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: CustomAppBar(
            title: "Profile",
            back: false,
          ),
        ),
        body: Column(children: [
          FutureBuilder(
              future: userDetails,
              builder: (context, AsyncSnapshot<UserParams> snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: Column(
                      children: [
                        YMargin(20),
                        Align(
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    height: 200,
                                    width: 200,
                                    imageUrl: snapshot.data!.profileImage!)),
                          ),
                        ),
                        YMargin(20),
                        Flexible(
                          child: FloatingOlxButtons(
                              color: Color(0xFF82A3A1),
                              name: "Edit Profile",
                              onTap: () {}),
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
                    ),
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
          OlxButton(
              color: Colors.red,
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
              text: "Log Out")
        ]));
  }
}

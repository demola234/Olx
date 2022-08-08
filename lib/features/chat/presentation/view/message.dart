import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/utils/navigator.dart';
import 'package:ecommerce/core/utils/ripple.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/constants/image_assets.dart';
import '../../../../core/utils/config.dart';
import '../../../../data/remote/chat/chat_service.dart';
import '../../../../di/di.dart';
import '../../data/message_model.dart';
import 'message_screen.dart';

class Message extends StatefulWidget {
  const Message({Key? key}) : super(key: key);

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  var chatServices = getIt<ChatServices>();
  Future<List<ChatModel>>? chatList;
  List<ChatModel>? retrievedChatsList;
  var currentUser = FirebaseAuth.instance.currentUser;

  // Future<void> _initProductsRetrieval() async {
  //   chatList = chatServices.getAllessage();
  //   retrievedChatsList = await chatServices.getAllessage();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 20),
                    child: Text(
                      "Messages",
                      style: Config.b1(context).copyWith(fontSize: 20),
                    ),
                  ),
                ],
              ),
              const YMargin(20),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("chat")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return snapshot.data!.docs[index]["roomId"]
                                      .contains(currentUser!.uid)
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25.0, vertical: 15),
                                        height: 105,
                                        width: context.screenWidth(),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: Border.all(
                                              color: const Color(0xFF9BA7B5)),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 80,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                border: Border.all(
                                                    color: const Color(
                                                        0xFF9BA7B5)),
                                                color: const Color(0xFFE4F2FB),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl:
                                                        snapshot.data!
                                                                    .docs[index]
                                                                ["product"][0]
                                                            ["productImage"]),
                                              ),
                                            ),
                                            const XMargin(8.0),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot.data!.docs[index]
                                                          ["product"][0]
                                                      ["productName"],
                                                  style: Config.b1(context)
                                                      .copyWith(fontSize: 14),
                                                ),
                                                Text(
                                                  snapshot.data!.docs[index]
                                                          ["lastMessage"] ??
                                                      "",
                                                  style: Config.b3(context)
                                                      .copyWith(
                                                    fontSize: 10,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const Spacer(),
                                            Text(
                                              timeago.format(snapshot
                                                  .data!.docs[index]["lastChat"]
                                                  .toDate()),
                                              style:
                                                  Config.b3(context).copyWith(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ).ripple(
                                        () {
                                          if (kDebugMode) {
                                            print("1");
                                          }
                                          NavigationService()
                                              .navigateToScreen(MessageScreen(
                                            chatId: snapshot.data!.docs[index]
                                                ["roomId"],
                                          ));
                                        },
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    )
                                  : SizedBox();
                            });
                      } else if (snapshot.connectionState ==
                              ConnectionState.done &&
                          retrievedChatsList!.isEmpty) {
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

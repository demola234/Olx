import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/constants/colors.dart';
import 'package:ecommerce/core/utils/config.dart';
import 'package:ecommerce/features/chat/data/chat_model.dart';
import 'package:ecommerce/features/chat/data/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/remote/chat/chat_service.dart';
import '../../../../di/di.dart';
import '../../../authentication/presentation/view/setprofile/set_location.dart';

class MessageScreen extends StatefulWidget {
  final String chatId;
  const MessageScreen({required this.chatId, Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  String? text;
  TextEditingController? _textEditingController;
  Future<ChatModel>? chatList;

  MessageModel? messageDetails;
  var chatServices = getIt<ChatServices>();
  var currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    setState(() {
      _textEditingController = TextEditingController();
    });
    _initProductsRetrieval();
    super.initState();
  }

  Future<void> _initProductsRetrieval() async {
    chatList = chatServices.fetchChatProducts(widget.chatId);
  }

  _saveMessage() async {
    if (_textEditingController!.text.isEmpty) return;
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _textEditingController!.clear();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: CustomAppBar(
            title: "Message Seller",
          ),
        ),
        body: Column(children: [
          const YMargin(10),
          FutureBuilder(
              future: chatList,
              builder: (context, AsyncSnapshot<ChatModel> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 60,
                    width: context.screenWidth(),
                    decoration: const BoxDecoration(
                        border: Border(
                      bottom: BorderSide(width: 0.59, color: Color(0xFF9AACC1)),
                    )),
                    child: Row(
                      children: [
                        Container(
                          height: 45,
                          width: 45,
                          
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF9AACC1)),
                            borderRadius: BorderRadius.circular(10.0),
                            color: const Color(0xFFE4F2FB),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl:
                                    snapshot.data!.product[0].productImage),
                          ),
                        ),
                        const XMargin(10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data!.product[0].productName,
                              style: Config.b3(context).copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              NumberFormat.simpleCurrency(
                                      name: '₦ ', decimalDigits: 0)
                                  .format(snapshot.data!.product[0].price),
                              style: Config.b3(context).copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
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
              }),
          Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: chatServices.getMessages(widget.chatId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          reverse: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: snapshot.data!.docs[index]
                                            ["sentBy"] ==
                                        currentUser!.uid
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      crossAxisAlignment: snapshot.data!
                                                  .docs[index]["sentBy"] ==
                                              currentUser!.uid
                                          ? CrossAxisAlignment.start
                                          : CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              snapshot.data!.docs[index]
                                                          ["sentBy"] ==
                                                      currentUser!.uid
                                                  ? "Customer"
                                                  : "You",
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: OlxColor.olxPrimary),
                                            ),
                                            const XMargin(10),
                                            Text(
                                                timeago.format(snapshot
                                                    .data!.docs[index]["time"]
                                                    .toDate()),
                                                style: Config.b3(context)
                                                    .copyWith(fontSize: 9.0)),
                                          ],
                                        ),
                                        const YMargin(5),
                                        Container(
                                          width: context.screenWidth() / 3,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10.0,
                                            horizontal: 20,
                                          ),
                                          decoration: BoxDecoration(
                                            color: snapshot.data!.docs[index]
                                                        ["sentBy"] ==
                                                    currentUser!.uid
                                                ? const Color(0xFFEFF5FB)
                                                : const Color(0xFFFFFCF2),
                                            borderRadius:
                                                BorderRadius.circular(9.0),
                                          ),
                                          child: SelectableText(
                                            snapshot.data!.docs[index]
                                                ["message"],
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w300,
                                              color: snapshot.data!.docs[index]
                                                          ["sentBy"] ==
                                                      currentUser!.uid
                                                  ? Colors.black
                                                  : OlxColor.olxPrimary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    } else if (snapshot.connectionState ==
                            ConnectionState.done &&
                        snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: ListView(
                          children: const <Widget>[
                            Align(
                                alignment: AlignmentDirectional.center,
                                child: Text('Location not found')),
                          ],
                        ),
                      );
                    } else {
                      return const Center(child: Text("Loading Location"));
                    }
                  })),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16.0,
            ),
            margin: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textInputAction: TextInputAction.send,
                    controller: _textEditingController,
                    style: GoogleFonts.montserrat(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: OlxColor.olxPrimary),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                      hintText: "Type a message",
                      hintStyle: GoogleFonts.montserrat(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF999393),
                      ),
                      suffixIcon: Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.tag_faces_outlined),
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          borderSide: const BorderSide(
                            width: 0.5,
                            color: Color(0xFFDADADA),
                          )),
                    ),
                    onEditingComplete: _saveMessage,
                  ),
                ),
                const XMargin(5.0),
                Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: OlxColor.olxPrimary,
                  ),
                  child: IconButton(
                    onPressed: () {
                      messageDetails = MessageModel(
                        message: _textEditingController!.text,
                        sentBy: currentUser!.uid,
                        time: Timestamp.now(),
                      );
                      _textEditingController!.clear();
                      chatServices.createChat(widget.chatId, messageDetails!);
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          )
        ]));
  }
}

class Message {
  final int user;
  final String desc;

  Message(this.user, this.desc);
}

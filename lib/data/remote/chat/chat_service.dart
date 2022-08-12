import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/features/chat/data/chat_model.dart';
import 'package:ecommerce/features/chat/data/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

abstract class ChatServices {
  Future createRoom(ChatModel chat);
  Future createChat(String chatId, MessageModel messageModel);
  getMessages(String chatId);
  Future<ChatModel> fetchChatProducts(String chatId);
  Future<List<ChatModel>> getAllMessage();
}

class ChatServicesImpl implements ChatServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future createRoom(ChatModel chatModel) async {
    final chat = _db.collection("chat").doc(chatModel.roomId);
    await chat.set(chatModel.toMap());
  }

  @override
  Future createChat(String chatId, MessageModel messageModel) async {
    final chat = _db.collection("chat").doc(chatId);
    chat.update({
      "lastMessage": messageModel.message,
      "lastChat": messageModel.time,
    });
    final createChat =
        _db.collection("chat").doc(chatId).collection("messages");
    return createChat.add(messageModel.toMap());
  }

  @override
  getMessages(String chatId) {
    Stream<QuerySnapshot<Map<String, dynamic>>> getChat = _db
        .collection("chat")
        .doc(chatId)
        .collection("messages")
        .orderBy("time", descending: true)
        .snapshots();
    return getChat;
  }

  @override
  Future<ChatModel> fetchChatProducts(String chatId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("chat").doc(chatId).get();
    if (kDebugMode) {
      print(snapshot.data());
    }
    return ChatModel.fromMap(snapshot);
  }

  @override
  Future<List<ChatModel>> getAllMessage() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("chat").get();
    if (kDebugMode) {
      print(snapshot);
    }
    return snapshot.docs
        .map((docSnapshot) => ChatModel.fromMap(docSnapshot))
        .toList();
  }
}

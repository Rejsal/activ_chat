import 'package:activ_chat/models/chat_model.dart';
import 'package:activ_chat/models/group_model.dart';
import 'package:activ_chat/utils/firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ChatProvider with ChangeNotifier {
  final FirestoreHelper _chatHelper = FirestoreHelper('chats');

  List<ChatModel> _chats = [];
  bool _loading = false;

  List<ChatModel> get chats => _chats;
  bool get loading => _loading;

  //get stream of chats
  getChats(GroupModel group) {
    _chatHelper
        .getGroupStreamDataCollection(group.id ?? "")
        .listen(_chatStreamListener);
  }

  //listening stream
  _chatStreamListener(QuerySnapshot snapshot) async {
    _chats = snapshot.docs
        .map((doc) => ChatModel.fromFirestore(doc, doc.id))
        .toList();
    notifyListeners();
  }

  // create new chat
  Future<bool> createChat(ChatModel data) async {
    _loading = true;
    try {
      await _chatHelper.addDocument(data.toJson());
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _loading = false;
      notifyListeners();
      return false;
    }
  }
}

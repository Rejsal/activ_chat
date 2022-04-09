import 'package:activ_chat/models/group_model.dart';
import 'package:activ_chat/utils/firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class GroupProvider with ChangeNotifier {
  final FirestoreHelper _groupHelper = FirestoreHelper('groups');

  List<GroupModel> _groups = [];
  List<GroupModel> _tempGroups = [];
  bool _loading = false;
  bool _listLoading = false;
  String _searchValue = "";

  List<GroupModel> get groups => _groups;
  bool get loading => _loading;
  bool get listLoading => _listLoading;

  //get stream of groups
  getGroups(String userId) {
    _groupHelper.getStreamDataCollection().listen((data) {
      _groupStreamListener(data, userId);
    });
  }

  //listening stream
  _groupStreamListener(QuerySnapshot snapshot, String userId) async {
    _tempGroups = snapshot.docs
        .map((doc) => GroupModel.fromFirestore(doc, doc.id))
        .toList();
    _groups = _tempGroups
        .where((element) =>
            element.name!.toLowerCase().contains(_searchValue) &&
            element.users != null &&
            element.users!.contains(userId))
        .toList();
    notifyListeners();
  }

  //fetch full groups
  fetchFullGroups() async {
    _listLoading = true;
    var result = await _groupHelper.getDataCollection();
    _groups = result.docs
        .map((doc) => GroupModel.fromFirestore(doc, doc.id))
        .toList();
    _tempGroups = _groups;
    _listLoading = false;
    notifyListeners();
  }

  //searching groups
  onSearchedGroup(String value) {
    _searchValue = value;
    _groups = _tempGroups
        .where((element) =>
            element.name!.toLowerCase().contains(_searchValue.toLowerCase()))
        .toList();
    notifyListeners();
  }

  //add new group
  Future<bool> createGroup(GroupModel data) async {
    _loading = true;
    try {
      await _groupHelper.addDocument(data.toJson());
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<GroupModel> getGroupById(String id) async {
    var data = await _groupHelper.getDocumentById(id);
    return GroupModel.fromFirestore(data, data.id);
  }

  //update group
  Future<bool> updateGroup(GroupModel data, String id) async {
    _loading = true;
    try {
      await _groupHelper.updateDocument(data.toJson(), id);
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  //delete group
  Future<bool> deleteGroup(String id) async {
    _loading = true;
    try {
      await _groupHelper.removeDocument(id);
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

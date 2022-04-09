import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  final _db = FirebaseFirestore.instance;
  final String path;
  CollectionReference? ref;

  FirestoreHelper(this.path) {
    ref = _db.collection(path);
  }

  //get full document data
  Future<QuerySnapshot> getDataCollection() async {
    try {
      return await ref!.get();
    } catch (e) {
      throw Exception(e);
    }
  }

  //get full document data as stream
  Stream<QuerySnapshot> getStreamDataCollection() {
    return ref!.snapshots();
  }

  //get full document data as stream
  Stream<QuerySnapshot> getNotificationStreamDataCollection(String toId) {
    return ref!
        .where('to', isEqualTo: toId)
        .where("status", isEqualTo: "pending")
        .snapshots();
  }

  //get document data by type as stream
  Stream<QuerySnapshot> getGroupStreamDataCollection(String group) {
    return ref!
        .orderBy('date', descending: true)
        .where('group', isEqualTo: group)
        .snapshots();
  }

  //get document data by document id
  Future<DocumentSnapshot> getDocumentById(String id) async {
    try {
      return await ref!.doc(id).get();
    } catch (e) {
      throw Exception(e);
    }
  }

  //search user document by email
  Future<QuerySnapshot> getUserDocumentByEmail(String email) async {
    try {
      return await ref!.where('email', isEqualTo: email).get();
    } catch (e) {
      throw Exception(e);
    }
  }

  //remove document by document id
  Future<void> removeDocument(String id) async {
    try {
      return await ref!.doc(id).delete();
    } catch (e) {
      throw Exception(e);
    }
  }

  //add new document data
  Future<DocumentReference> addDocument(Map data) async {
    try {
      return await ref!.add(data);
    } catch (e) {
      throw Exception(e);
    }
  }

  //add new document data
  Future<void> addDocumentById(Map data, String id) async {
    try {
      await ref!.doc(id).set(data);
    } catch (e) {
      throw Exception(e);
    }
  }

  //update existing document data
  Future<void> updateDocument(dynamic data, String id) async {
    try {
      return await ref!.doc(id).update(data);
    } catch (e) {
      throw Exception(e);
    }
  }
}

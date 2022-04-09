import 'package:activ_chat/models/notification_model.dart';
import 'package:activ_chat/utils/firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class NotificationProvider with ChangeNotifier {
  final FirestoreHelper _notificationHelper = FirestoreHelper('notification');

  List<NotificationModel> _notifications = [];
  bool _loading = false;

  List<NotificationModel> get notifications => _notifications;
  bool get loading => _loading;

  //get stream of notifications
  getNotifications(String toId) {
    _notificationHelper
        .getNotificationStreamDataCollection(toId)
        .listen(_notificationStreamListener);
  }

  //listening stream
  _notificationStreamListener(QuerySnapshot snapshot) async {
    _notifications = snapshot.docs
        .map((doc) => NotificationModel.fromFirestore(doc, doc.id))
        .toList();
    notifyListeners();
  }

  // create new notification
  Future<bool> createNotification(NotificationModel data) async {
    _loading = true;
    try {
      await _notificationHelper.addDocument(data.toJson());
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  //update notification
  Future<bool> updateNotification(NotificationModel data, String id) async {
    _loading = true;
    try {
      await _notificationHelper.updateDocument(data.toJson(), id);
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

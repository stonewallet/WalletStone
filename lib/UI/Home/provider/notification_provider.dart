import 'package:flutter/material.dart';
import 'package:walletstone/API/GetNotification/get_notification.dart';
import 'package:walletstone/UI/Model/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  Set<int> expandedIndices = {};
  List<NotificationModel> notifications = [];
  final noti = ApiServiceForNotification();

  void setNotifications(List<NotificationModel> newList) {
    notifications = newList;
    notifyListeners();
  }

  void removeNotification(int index) {
    notifications.removeAt(index);
    notifyListeners();
  }

  getNotification() async {
    notifications = await noti.getDataForNotification();
    notifyListeners();
  }

  void toggleExpansion(int index) {
    if (expandedIndices.contains(index)) {
      expandedIndices.remove(index); 
    } else {
      expandedIndices.clear();
      expandedIndices.add(index); 
    }
    notifyListeners();
  }
}

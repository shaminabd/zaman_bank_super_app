import 'package:flutter/material.dart';

class ChatNotificationProvider extends ChangeNotifier {
  bool _hasUnreadMessages = false;

  bool get hasUnreadMessages => _hasUnreadMessages;

  void setUnreadMessages(bool hasUnread) {
    _hasUnreadMessages = hasUnread;
    notifyListeners();
  }

  void markAsRead() {
    _hasUnreadMessages = false;
    notifyListeners();
  }
}

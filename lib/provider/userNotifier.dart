import 'package:flutter/cupertino.dart';

class UserNotifier with ChangeNotifier {
  String _userName = "";
  String get userName => _userName;

  setUserName(String newName) {
    _userName = newName;
    notifyListeners();
  }
}

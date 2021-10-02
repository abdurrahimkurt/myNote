import 'package:flutter/material.dart';
import 'package:mynote/utils/color.dart';

class RenkNotifier with ChangeNotifier {
  Color _bottomColor1 = Colors.black54;
  Color _bottomColor2 = Colors.black54;
  Color _bottomColor3 = Colors.black54;
  Color _bottomColor4 = Colors.black54;
  bool _isOpen = false;

  Color get bottomColor1 => _bottomColor1;
  Color get bottomColor2 => _bottomColor2;
  Color get bottomColor3 => _bottomColor3;
  Color get bottomColor4 => _bottomColor4;
  bool get isOpen => _isOpen;

  setisOpen() {
    (_isOpen) ? _isOpen = false : _isOpen = true;
    notifyListeners();
    //print(_isOpen);
  }

  setColor(int button) {
    if (button == 1) {
      _bottomColor1 = ikincilRenk;
    } else {
      _bottomColor1 = Colors.black54;
    }
    if (button == 2) {
      _bottomColor2 = ikincilRenk;
    } else {
      _bottomColor2 = Colors.black54;
    }
    if (button == 3) {
      _bottomColor3 = ikincilRenk;
    } else {
      _bottomColor3 = Colors.black54;
    }
    if (button == 4) {
      _bottomColor4 = ikincilRenk;
    } else {
      _bottomColor4 = Colors.black54;
    }
    notifyListeners();
  }
}

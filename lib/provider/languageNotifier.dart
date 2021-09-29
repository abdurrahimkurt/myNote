import 'package:flutter/material.dart';
import 'package:mynote/helpers/sharedPref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageNotifier with ChangeNotifier {
  String _lowID = "tr";
  Locale _setLanguage = BaseSharedPrefHelper.instance
              .getStringValue("deviceLang") ==
          "tr"
      ? Locale("tr", "TR")
      : BaseSharedPrefHelper.instance.getStringValue("deviceLang") == "tr"
          ? Locale("en", "US")
          : BaseSharedPrefHelper.instance.getStringValue("deviceLang") == "de"
              ? Locale("de", "DE")
              : BaseSharedPrefHelper.instance.getStringValue("deviceLang") ==
                      "ru"
                  ? Locale("ru", "RU")
                  : Locale("ar", "SA");
  // TODO::ŞİMDİLİK DEFAULT DİL TR YOLLANIYOR EN SON TELEFONUN DİLİ ALINACAK
  Locale get getLanguage => _setLanguage;
  String get lowID => _lowID;
  setAllLanguage(Locale data, String low) {
    _setLanguage = data;
    _lowID = low;
    notifyListeners();
  }

  int _langStatus = 0;
  int get langStatus => _langStatus;
  setLanguageStatus(int value) {
    _langStatus = value;
    notifyListeners();
  }
}

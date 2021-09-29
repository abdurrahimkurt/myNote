import 'dart:convert';

import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class BaseSharedPrefHelper {
  static final BaseSharedPrefHelper _instance = BaseSharedPrefHelper._init();
  SharedPreferences? _preferences;

  static BaseSharedPrefHelper get instance => _instance;

  BaseSharedPrefHelper._init() {
    SharedPreferences.getInstance().then((value) {
      _preferences = value;
    });
  }

  static Future preferencesInit() async =>
      instance._preferences ??= await SharedPreferences.getInstance();

  Future<void> clearAll() async => await _preferences!.clear();

  Future<void> setStringValue(String key, String value) async =>
      await _preferences!.setString(key.toString(), value);

  Future<void> setBoolValue(String key, bool value) async =>
      await _preferences!.setBool(key.toString(), value);

  String getStringValue(String key) =>
      _preferences!.getString(key.toString()) ?? '';

  bool getBoolValue(String key) =>
      _preferences!.getBool(key.toString()) ?? false;
}

String base64Enc(var imagefile) {
  final bytes = imagefile.readAsBytesSync();
  String _img64 = base64Encode(bytes);
  return _img64;
}

base64Dec(String img64) {
  Uint8List _bytes = base64.decode(img64);

  return _bytes;
}

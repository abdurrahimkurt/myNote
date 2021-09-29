import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

class LanguageManager {
  static LanguageManager? _instance;
  static String lang = Platform.localeName;
  static Locale? enLocale;

  static LanguageManager get instance {
    if (_instance == null) _instance = LanguageManager._init();

    if (lang == "tr_TR" || lang == "en_US") {
      enLocale = Locale(lang.split("_")[0], lang.split("_")[1]);
    } else {
      enLocale = Locale("en", "US");
    }

    initializeDateFormatting(lang.split("_")[0]); //bu satırı ekliyoruz

    return _instance!;
  }

  LanguageManager._init();

  Locale get supportedLocales => enLocale!;
}

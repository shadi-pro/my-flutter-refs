import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  static Map<String, Map<String, String>> translations = {};

  static Future<void> init() async {
    final en = await rootBundle.loadString('assets/lang/en.json');
    final ar = await rootBundle.loadString('assets/lang/ar.json');

    translations['en'] = Map<String, String>.from(json.decode(en));
    translations['ar'] = Map<String, String>.from(json.decode(ar));
  }

  @override
  Map<String, Map<String, String>> get keys => translations;
}

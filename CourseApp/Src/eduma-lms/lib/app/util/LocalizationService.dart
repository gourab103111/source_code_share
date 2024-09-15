import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';

class LocalizationService extends Translations {
  static final locale = _getLocaleFromLanguage('en');
  static final fallbackLocale = Locale('en', 'US');

  var data = {};
  static final langCodes = [
    'en',
    'es',
    'ko',
    'pt',
  ];

  static final locales = [
    Locale('en', 'US'),
    Locale('es', 'ES'),
    Locale('ko', 'KR'),
    Locale('pt', 'PT'),
  ];

  static void changeLocale(String langCode) {
    final locale = _getLocaleFromLanguage(langCode);
    Get.updateLocale(locale!);
  }

  handleGetAllFile() async {
    final directoryPath =
        '/assets/flutter_i18n';

    try {
      final directory = Directory(directoryPath);

      if (directory.existsSync()) {
        List<FileSystemEntity> files = directory.listSync();
        Map<String, dynamic> dynamicObject = {};
        for (var file in files) {
          if (file is File) {
            final fileContent = await file.readAsString();
            dynamicObject[file.uri.pathSegments.last.replaceAll(".json", "")] = json.decode(fileContent);
          }
        }
        data = dynamicObject;
        return dynamicObject;
      } else {

      }
    } catch (e) {

    }
  }

  @override
  Map<String, Map<String, String>> get keys => {};

  static Locale? _getLocaleFromLanguage(String? langCode) {
    var lang = langCode ?? Get.deviceLocale?.languageCode;
    for (int i = 0; i < langCodes.length; i++) {
      if (lang == langCodes[i]) return locales[i];
    }
    return Get.locale;
  }
}

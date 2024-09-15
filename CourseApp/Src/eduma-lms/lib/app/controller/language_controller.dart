import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/controller/courses_controller.dart';
import 'package:flutter_app/app/controller/my_courses_controller.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../helper/shared_pref.dart';

class LanguageController extends GetxController implements GetxService {
  final SharedPreferencesManager sharedPreferencesManager;
  String currentKeyLanguage = '';
  LanguageController({required this.sharedPreferencesManager});

  var _listLanguage = [
    {"key": "en", "countryCode": "US", "value": "English", "isActive": true},
    {"key": "ko", "countryCode": "KR", "value": "한국인", "isActive": false},
    {"key": "pt", "countryCode": "PT", "value": "Português", "isActive": false},
    {"key": "es", "countryCode": "ES", "value": "Español", "isActive": false},
    {"key": "fa", "countryCode": "IR", "value": "Iran", "isActive": false},
    {"key": "bn", "countryCode": "BN", "value": "Bengali", "isActive": false},
  ];

  List<dynamic> get listLanguage => _listLanguage;

  handleChoiceLanguage(key) {
    if(key == ''){
      key = 'en';
    }
    currentKeyLanguage = key;
    var dataRaw = _listLanguage.map((e) {
      e['isActive'] = false;
      return e;
    }).toList();
    var data = dataRaw.map((element) {
      if (element['key'] == key) {
        element['isActive'] = true;
        return element;
      }
      return element;
    }).toList();
    _listLanguage = data;

    Map currentLanguage = _listLanguage.firstWhere((element) => element['key'] == key);
    update();
    refresh();
    return currentLanguage;
  }

  handleUpdate(currentLanguage) async {
    var context = Get.context as BuildContext;
    var newLocale =
        Locale(currentLanguage['key'], currentLanguage['countryCode']);

    await context.setLocale(newLocale);
    EasyLocalization.of(context)?.setLocale(newLocale);
    sharedPreferencesManager.putString('language', currentLanguage['key']);
    Get.updateLocale(newLocale);
    await context.deleteSaveLocale();
    CoursesController controller = Get.find();
    MyCoursesController myCoursesController = Get.find();
    myCoursesController.onInit();
    controller.handleGetOption();
    Alert(
      context: context,
      desc: tr(LocaleKeys.changeLanguageSuccess),
      buttons: [
        DialogButton(
          child: Text(
            tr(LocaleKeys.alert_ok),
            style: TextStyle(color: Colors.white, fontFamily: 'medium'),
          ),
          onPressed: () => {Navigator.pop(context)},
        ),
      ],
    ).show();
    update();
    refresh();
  }
}

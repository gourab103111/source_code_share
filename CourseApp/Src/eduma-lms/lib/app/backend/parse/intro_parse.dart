import 'package:flutter_app/app/backend/api/api.dart';
import 'package:flutter_app/app/helper/shared_pref.dart';

class IntroParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  IntroParser(
      {required this.apiService, required this.sharedPreferencesManager});

  // void saveLanguage(String code) {
  //   sharedPreferencesManager.putString('language', code);
  // }
}

import 'dart:convert';

import 'package:flutter_app/app/backend/api/api.dart';
import 'package:flutter_app/app/helper/shared_pref.dart';

class SearchCourseParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  SearchCourseParser(
      {required this.apiService, required this.sharedPreferencesManager});

  void saveRecentSearch(String value) async {
    List<String> data = getRecentSearch();
    data.add(value);
    String json = jsonEncode(data);
    sharedPreferencesManager.putString('recent_search', json);
  }

  List<String> getRecentSearch() {
    var lst = sharedPreferencesManager.getString('recent_search');
    if (lst != null) {
      List<String> temp = (jsonDecode(lst) as List<dynamic>).cast<String>();
      return temp;
    }
    return [];
  }

  String getToken() {
    return sharedPreferencesManager.getString('token') ?? "";
  }
}

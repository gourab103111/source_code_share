import 'dart:convert';

import 'package:flutter_app/app/backend/api/api.dart';
import 'package:flutter_app/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:flutter_app/app/util/constant.dart';

class MyCoursesParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  MyCoursesParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getMyCourse(var body) async {
    String token = getToken();

    var response =
        await apiService.getPrivateV2(AppConstants.getCourses, token, body);
    return response;
  }

  String getToken() {
    return sharedPreferencesManager.getString('token') ?? "";
  }
}

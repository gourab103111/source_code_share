import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/api/api.dart';
import 'package:flutter_app/app/backend/models/user_info_model.dart';
import 'package:flutter_app/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:flutter_app/app/util/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../env.dart';

class ProfileParser {
  late ApiService apiService = ApiService(appBaseUrl: Environments.apiBaseURL);

  ProfileParser();

  Future<Response> getHomeData(var body) async {
    var response =
        await apiService.postPublic(AppConstants.getTopCourses, body);
    return response;
  }

  Future<Response> getUser(String id) async {
    final sharedPref = await SharedPreferences.getInstance();
    final parser = SharedPreferencesManager(sharedPreferences: sharedPref);
    String token = parser.getString('token') ?? "";

    var response = await apiService.getPrivate(
        AppConstants.getUser + "/" + id, token, null);
    return response;
  }

  Future<void> saveUserInfo(UserInfoModel user) async {
    final sharedPref = await SharedPreferences.getInstance();
    final parser = SharedPreferencesManager(sharedPreferences: sharedPref);

    parser.putString('user_info', jsonEncode(user.toJson()));
  }

  Future<void> clearAccount() async {
    final sharedPref = await SharedPreferences.getInstance();
    final parser = SharedPreferencesManager(sharedPreferences: sharedPref);
    parser.clearAll();
  }

  getToken() async {
    final sharedPref = await SharedPreferences.getInstance();
    final parser = SharedPreferencesManager(sharedPreferences: sharedPref);
    String token = parser.getString('token') ?? "";
    return token;
  }
}

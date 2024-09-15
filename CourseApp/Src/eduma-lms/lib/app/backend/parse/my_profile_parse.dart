import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/api/api.dart';
import 'package:flutter_app/app/backend/models/user_info_model.dart';
import 'package:flutter_app/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:flutter_app/app/util/constant.dart';

class MyProfileParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  MyProfileParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getHomeData(var body) async {
    var response =
        await apiService.postPublic(AppConstants.getTopCourses, body);
    return response;
  }

  Future<Response> getUser(String id) async {
    var response = await apiService.getPrivate(
        AppConstants.getUser + "/" + id, getToken(), null);
    return response;
  }

  String getAddressName() {
    return sharedPreferencesManager.getString('address') ?? 'Home';
  }

  double getLat() {
    return sharedPreferencesManager.getDouble('lat') ?? 0.0;
  }

  double getLng() {
    return sharedPreferencesManager.getDouble('lng') ?? 0.0;
  }

  String getCurrencyCode() {
    return sharedPreferencesManager.getString('currencyCode') ??
        AppConstants.defaultCurrencyCode;
  }

  String getToken() {
    return sharedPreferencesManager.getString('token') ?? "";
  }
  String getFCMToken() {
    return sharedPreferencesManager.getString(SharedPreferencesManager.keyFcmToken) ?? "";
  }
  void setFCMToken(fcmToken) {
    sharedPreferencesManager.putString(SharedPreferencesManager.keyFcmToken,fcmToken);
  }

  String getUserId() {
    return sharedPreferencesManager.getString('user_id') ?? "";
  }

  String getUserNameLogin() {
    return sharedPreferencesManager.getString('user_login') ?? "";
  }

  String getEmailLogin() {
    return sharedPreferencesManager.getString('user_email') ?? "";
  }

  void saveUserInfo(UserInfoModel user) {
    sharedPreferencesManager.putString('user_info', jsonEncode(user.toJson()));
  }

  String? getUserInfo(){
    return sharedPreferencesManager.getString('user_info');
  }

  void clearAccount() {
    sharedPreferencesManager.clearAll();
  }
}

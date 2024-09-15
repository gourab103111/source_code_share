import 'dart:convert';

import 'package:flutter_app/app/backend/api/api.dart';
import 'package:flutter_app/app/backend/models/user_info_model.dart';
import 'package:flutter_app/app/helper/shared_pref.dart';
import 'package:flutter_app/app/util/constant.dart';
import 'package:get/get_connect.dart';

class LoginParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  LoginParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> login(var body) async {
    var response = await apiService.postPublic(AppConstants.onlogin, body);
    return response;
  }

  Future<Response> getUser(String id) async {
    String token = getToken();
    var response =
        await apiService.getPrivate("${AppConstants.getUser}/$id", token, null);
    return response;
  }

  void saveToken(String token) {
    sharedPreferencesManager.putString('token', token);
  }

  String getToken() {
    return sharedPreferencesManager.getString('token') ?? "";
  }
  String getFcmToken() {
    return sharedPreferencesManager.getString(SharedPreferencesManager.keyFcmToken) ?? "";
  }
  String getUserId() {
    return sharedPreferencesManager.getString('user_id') ?? "";
  }

  void saveUserInfo(UserInfoModel user) {
    sharedPreferencesManager.putString('user_info', jsonEncode(user.toJson()));
  }

  void saveUser(String userId, String userLogin, String userEmail,
      String userDisplayName) {
    sharedPreferencesManager.putString('user_id', userId);
    sharedPreferencesManager.putString('user_login', userLogin);
    sharedPreferencesManager.putString('user_email', userEmail);
    sharedPreferencesManager.putString('user_display_name', userDisplayName);
  }
}

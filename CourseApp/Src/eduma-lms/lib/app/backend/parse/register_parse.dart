import 'dart:convert';

import 'package:flutter_app/app/backend/api/api.dart';
import 'package:flutter_app/app/backend/models/user_info_model.dart';
import 'package:flutter_app/app/helper/shared_pref.dart';
import 'package:flutter_app/app/util/constant.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:jwt_decode/jwt_decode.dart';

class RegisterParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  RegisterParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> register(var body) async {
    var response = await apiService.postPublic(AppConstants.register, body);
    return response;
  }

  Future<void> getUser() async {
    String token = getToken();

    Map<String, dynamic> payload = Jwt.parseJwt(token);
    String userId = payload["data"]["user"]["id"];
    Response response = await apiService.getPrivate(
        AppConstants.getUser + "/" + userId, token, null);
    if (response.statusCode == 200) {
      UserInfoModel user = UserInfoModel.fromJson(response.body);
      saveUserInfo(user);
    }
  }

  String getToken() {
    return sharedPreferencesManager.getString('token') ?? "";
  }

  void saveToken(String token) {
    sharedPreferencesManager.putString('token', token);
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

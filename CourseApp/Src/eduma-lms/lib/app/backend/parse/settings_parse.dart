import 'package:flutter_app/app/backend/models/user_info_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app/app/backend/api/api.dart';
import 'package:flutter_app/app/helper/shared_pref.dart';
import 'package:flutter_app/app/util/constant.dart';
import 'package:get/get.dart';

import '../mobx-store/session_store.dart';
import 'login_parse.dart';

class SettingsParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;
  final SessionStore sessionStore;

  SettingsParser({required this.apiService, required this.sharedPreferencesManager, required this.sessionStore});

  Future<Response> changePassword(var body) async {
    var response = await apiService.postPrivate(
        AppConstants.changePassword, body, getToken());
    return response;
  }

  Future<Response> deleteAccount(var body) async {
    var response = await apiService.postPrivate(
        AppConstants.deletePassword, body, getToken());
    return response;
  }

  Future<Response> submitGeneral(var body) async {
    UserInfoModel user = getUserInfo();
    var response = await apiService.postPrivateMultipart(
        AppConstants.updateUser + user.id.toString(), body, getToken());
    return response;
  }

  String getToken() {
    return sharedPreferencesManager.getString('token') ?? "";
  }

  UserInfoModel getUserInfo() {
    String temp = sharedPreferencesManager.getString('user_info') ?? "";
    UserInfoModel json = UserInfoModel();
    if (temp != "") {
      json = UserInfoModel.fromJson(jsonDecode(temp) as Map<String, dynamic>);
    }
    return json;
  }
  updateUserDataSharedPreferencesManager() async {

    String? token = sharedPreferencesManager.getString('token');
    String? userId = sharedPreferencesManager.getString('user_id');
    Response response = await apiService.getPrivate(
        AppConstants.getUser + "/" + userId!, token!, null);
    if (response.statusCode == 200) {
      UserInfoModel user = UserInfoModel.fromJson(response.body);
      sharedPreferencesManager.putString('user_info', jsonEncode(user.toJson()));
      sessionStore.setUserInfo(user);
    }

  }
}

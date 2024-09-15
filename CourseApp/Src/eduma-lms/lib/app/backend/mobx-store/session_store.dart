import 'dart:convert';

import 'package:flutter_app/app/backend/api/api.dart';
import 'package:flutter_app/app/backend/models/user_info_model.dart';
import 'package:flutter_app/app/helper/shared_pref.dart';
import 'package:flutter_app/app/util/constant.dart';
import 'package:get/get.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:mobx/mobx.dart';

import '../../env.dart';

part 'session_store.g.dart';

class SessionStore = _SessionStore with _$SessionStore;

abstract class _SessionStore with Store {
  SharedPreferencesManager? sharedPreferencesManager;
  ApiService? apiService;

  @observable
  String token = "";
  @observable
  UserInfoModel? userInfo;

  void initStore(sharedPref, apiServiceTemp) {
    sharedPreferencesManager = sharedPref;
    apiService = apiServiceTemp;
    getUser();
  }

  @action
  void setToken(value) {
    token = value;
  }

  @action
  void setUserInfo(value) {
    userInfo = value;
  }

  Future<void> getUser() async {
    final apiService = ApiService(appBaseUrl: Environments.apiBaseURL);
    String tokenTemp = getToken();
    setToken(tokenTemp);
    if (token == "") return;
    Map<String, dynamic> payload = Jwt.parseJwt(token);
    String userId = payload["data"]["user"]["id"];
    Response response = await apiService.getPrivate(
        AppConstants.getUser + "/" + userId, token, null);
    if (response.statusCode == 200) {
      UserInfoModel user = UserInfoModel.fromJson(response.body);
      saveUserInfo(user);
      setUserInfo(user);
    }
  }

  void saveUserInfo(UserInfoModel user) {
    sharedPreferencesManager!.putString('user_info', jsonEncode(user.toJson()));
  }

  String getToken() {
    return sharedPreferencesManager!.getString('token') ?? "";
  }
  String getCurrentCoursesId(){
    return sharedPreferencesManager!.getString('overview') ?? "";
  }
  String getFcmToken(){
    return sharedPreferencesManager!.getString('fcm_token') ?? "";
  }
}

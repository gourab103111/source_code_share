import 'package:flutter_app/app/backend/api/api.dart';
import 'package:flutter_app/app/helper/shared_pref.dart';
import 'package:flutter_app/app/util/constant.dart';
import 'package:get/get.dart';

class NotificationParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  NotificationParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getNotification() async {
    String token = getToken();
    var response =
        await apiService.getPrivate(AppConstants.getNotification, token, null);
    return response;
  }

  Future<Response> registerFCMToken(
      String deviceToken, String deviceType) async {
    String token = getToken();
    Map<String, String> body = {
      'device_token': deviceToken,
      'device_type': deviceType
    };
    var response = await apiService.postPrivate(
        AppConstants.registerFCMToken, body, token);
    return response;
  }

  Future<Response> deleteFCMToken(String deviceToken) async {
    String token = getToken();
    Map<String, String> body = {'device_token': deviceToken};
    var response =
        await apiService.postPrivate(AppConstants.deleteFCMToken, body, token);
    return response;
  }

  String getToken() {
    return sharedPreferencesManager.getString('token') ?? "";
  }
}

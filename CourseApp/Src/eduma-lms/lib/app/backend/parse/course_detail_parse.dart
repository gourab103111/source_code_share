import 'dart:math';

import 'package:flutter_app/app/backend/api/api.dart';
import 'package:flutter_app/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:flutter_app/app/util/constant.dart';

class CourseDetailParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  CourseDetailParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getDetailCourse(String id) async {
    String token = getToken();
    Random random = Random();
    int randomNumber = random.nextInt(123456789);
    var param = {
      "v": randomNumber.toString(),
    };
    var response = await apiService.getPrivate(
        AppConstants.getCourseDetail + id, token, param);
    return response;
  }

  Future<Response> start(String id) async {
    var param = {
      "id": int.parse(id),
    };
    String token = getToken();
    var response = await apiService.postPrivate(
      AppConstants.enroll,
      param,
      token,
    );
    return response;
  }

  Future<Response> enroll(String id) async {
    var param = {
      "id": int.parse(id),
    };
    String token = getToken();
    var response = await apiService.postPrivate(
      AppConstants.enroll,
      param,
      token,
    );
    return response;
  }

  String getToken() {
    return sharedPreferencesManager.getString('token') ?? "";
  }

  Future<Response> getRating(String id, int? per_page) async {
    String token = getToken();
    var param = {"per_page": per_page != null ? per_page.toString() : null};
    var response =
        await apiService.getPrivate(AppConstants.getRating + id, token, param);
    return response;
  }

  Future<Response> createRating(var body) async {
    String token = getToken();
    var response =
        await apiService.postPrivate(AppConstants.createRating, body, token);
    return response;
  }

  void setOverview(String overview) {
    sharedPreferencesManager.putString('overview', overview);
  }
  String getOverviewId() {
    return sharedPreferencesManager.getString('overview') ?? "";
  }
}

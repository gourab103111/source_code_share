import 'dart:convert';

import 'package:flutter_app/app/backend/api/api.dart';
import 'package:flutter_app/app/backend/models/user_info_model.dart';
import 'package:flutter_app/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:flutter_app/app/util/constant.dart';

class HomeParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  HomeParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getTopCourses() async {
    var response = await apiService.getPublic(AppConstants.getTopCourses, null);
    return response;
  }

  Future<Response> getNewCourses() async {
    var response = await apiService.getPublic(AppConstants.getNewCourses, null);
    return response;
  }

  Future<Response> getIntructor() async {
    var param = {
      "roles": 'lp_teacher,administrator',
    };
    var response = await apiService.getPublic(AppConstants.getIntructor, param);
    return response;
  }

  Future<Response> getCategoryHome() async {
    var response = await apiService.getPublic(
        AppConstants.getCateHome, {"orderby": "count", "order": "desc"});
    return response;
  }

  Future<Response> getOverview() async {
    var param = {
      "optimize":
          'intructor,meta_data,on_sale,count_students,can_finish,can_retake,ratake_count,rataken,duration,tags,categories,rating,price,origin_price,sale_price',
    };
    String token = getToken();
    String overviewId = getOverviewId();
    if (overviewId == "") {
      return const Response(statusCode: 500);
    }
    var response = await apiService.getPrivate(
        "${AppConstants.getOverview}/$overviewId", token, param);
    return response;
  }

  String getToken() {
    return sharedPreferencesManager.getString('token') ?? "";
  }

  String getAvatar() {
    return sharedPreferencesManager.getString('token') ?? "";
  }

  UserInfoModel getUserInfo() {
    String temp = sharedPreferencesManager.getString('user_info') ?? "";

    UserInfoModel json = new UserInfoModel();
    if (temp != "")
      json = UserInfoModel.fromJson(jsonDecode(temp) as Map<String, dynamic>);
    return json;
  }

  Future<Response> getUser(String id) async {
    String token = getToken();
    if (token != null) {
      var response = await apiService.getPrivate(
          "${AppConstants.getUser}/$id", token, null);
      return response;
    } else {
      return Response(statusCode: 400);
    }
  }

  String getOverviewId() {
    return sharedPreferencesManager.getString('overview') ?? "";
  }

  setOverviewId(value) {
    return sharedPreferencesManager.putString('overview', value);
  }
}

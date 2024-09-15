import 'package:flutter_app/app/backend/api/api.dart';
import 'package:flutter_app/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:flutter_app/app/util/constant.dart';

class CoursesParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  CoursesParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getCourses(var body) async {
    var response = await apiService.getPublic(AppConstants.getCourses, body);
    return response;
  }

  Future<Response> getCategory() async {
    var response = await apiService.getPublic(AppConstants.getCategory, null);
    return response;
  }

  String getToken() {
    return sharedPreferencesManager.getString('token') ?? "";
  }
}

import 'package:flutter_app/app/backend/api/api.dart';
import 'package:flutter_app/app/helper/shared_pref.dart';
import 'package:get/get.dart';

import '../../util/constant.dart';

class InstructorDetailParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  InstructorDetailParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getCourse(var body) async {
    var response =
        await apiService.getPublic(AppConstants.getCourses, body);
    return response;
  }
  Future<Response> getInstructor(String userId) async {
    Map<String, dynamic> body = {};
    var response =
    await apiService.getPublic('${AppConstants.getUser}/$userId',body);
    return response;
  }

  String getToken() {
    return sharedPreferencesManager.getString('token') ?? "";
  }
}

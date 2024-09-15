import 'package:flutter_app/app/backend/api/api.dart';
import 'package:flutter_app/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:flutter_app/app/util/constant.dart';

class FinishLearningParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  FinishLearningParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getLesson(String id) async {
    String token = getToken();
    var response = await apiService.getPrivate(
        AppConstants.getLessonWithId + id, token, null);
    return response;
  }

  Future<Response> getQuiz(String id) async {
    String token = getToken();
    var response = await apiService.getPrivate(
        AppConstants.getQuizWithId + id, token, null);
    return response;
  }

  String getToken() {
    return sharedPreferencesManager.getString('token') ?? "";
  }
}

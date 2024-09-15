import 'dart:convert';

import 'package:flutter_app/app/backend/api/api.dart';
import 'package:flutter_app/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:flutter_app/app/util/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LearningParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  LearningParser(
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

  Future<Response> getAssignment(String id) async {
    String token = getToken();
    var response = await apiService.getPrivate(
        AppConstants.getAssignmentWithId + id, token, null);
    return response;
  }

  Future<Response> quizStart(int id) async {
    var param = {
      "id": id,
    };
    String token = getToken();
    var response =
        await apiService.postPrivate(AppConstants.quizStart, param, token);
    return response;
  }

  Future<Response> finishQuiz(String id, dynamic itemTemp) async {
    var param = {
      "id": id,
      "answered": itemTemp,
    };
    String token = getToken();

    var response =
        await apiService.postPrivate(AppConstants.quizFinish, param, token);
    return response;
  }

  Future<Response> completeLesson(String id) async {
    var param = {
      "id": int.parse(id),
    };
    String token = getToken();
    var response =
        await apiService.postPrivate(AppConstants.completeLesson, param, token);
    return response;
  }

  Future<Response> finish(String id) async {
    var param = {
      "id": int.parse(id),
    };
    String token = getToken();
    var response =
        await apiService.postPrivate(AppConstants.finishCourse, param, token);
    return response;
  }

  Future<Response> checkQuestion(param) async {
    String token = getToken();
    var response =
        await apiService.postPrivate(AppConstants.checkQuestion, param, token);
    return response;
  }

  Future<Response> retakeAssignment(id) async {
    String token = getToken();
    var param = {
      "id": int.parse(id),
    };
    var response =
    await apiService.postPrivate(AppConstants.retakeAssignment, param, token);
    return response;
  }
  Future<Response> startAssignment(id) async {
    String token = getToken();
    var param = {
      "id": int.parse(id),
    };
    var response =
    await apiService.postPrivate(AppConstants.startAssignment, param, token);
    return response;
  }

  Future<Response> deleteFileAssignment(id,fileId) async {
    String token = getToken();
    var param = {
      "id": int.parse(id),
      "fileId": fileId,
    };
    var response =
    await apiService.postPrivate(AppConstants.deleteFileAssignment, param, token);
    return response;
  }

  Future<Response> saveOrSendAssignment(Map<String, dynamic> param) async {
    String token = getToken();
    var body = {
      "id": int.parse(param['id']),
      "note":param['note'].toString(),
      "action":param['action']??"send",
      "files":param['files']
    };

    var response =
    await apiService.uploadFilesAssignment(AppConstants.saveOrSendAssignment, body, token);
    return response;
  }

  Future<Response> checkAnswer(String lessonId,String question_id,answered) async {
    String token = getToken();
    var param = {
      "id": int.parse(lessonId),
      "question_id": int.parse(question_id),
      "answered": answered,
    };
    var response = await apiService.postPrivate(AppConstants.checkAnswer, param, token);
    return response;
  }

  String getToken() {
    return sharedPreferencesManager.getString('token') ?? "";
  }

}

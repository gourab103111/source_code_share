import 'package:flutter_app/app/backend/api/api.dart';
import 'package:flutter_app/app/helper/shared_pref.dart';
import 'package:get/get.dart';

import '../../util/constant.dart';

class ReviewParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ReviewParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getReview(String id, var body) async {
    String token = getToken();
    var response =
        await apiService.getPrivate(AppConstants.getRating + id, token, body);
    return response;
  }

  String getToken() {
    return sharedPreferencesManager.getString('token') ?? "";
  }
}

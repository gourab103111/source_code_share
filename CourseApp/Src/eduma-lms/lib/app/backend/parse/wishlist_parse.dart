import 'dart:convert';

import 'package:flutter_app/app/backend/api/api.dart';
import 'package:flutter_app/app/backend/models/course_model.dart';
import 'package:flutter_app/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:flutter_app/app/util/constant.dart';

class WishlistParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  WishlistParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getWishlist(var body) async {
    String token = getToken();
    var response =
        await apiService.getPrivate(AppConstants.getWishList, token, body);
    return response;
  }

  void saveItemToWishlish(
    CourseModel data,
  ) async {
    String json = jsonEncode(data);
    var lst = sharedPreferencesManager.getString('wishlish');
    sharedPreferencesManager.putString('wishlish', json);
  }

  String getToken() {
    return sharedPreferencesManager.getString('token') ?? "";
  }
}

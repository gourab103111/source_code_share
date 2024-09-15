import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/session_store.dart';
import 'package:flutter_app/app/backend/mobx-store/wishlist_store.dart';
import 'package:flutter_app/app/backend/models/user_info_model.dart';
import 'package:flutter_app/app/backend/parse/login_parse.dart';
import 'package:flutter_app/app/controller/my_courses_controller.dart';
import 'package:flutter_app/app/controller/notification_controller.dart';
import 'package:flutter_app/app/helper/dialog_helper.dart';
import 'package:flutter_app/app/util/toast.dart';
import 'package:get/get.dart';
import 'package:jwt_decode/jwt_decode.dart';
import '../helper/router.dart';

class LoginController extends GetxController implements GetxService {
  final LoginParser parser;
  final SessionStore sessionStore;
  final NotificationController notificationController = Get.find<NotificationController>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginController({required this.parser, required this.sessionStore});

  final MyCoursesController myCourseController =
      Get.find<MyCoursesController>();
  var context = Get.context as BuildContext;
  final WishlistStore wishlistStore = Get.find<WishlistStore>();

  Future<void> login(username, password) async {
    if (username == "") {
      showToast("Username is required", isError: true);
      return;
    }
    if (password == "") {
      showToast("Password is required", isError: true);
      return;
    }
    var param = {
      "username": username,
      "password": password,
    };
    DialogHelper.showLoading();
    Response response = await parser.login(param);
    if (response.statusCode == 200) {

      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      parser.saveToken(myMap['token']);
      sessionStore.setToken(myMap['token']);
      wishlistStore.getWishlist();
      myCourseController.refreshData();
      parser.saveUser(myMap['user_id'], myMap['user_login'],
          myMap['user_email'], myMap['user_display_name']);
      sessionStore.getUser();
      notificationController.registerFCMToken(parser.getFcmToken());
      if (sessionStore.getCurrentCoursesId().isEmpty) {
        Timer(
            const Duration(seconds: 2),
            () {
              DialogHelper.hideLoading();
              Get.toNamed(AppRouter.splash);
            }
        );
      } else {
        Get.toNamed(AppRouter.getCourseDetailRoute(),
            arguments: [sessionStore.getCurrentCoursesId()]);
      }
    } else {
      DialogHelper.hideLoading();
      showToast(response.body["message"], isError: true);
    }
  }

  Future<void> getUser() async {
    String token = parser.getToken();
    if (token == "") return;
    Map<String, dynamic> payload = Jwt.parseJwt(token);
    Response response = await parser.getUser(payload["data"]["user"]["id"]);
    if (response.statusCode == 200) {
      UserInfoModel user = UserInfoModel.fromJson(response.body);
      parser.saveUserInfo(user);
    }
    update();
  }

  final OutlineInputBorder enabledBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(8.0),
      topRight: Radius.circular(8.0),
      bottomLeft: Radius.circular(8.0),
      bottomRight: Radius.circular(8.0),
    ),
    borderSide: BorderSide(color: Colors.grey),
  );
}

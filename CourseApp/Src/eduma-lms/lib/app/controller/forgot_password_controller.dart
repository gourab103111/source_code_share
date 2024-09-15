import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/session_store.dart';
import 'package:flutter_app/app/backend/parse/forgot_password_parse.dart';
import 'package:flutter_app/app/backend/parse/login_parse.dart';
import 'package:flutter_app/app/util/toast.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ForgotPasswordController extends GetxController implements GetxService {
  final ForgotPasswordParse parser;
  final SessionStore sessionStore;

  TextEditingController usernameController = TextEditingController();

  ForgotPasswordController({required this.parser, required this.sessionStore});
  var context = Get.context as BuildContext;

  Future<void> forgotPassword(username) async {
    if (username == "") {
      showToast("Email is required", isError: true);
      return;
    }

    var param = {
      "user_login": username
    };
    context.loaderOverlay.show();
    Response response = await parser.forgotPassword(param);
    context.loaderOverlay.hide();
    if (response.statusCode == 200) {
      Alert(context: context, title: "Success", desc: response.body["message"])
          .show();


    } else {
      showToast(response.body["message"], isError: true);
    }
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

import 'dart:async';

import 'package:flutter_app/app/backend/parse/social_login_parse.dart';
import 'package:flutter_app/app/helper/dialog_helper.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../backend/parse/register_parse.dart';
import '../env.dart';
import '../helper/router.dart';

class SocialLoginController extends GetxController {
  RegisterParser registerParser = Get.find();
  SocialLoginParse socialLoginParse = Get.find();
  bool isEnableSocialLogin = false;
  @override
  void onInit() {
    //isSocialLoginEnable();
    super.onInit();
  }

  signInGoogle() async {
    //Google Sign In
    try {
      // await _googleSignIn.signIn().then((result) {
      //   result?.authentication.then((googleKey) async {
      //     //handle login google
      //     final response = await socialLoginParse
      //         .verifyGGLogin({"idToken": googleKey.idToken});
      //
      //     if (response.status.isOk) {
      //       registerParser.saveToken(response.body['token']);
      //       await registerParser.getUser();
      //       DialogHelper.showLoading();
      //       Timer(const Duration(seconds: 2), () {
      //         DialogHelper.hideLoading();
      //         Get.toNamed(AppRouter.splash);
      //       });
      //     }
      //   }).catchError((err) {
      //     print('inner error');
      //   });
      // }).catchError((err) {
      //   print('error occured');
      // });
    } catch (error) {
      print(error);
    }
  }

  signInFacebook() async {
  }

  isSocialLoginEnable() async {
    final response = await socialLoginParse
        .enableSocialLogin();
    isEnableSocialLogin = response.body;
    refresh();
    update();
    return false;
  }
}

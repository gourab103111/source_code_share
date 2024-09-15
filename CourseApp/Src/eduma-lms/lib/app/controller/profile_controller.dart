import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/session_store.dart';
import 'package:flutter_app/app/backend/models/user_info_model.dart';
import 'package:flutter_app/app/backend/parse/my_profile_parse.dart';
import 'package:flutter_app/app/backend/parse/profile_parse.dart';
import 'package:flutter_app/app/helper/router.dart';
import 'package:flutter_app/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/locale_keys.g.dart';
import 'notification_controller.dart';

class ProfileController extends GetxController {
  final SessionStore sessionStore;
  final MyProfileParser myProfileParser;
  final NotificationController notificationController =
      Get.find<NotificationController>();
  bool isLogin = false;

  bool haveData = false;
  UserInfoModel _userInfo = UserInfoModel();

  UserInfoModel get userInfo => _userInfo;
  String? avatar;

  String userLogin = '';
  String emailLogin = '';

  int counter = 0;

  ProfileController({
    required this.sessionStore,
    required this.myProfileParser,
  });

  @override
  void onInit() async {
    getUser();
    super.onInit();
  }

  Future<void> getUser() async {
    if (sessionStore.token == "") return;
    Map<String, dynamic> payload = Jwt.parseJwt(sessionStore.token);
    Response response =
        await myProfileParser.getUser(payload["data"]["user"]["id"]);
    if (response.statusCode == 200) {
      UserInfoModel user = UserInfoModel.fromJson(response.body);
      _userInfo = user;
      avatar = _userInfo.avatar_url;
      isLogin = true;
      myProfileParser.saveUserInfo(user);
    }
    update();
    refresh();
  }

  refreshDataUser(userString) {
    UserInfoModel user = UserInfoModel.fromJson(userString);
    _userInfo = user;
    avatar = _userInfo.avatar_url;
    isLogin = true;
    update();
    refresh();
  }

  Future<void> logout() async {
    var context = Get.context as BuildContext;
    Alert(
      context: context,
      title: tr(LocaleKeys.logout),
      desc: tr(LocaleKeys.alert_logoutTxt),
      buttons: [
        DialogButton(
          child: Text(
            tr(LocaleKeys.alert_cancel),
            style: TextStyle(color: Colors.white, fontFamily: 'medium'),
          ),
          onPressed: () => {Navigator.pop(context)},
        ),
        DialogButton(
          child: Text(
            tr(LocaleKeys.alert_ok),
            style: TextStyle(color: Colors.white, fontFamily: 'medium'),
          ),
          onPressed: () async {
            final profileParser = ProfileParser();
            //delete fcmToken
            String fcmToken = myProfileParser.getFCMToken();
            notificationController.deleteFCMToken(fcmToken);
            profileParser.clearAccount();
            final sharedPref = await SharedPreferences.getInstance();
            sharedPref.setString(
                SharedPreferencesManager.keyFcmToken, fcmToken);
            sessionStore.token = "";
            isLogin = false;
            Get.toNamed(AppRouter.splash);
            update();
          },
        ),
      ],
    ).show();
  }
}

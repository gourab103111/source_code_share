import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/controller/settings_controller.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/get.dart';
import 'package:indexed/indexed.dart';
import 'input-password.dart';

class Password extends StatefulWidget {
  @override
  State<Password> createState() => _PasswordState();

  Password({super.key});
}

class _PasswordState extends State<Password> {
  final SettingsController settingController = Get.find<SettingsController>();
  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);
  var screenHeight =
      (window.physicalSize.longestSide / window.devicePixelRatio);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawerEnableOpenDragGesture: false,
        body: Stack(children: <Widget>[
          Indexed(
            index: 1,
            child: Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: (276 / 375) * screenWidth,
                height: (209 / 375) * screenWidth,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/images/banner-my-course.png',
                      ),
                      fit: BoxFit.contain),
                ),
              ),
            ),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: screenWidth,
                  // color: Colors.blue,
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        // width: 40,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back),
                          color: Colors.grey[900],
                          iconSize: 26,
                        ),
                      ),
                      Expanded(
                          child: Text(
                        tr(LocaleKeys.settings_password),
                        style: const TextStyle(
                          fontFamily: 'medium',
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      )),
                      SizedBox(width: 30,)
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 14),
                            Text(
                              tr(LocaleKeys.settings_currentPassword),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 6),
                            InputPassword(
                              controller:
                                  settingController.currentPasswordController,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 14),
                            Text(
                              tr(LocaleKeys.settings_newPassword),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 6),
                            InputPassword(
                              controller:
                                  settingController.newPasswordController,
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 14),
                            Text(
                              tr(LocaleKeys.settings_confirmNewPassword),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 6),
                            InputPassword(
                              controller:
                                  settingController.confirmPasswordController,
                            )
                          ],
                        ),
                        SizedBox(height: 14),
                        Container(
                          width: screenWidth - 32, // Set the width you want
                          child: ElevatedButton(
                            onPressed: () =>
                                {settingController.submitPassword()},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFBC815),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              tr(LocaleKeys.settings_save),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ))
              ]),
        ]));
  }
}

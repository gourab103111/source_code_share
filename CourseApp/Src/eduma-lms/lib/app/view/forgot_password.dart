import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/session_store.dart';
import 'package:flutter_app/app/controller/forgot_password_controller.dart';
import 'package:flutter_app/app/controller/login_controller.dart';
import 'package:flutter_app/app/helper/router.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/get.dart';
import 'dart:ui';

import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget with GetItStatefulWidgetMixin {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordScreen> {
  TextEditingController usernameController = TextEditingController();
  void onRegister() {
    Future.delayed(Duration.zero, () {
      Get.toNamed(AppRouter.getRegisterRoute());
    });
  }

  @override
  Size size = WidgetsBinding.instance.window.physicalSize;
  var screenWidth =
  (window.physicalSize.shortestSide / window.devicePixelRatio);
  var screenHeight =
  (window.physicalSize.longestSide / window.devicePixelRatio);

  @override
  Widget build(BuildContext context) {
    final sessionStore = Provider.of<SessionStore>(context);

    final value = ForgotPasswordController(sessionStore: sessionStore, parser: Get.find());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(children: <Widget>[
          Positioned(
            left: 16,
            top: 60,
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back),
              color: Colors.grey[500],
              iconSize: 24,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: (1120 / 1500) * screenWidth,
              height: (1272 / 1500) * screenWidth,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/banner-login2.png',
                    ),
                    fit: BoxFit.contain),
              ),
            ),
          ),
          // padding: const EdgeInsets.all(16.0),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 120, 40, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: (98 / 375) * screenWidth,
                  width: (73 / 375) * screenWidth,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          'assets/images/logo-school.png',
                        ),
                        fit: BoxFit.contain),
                  ),
                ),
                 Center(
                  child: Text(
                    tr(LocaleKeys.forgot_title),
                    style: TextStyle(fontFamily: "Sniglet", fontSize: 28),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    tr(LocaleKeys.forgot_description),
                    style: TextStyle(fontFamily: "Sniglet", fontSize: 12),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: usernameController,
                  // obscureText: true,
                  decoration: InputDecoration(
                    hintText: tr(LocaleKeys.forgot_emailPlaceholder),
                  ),
                ),
                const SizedBox(height: 16),
                // Login button
                ElevatedButton(
                  onPressed: () => {value.forgotPassword(usernameController.text), sessionStore.getUser()},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12)),
                  child: Text(
                    tr(LocaleKeys.forgot_btnSubmit),
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Sniglet",
                        fontSize: 16),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
    // });
  }
}

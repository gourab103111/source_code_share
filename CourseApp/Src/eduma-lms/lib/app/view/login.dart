import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/session_store.dart';
import 'package:flutter_app/app/controller/login_controller.dart';
import 'package:flutter_app/app/helper/router.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/get.dart';
import 'dart:ui';

import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

import '../controller/social_login_controller.dart';

class LoginScreen extends StatefulWidget with GetItStatefulWidgetMixin {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  bool _isVisible = false;
  //feature login social
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //SocialLoginController socialLoginController = Get.find();

  void onRegister() {
    Future.delayed(Duration.zero, () {
      Get.toNamed(AppRouter.getRegisterRoute());
    });
  }

  void onForgotPassword() {
    Future.delayed(Duration.zero, () {
      Get.toNamed(AppRouter.forgotPassword);
    });
  }

  @override
  Size size = WidgetsBinding.instance.window.physicalSize;
  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);
  var screenHeight =
      (window.physicalSize.longestSide / window.devicePixelRatio);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sessionStore = Provider.of<SessionStore>(context);

    final loginController = LoginController(sessionStore: sessionStore, parser: Get.find());


    return GetBuilder<SocialLoginController>(builder: (socialLoginController) {
      return  Scaffold(
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
                      tr(LocaleKeys.loginScreen_title),
                      style: TextStyle(fontFamily: "Sniglet", fontSize: 28),
                    ),
                  ),

                  const SizedBox(height: 16),
                  TextField(
                    controller: usernameController,
                    // obscureText: true,
                    decoration: InputDecoration(
                      hintText: tr(LocaleKeys.loginScreen_usernamePlaceholder),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Password text field
                  TextField(
                    obscureText: !_isVisible,
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: tr(LocaleKeys.loginScreen_passwordPlaceholder),
                      suffixIcon: IconButton(
                        icon: Icon(
                            _isVisible ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() {
                          _isVisible = !_isVisible;
                        }),
                      ),
                    ),
                  ),
                  if (socialLoginController.isEnableSocialLogin)
                    Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: SocialLoginButton(
                          buttonType: SocialLoginButtonType.facebook,
                          onPressed: () {
                            socialLoginController.signInFacebook();
                          },
                        )),
                  if (socialLoginController.isEnableSocialLogin)
                    Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: SocialLoginButton(
                          buttonType: SocialLoginButtonType.google,
                          onPressed: () {
                            socialLoginController.signInGoogle();
                          },
                        )),
                  if (socialLoginController.isEnableSocialLogin)
                    Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: SocialLoginButton(
                          buttonType: SocialLoginButtonType.apple,
                          onPressed: () {

                          },
                        )),
                  const SizedBox(height: 16),
                  // Login button
                  ElevatedButton(
                    onPressed: () => {
                      loginController.login(
                          usernameController.text, passwordController.text),
                      sessionStore.getUser()
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12)),
                    child: Text(
                      tr(LocaleKeys.loginScreen_btnLogin),
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Sniglet",
                          fontSize: 16),
                    ),
                  ),
                  TextButton(
                      onPressed: onForgotPassword,
                      child: Text(tr(LocaleKeys.loginScreen_forgotPassword))),
                  const SizedBox(height: 32),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr(LocaleKeys.loginScreen_registerText),
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Sniglet",
                              fontSize: 14),
                        ),
                        Container(
                            padding: const EdgeInsets.fromLTRB(2, 0, 0, 4),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: GestureDetector(
                                onTap: onRegister,
                                child: Text(
                                  tr(LocaleKeys.loginScreen_register),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Sniglet",
                                      fontSize: 14),
                                ))),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      );
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

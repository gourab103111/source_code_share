import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/controller/register_controller.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterScreen> {

  bool _isVisiblePassword = false;
  bool _isVisibleConfirm = false;
  Size size = WidgetsBinding.instance.window.physicalSize;
  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);
  var screenHeight =
      (window.physicalSize.longestSide / window.devicePixelRatio);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(builder: (value) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
              child: Stack(children: <Widget>[
                Positioned(
                  left: -16,
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
                // Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Form(
                  key: value.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 100,
                      ),
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
                          tr(LocaleKeys.registerScreen_title),
                          style: TextStyle(fontFamily: "Sniglet", fontSize: 28),
                        ),
                      ),
                      TextFormField(
                        controller: value.usernameController,
                        decoration: InputDecoration(
                          labelText: tr(LocaleKeys.registerScreen_usernamePlaceholder),
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: value.emailController,
                        decoration: InputDecoration(
                          labelText: tr(LocaleKeys.registerScreen_emailPlaceholder),
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                       SizedBox(height: 16),
                      TextFormField(
                        controller: value.passwordController,
                        decoration: InputDecoration(
                          labelText: tr(LocaleKeys.registerScreen_passwordPlaceholder),
                          suffixIcon: IconButton(
                            icon: Icon(_isVisiblePassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () =>setState(() {
                              _isVisiblePassword = !_isVisiblePassword;
                            }),
                          ),
                        ),
                        obscureText: !_isVisiblePassword,

                        validator: (value) {
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: value.confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: tr(LocaleKeys.registerScreen_confirmPasswordPlaceholder),
                          suffixIcon: IconButton(
                            icon: Icon(_isVisibleConfirm ? Icons.visibility_off : Icons.visibility),
                            onPressed: () =>setState(() {
                              _isVisibleConfirm = !_isVisibleConfirm;
                            }),
                          ),
                        ),
                        obscureText: !_isVisibleConfirm,
                        validator: (value) {
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        Checkbox(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          value: value.agreedToTerms,
                          onChanged: (bool? newValue) {
                            //Do Something When Value Changes to True Or False
                            setState(() {
                              value.agreedToTerms = !value.agreedToTerms;
                            });
                          },
                        ),
                        SizedBox(
                          width: 4,
                        ),
                         Text(
                          tr(LocaleKeys.registerScreen_termAndCondition),
                          style: TextStyle(fontSize: 10),
                        ),
                      ]),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            padding: const EdgeInsets.fromLTRB(0, 12, 0, 12)),
                        child:  Text(
                          tr(LocaleKeys.registerScreen_btnSubmit),
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Sniglet",
                              fontSize: 16),
                        ),
                        onPressed: () {
                          value.register();
                          // if (_formKey.currentState.validate() && _agreedToTerms) {
                          //   // TODO: Register user
                          //   // Navigate to home screen
                          //   Navigator.pushReplacementNamed(context, '/home');
                          // }
                        },
                      ),
                    ],
                  ),
                ),
                // ])
              ])));
    });

  }

  @override
  void dispose() {
   
    super.dispose();
  }
}

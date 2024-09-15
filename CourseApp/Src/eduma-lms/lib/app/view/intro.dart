/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Salon Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2022-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_app/app/controller/intro_controller.dart';
import 'package:flutter_app/app/util/theme.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<IntroController>(builder: (value) {
      return Container(
        decoration: const BoxDecoration(
          color: ThemeProvider.whiteColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                onPressed: () {},
                child: Center(
                  child: Text(
                    'Previous'.tr,
                    style: const TextStyle(
                        fontFamily: 'bold', color: ThemeProvider.blackColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

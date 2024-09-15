import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/helper/router.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:indexed/indexed.dart';

typedef OnNavigateCallback = void Function(int page);

class SettingsScreen extends StatefulWidget with GetItStatefulWidgetMixin {
  final PageController pageController;
  final OnNavigateCallback goBack;
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
  SettingsScreen(
      {super.key, required this.pageController, required this.goBack});
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void onLogin() {
    Future.delayed(Duration.zero, () {
      Get.toNamed(AppRouter.getLoginRoute());
    });
  }

  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);
  var screenHeight =
      (window.physicalSize.longestSide / window.devicePixelRatio);
  int pageActive = 0;
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
                  height: 80.0,
                  width: screenWidth,
                  // color: Colors.blue,
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        // width: 40,
                        child: IconButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            widget.goBack(0);
                          },
                          icon: const Icon(Icons.arrow_back),
                          color: Colors.grey[900],
                          iconSize: 24,
                        ),
                      ),
                      Text(
                        tr( LocaleKeys.settings_title),
                        style: const TextStyle(
                          fontFamily: 'medium',
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                        ),
                      ),
                      Container(width: 40),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                  child: Column(
                    children: [
                      GestureDetector(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Feather.settings,size: 18,),
                                SizedBox(width: 5,),
                                Text(
                                    tr(LocaleKeys.settings_general),
                                    style: TextStyle(
                                      fontFamily: 'medium',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ))
                              ],
                            ),
                            Icon(
                              Ionicons.chevron_forward_outline,
                              size: 18,
                            )
                          ],
                        ),
                        onTap: () => Get.toNamed(AppRouter.general),
                      ),
                      SizedBox(height: 24,),
                      GestureDetector(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Feather.lock,size: 18,),
                                SizedBox(width: 5,),
                                Text(
                                    tr(LocaleKeys.settings_password),
                                    style: TextStyle(
                                      fontFamily: 'medium',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ))
                              ],
                            ),
                            Icon(
                              Ionicons.chevron_forward_outline,
                              size: 18,
                            )
                          ],
                        ),
                        onTap: () => Get.toNamed(AppRouter.password),
                      ),
                      SizedBox(height: 24,),
                      GestureDetector(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Ionicons.language,size: 18,),
                                SizedBox(width: 5,),
                                Text(
                                    tr(LocaleKeys.language),
                                    style: TextStyle(
                                      fontFamily: 'medium',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ))
                              ],
                            ),
                            Icon(
                              Ionicons.chevron_forward_outline,
                              size: 18,
                            )
                          ],
                        ),
                        onTap: () => Get.toNamed(AppRouter.language),
                      ),
                      SizedBox(height: 24,),
                      GestureDetector(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Feather.trash_2,size: 18,),
                                SizedBox(width: 5,),
                                Text(
                                    tr(LocaleKeys.settings_deleteAccount),
                                    style: TextStyle(
                                      fontFamily: 'medium',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ))
                              ],
                            ),
                            Icon(
                              Ionicons.chevron_forward_outline,
                              size: 18,
                            )
                          ],
                        ),
                        onTap: () => Get.toNamed(AppRouter.delete),
                      ),
                    ],
                  ),
                )
              ]),
        ]));
  }
}

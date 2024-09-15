import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/controller/language_controller.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'dart:ui';

import 'package:indexed/indexed.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../helper/shared_pref.dart';
import '../../../../util/theme.dart';

class MultiLanguage extends StatefulWidget {
  const MultiLanguage({super.key});

  @override
  State<MultiLanguage> createState() => _MultiLanguageState();
}

class _MultiLanguageState extends State<MultiLanguage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  LanguageController languageController = Get.find<LanguageController>();
  SharedPreferencesManager sharedPreferencesManager = Get.find();

  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);
  var screenHeight =
      (window.physicalSize.longestSide / window.devicePixelRatio);
  @override
  void initState() {
    languageController.handleChoiceLanguage(sharedPreferencesManager.getString('language')??'en');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(builder: (value) {
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
                    padding: const EdgeInsets.fromLTRB(6, 40, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                        Expanded(child: Text(
                          tr( LocaleKeys.language),
                          style: const TextStyle(
                            fontFamily: 'medium',
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                          ),
                          textAlign: TextAlign.center,
                        )),
                        SizedBox(width: 40,)
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          controller: ScrollController(),
                          itemCount: value.listLanguage.length,
                          itemBuilder: (context, index) {
                            if (index == value.listLanguage.length) {
                              return const Center(
                                  child: SizedBox(
                                width: 20.0,
                                height: 20.0,
                                child: CircularProgressIndicator(),
                              ));
                            } else if (index < value.listLanguage.length) {
                              return Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: GestureDetector(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          value.listLanguage[index]['value']
                                              .toString(),
                                          style: TextStyle(
                                            fontFamily: 'medium',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          )),
                                      if (value.listLanguage[index]
                                              ['isActive'] ==
                                          true)
                                        Icon(
                                          Ionicons.checkmark_circle,
                                          color: ThemeProvider.appColor,
                                        )
                                    ],
                                  ),
                                  onTap: () => value.handleChoiceLanguage(

                                      value.listLanguage[index]['key']),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          })),
                ]),
            Indexed(
              index: 1,
                child: Positioned(
                  right: 20,
                  bottom: 30,
                  left: 20,
                  child: ElevatedButton(
                    onPressed: () {
                       var currentLanguage = languageController.handleChoiceLanguage(languageController.currentKeyLanguage.isNotEmpty?languageController.currentKeyLanguage:sharedPreferencesManager.getString('language')??'en');
                       languageController.handleUpdate(currentLanguage);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFBC815),
                      minimumSize: Size(double.infinity, 46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      tr(LocaleKeys.settings_update),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
            ),

          ]));
    });
  }
}

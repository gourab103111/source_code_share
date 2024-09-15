import 'dart:convert';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/parse/my_profile_parse.dart';
import 'package:flutter_app/app/helper/router.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:indexed/indexed.dart';

import '../../../controller/profile_controller.dart';
import '../../../env.dart';

typedef OnNavigateCallback = void Function(int page);

class Profile extends StatefulWidget {
  final MyProfileParser myProfileParser;
  final ProfileController profileController;
  final OnNavigateCallback goToPage;
  final OnNavigateCallback goBack;

  @override
  State<Profile> createState() => _Profile();

  Profile(
      {required this.myProfileParser,
      super.key,
      required this.goToPage,
      required this.goBack,
      required this.profileController});
}

class _Profile extends State<Profile> {
  @override
  void initState() {
    String? user = widget.myProfileParser.getUserInfo();
    if (user != null) {
      widget.profileController.refreshDataUser(jsonDecode(user));
    }

    super.initState();
  }

  void onLogin() {
    Future.delayed(Duration.zero, () {
      Get.toNamed(AppRouter.getLoginRoute());
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);
  var screenHeight =
      (window.physicalSize.longestSide / window.devicePixelRatio);

  @override
  Widget build(BuildContext context) {
    final value = widget.profileController;
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
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).viewPadding.top),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    tr(LocaleKeys.profile_title),
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              widget.myProfileParser.getToken() == ''
                  ? Container(
                      width: screenWidth,
                      height: screenHeight * 0.7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            tr(LocaleKeys.needLogin),
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: onLogin,
                            child: Text(
                              tr(LocaleKeys.login),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Stack(children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Row(
                                  children: [
                                    value.userInfo.avatar_url != ""
                                        ? Container(
                                            width: 46,
                                            height: 46,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(23),
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(value
                                                      .userInfo.avatar_url),
                                                )))
                                        : CircleAvatar(
                                            radius: 23,
                                            backgroundImage: Image.asset(
                                              'assets/images/default-user-avatar.jpg',
                                            ).image,
                                          ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            value.userInfo.name ?? '',
                                            style: TextStyle(
                                                fontFamily: "Poppins-Medium",
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          if (value.userInfo.description != '')
                                            Text(
                                                value.userInfo.description ??
                                                    '',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        Colors.grey.shade700)),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          if (value.userInfo.email != null)
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.email_outlined,
                                                  color: Colors.amber,
                                                  size: 18,
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(value.userInfo.email ?? '',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors
                                                            .grey.shade700)),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 20,
                                thickness: 0.7,
                                indent: 35,
                                endIndent: 35,
                                color: Colors.grey.shade400,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 30),
                                      GestureDetector(
                                        onTap: () => {widget.goToPage(1)},
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Color(0xFF36CE61),
                                              ),
                                              child: Icon(Feather.settings,
                                                  size: 20,
                                                  color: Colors.white),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              tr(
                                                LocaleKeys.settings_title,
                                              ),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      GestureDetector(
                                        onTap: () => {widget.goToPage(2)},
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Color(0xFFF8C719),
                                              ),
                                              child: Icon(Feather.shopping_bag,
                                                  size: 20,
                                                  color: Colors.white),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              tr(LocaleKeys.myOrders_title),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      SizedBox(height: 40),
                                      Divider(
                                        height: 20,
                                        thickness: 0.7,
                                        indent: 0,
                                        endIndent: 0,
                                        color: Colors.grey.shade400,
                                      ),
                                      SizedBox(height: 50),
                                      GestureDetector(
                                        onTap: value.logout,
                                        child: Row(
                                          children: [
                                            Icon(Icons.logout_outlined,
                                                size: 20,
                                                color: Color(0xFFFF3535)),
                                            SizedBox(width: 14),
                                            Text(
                                              tr(LocaleKeys.logout),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ]),
                    ),
              SizedBox(
                height: widget.myProfileParser.getToken() != '' ? 200 : 50,
              ),
              Text(
                LocaleKeys.profile_version,
                style: TextStyle(fontFamily: 'poppins', fontSize: 12),
              ).tr(args: [Environments.appVersion, Environments.appBuild])
            ],
          )
        ]));
  }
}

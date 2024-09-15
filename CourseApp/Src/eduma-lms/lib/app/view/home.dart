import 'dart:async';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/app/controller/tabs_controller.dart';
import 'package:flutter_app/app/view/components/categories.dart';
import 'package:flutter_app/app/view/components/instructors.dart';
import 'package:flutter_app/app/view/components/new-course.dart';
import 'package:flutter_app/app/view/components/overview.dart';
import 'package:flutter_app/app/view/components/top-course.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/helper/router.dart';
import 'package:get/get.dart';
import 'package:flutter_app/app/controller/home_controller.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:indexed/indexed.dart';
import 'dart:io' show Platform;

class HomeScreen extends StatefulWidget with GetItStatefulWidgetMixin {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var top = 0.0;
  @override
  void initState() {
    final HomeController homeController = Get.find<HomeController>();
    homeController.getOverview();
    super.initState();
  }

  Size size = WidgetsBinding.instance.window.physicalSize;
  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);
  var screenHeight =
      (window.physicalSize.longestSide / window.devicePixelRatio);

  void onLogin() {
    Future.delayed(Duration.zero, () {
      Get.toNamed(AppRouter.getLoginRoute());
    });
  }

  void onRegister() {
    Future.delayed(Duration.zero, () {
      Get.toNamed(AppRouter.getRegisterRoute());
    });
  }

  final TabControllerX tabController = Get.find<TabControllerX>();

  @override
  Widget build(BuildContext context) {
    bool isAndroid = Platform.isAndroid;
    return GetBuilder<HomeController>(
      builder: (value) {
        //check user exist
        Timer(
            const Duration(seconds: 5),
                () {
                  value.handleCheckoutUser(value.parser.getUserInfo().id.toString());
            }
        );

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          drawerEnableOpenDragGesture: false,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Stack(
              children: [
                Indexed(
                  index: 1,
                  child: Positioned(
                    right: 0,
                    top: 0,
                    left: 0,
                    child: Container(
                      width: screenWidth,
                      height: (198 / 375) * screenWidth,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              'assets/images/banner-home.png',
                            ),
                            fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      16, isAndroid?50:MediaQuery.of(context).viewPadding.top, 16, 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Container(
                            width: 115,
                            height: 30,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/icon/icon-home.png',
                                  ),
                                  fit: BoxFit.contain),
                            ),
                          ),
                        ]),
                        value.parser.getToken() == ''
                            ? Row(
                                children: [
                                  GestureDetector(
                                    onTap: onLogin,
                                    child: Container(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          tr(LocaleKeys.login),
                                          style: const TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.black),
                                        )),
                                  ),
                                  const Text("|"),
                                  GestureDetector(
                                    onTap: onRegister,
                                    child: Container(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          tr(LocaleKeys.register),
                                          style: const TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.black),
                                        )),
                                  )
                                ],
                              )
                            : GestureDetector(
                                onTap: () => {
                                  Get.toNamed(
                                      AppRouter.getNotificationRoute(),
                                      arguments: value,
                                    preventDuplicates: false
                                  )
                                },
                                child: Stack(
                                  children: [
                                    Icon(Icons.notifications,color: Colors.black,),
                                    if(value.isNewNotification)
                                    Positioned(child: Icon(Icons.brightness_1,size: 10,color: Colors.red,))
                                  ],
                                ),
                              )
                      ]),
                ),
                Container(
                    padding:EdgeInsets.fromLTRB(0, isAndroid?70:70,0,0),
                    margin: EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        value.parser.getToken() != ""
                            ? Container(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  16,
                                  25,
                                ),
                                child: GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                      context, 'ProfileStackScreen'),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          tabController.updateTabId(4);
                                        },
                                        child: value.parser
                                                        .getUserInfo()
                                                        .avatar_url !=
                                                    ""
                                            ? Container(
                                                width: 46,
                                                height: 46,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            23),
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(value
                                                          .parser
                                                          .getUserInfo()
                                                          .avatar_url),
                                                    )))
                                            : CircleAvatar(
                                                radius: 23,
                                                backgroundImage: Image.asset(
                                                  'assets/images/default-user-avatar.jpg',
                                                ).image,
                                              ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              value.parser.getUserInfo().name ??
                                                  "",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              value.parser
                                                      .getUserInfo()
                                                      .email ??
                                                  "",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        if (value.parser.getToken() != "" &&
                            value.overview != null &&
                            value.overview["id"] != null)
                          Overview(overview: value.overview),
                        Categories(
                          categoriesList: value.cateHomeList,
                        ),
                        TopCourse(
                          topCoursesList: value.topCoursesList,
                        ),
                        NewCourse(newCoursesList: value.newCourseList),
                        Instructors(instructorList: value.instructorList),
                        SizedBox(height: 60,)
                      ],
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}

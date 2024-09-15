import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_app/app/controller/courses_controller.dart';
import 'package:flutter_app/app/controller/home_controller.dart';
import 'package:flutter_app/app/controller/my_courses_controller.dart';
import 'package:flutter_app/app/controller/notification_controller.dart';
import 'package:flutter_app/app/controller/payment_controller.dart';
import 'package:flutter_app/app/controller/tabs_controller.dart';
import 'package:flutter_app/app/util/theme.dart';
import 'package:flutter_app/app/view/courses.dart';
import 'package:flutter_app/app/view/home.dart';
import 'package:flutter_app/app/view/my_courses.dart';
import 'package:flutter_app/app/view/my_profile.dart';
import 'package:flutter_app/app/view/wishlist.dart';
import 'package:get/get.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'dart:io' show Platform;

import '../../l10n/locale_keys.g.dart';

class TabScreen extends StatefulWidget with GetItStatefulWidgetMixin {
  TabScreen({super.key});

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen>
    with SingleTickerProviderStateMixin {
  Size size = WidgetsBinding.instance.window.physicalSize;
  var screenWidth = (window.physicalSize.shortestSide / window.devicePixelRatio);
  final List<Widget> _tabViews = [
    HomeScreen(),
    const CoursesScreen(),
    const MyCoursesScreen(),
    const WishlistScreen(),
    MyProfileScreen()
  ];

  final TabControllerX controller = Get.put(TabControllerX());
  final CoursesController controllerCourse =
      Get.put(CoursesController(parser: Get.find()));
  final HomeController homeController =
      Get.put(HomeController(parser: Get.find()));
  final MyCoursesController myCoursesController =
      Get.put(MyCoursesController(parser: Get.find()));
  final PaymentController paymentController =
      Get.put(PaymentController(parser: Get.find()));
  final NotificationController notificationController =
      Get.put(NotificationController(parser: Get.find()));

  @override
  Widget build(BuildContext context) {
    bool isAndroid = Platform.isAndroid;
    return GetBuilder<TabControllerX>(
        builder: (value) {
      return Scaffold(
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: controller.tabController,
            children: _tabViews,
          ),
          bottomNavigationBar: SafeArea(
            bottom: false,
            child:  Container(
              height: isAndroid?54:70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38, spreadRadius: 0, blurRadius: 10),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child:  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          BottomNavigationBar(
                            backgroundColor: Colors.white,
                            currentIndex: controller.tabId,
                            landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
                            onTap: (index) {
                              setState(() {
                                if (index == 0) {
                                  homeController.getOverview();
                                }
                                if (index == 2) {
                                  myCoursesController.refreshData();
                                }
                                controller.updateTabId(index);
                              });
                            },
                            type: BottomNavigationBarType.fixed,
                            iconSize: 20,
                            selectedFontSize: 12,
                            unselectedFontSize: 12,
                            selectedLabelStyle: TextStyle(
                              color: ThemeProvider.blackColor,
                            ),
                            unselectedLabelStyle: TextStyle(color: Colors.grey.shade400),
                            selectedItemColor: ThemeProvider.blackColor,
                            unselectedItemColor: Colors.grey.shade400,
                            showUnselectedLabels: true,
                            elevation: 4,
                            items: [
                              BottomNavigationBarItem(
                                icon: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Image.asset(
                                    'assets/images/icon-tab/icon-tab-home.png',
                                    width: 20,
                                    height: 20,
                                    color: controller.tabId == 0
                                        ? ThemeProvider.blackColor
                                        : Colors.grey.shade400,
                                  ),
                                ),
                                label: tr(
                                    LocaleKeys.bottomNavigation_home)
                                    .toString(),
                              ),
                              BottomNavigationBarItem(
                                icon: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Image.asset(
                                    'assets/images/icon-tab/icon-tab-coures.png',
                                    // Replace with the actual image path and name
                                    width: 20,
                                    height: 20,
                                    color: controller.tabId == 1
                                        ? ThemeProvider.blackColor
                                        : Colors.grey.shade400,
                                  ),
                                ),
                                label: tr(
                                    LocaleKeys.bottomNavigation_courses)
                                    .toString(),
                              ),
                              BottomNavigationBarItem(
                                icon: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Image.asset(
                                    'assets/images/icon-tab/icon-my-course.png',
                                    // Replace with the actual image path and name
                                    width: 20,
                                    height: 20,
                                    color: controller.tabId == 2
                                        ? ThemeProvider.blackColor
                                        : Colors.grey.shade400,
                                  ),
                                ),
                                label: tr(
                                    LocaleKeys.bottomNavigation_myCourse)
                                    .toString(),
                              ),
                              BottomNavigationBarItem(
                                icon: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Image.asset(
                                    'assets/images/icon-tab/icon-wishlist.png',
                                    // Replace with the actual image path and name
                                    width: 20,
                                    height: 20,
                                    color: controller.tabId == 3
                                        ? ThemeProvider.blackColor
                                        : Colors.grey.shade400,
                                  ),
                                ),
                                label: tr(
                                    LocaleKeys.bottomNavigation_wishlist)
                                    .toString(),
                              ),
                              BottomNavigationBarItem(
                                icon: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Image.asset(
                                    'assets/images/icon-tab/icon-profile.png',
                                    // Replace with the actual image path and name
                                    width: 20,
                                    height: 20,
                                    color: controller.tabId == 4
                                        ? ThemeProvider.blackColor
                                        : Colors.grey.shade400,
                                  ),
                                ),
                                label: tr(LocaleKeys.bottomNavigation_profile),
                              ),
                            ],
                          ),
                          IndexedStack(
                            children: [
                              bottomHeightLight()
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )

      );
    });

  }

  Widget bottomHeightLight(){
      return Divider(
        color: ThemeProvider.appColor,
        height: 3,
        thickness: 3,
        indent: 20+(controller.tabId)*(screenWidth/5),
        endIndent: screenWidth - 60 - (controller.tabId)*(screenWidth/5),
      );
  }
}

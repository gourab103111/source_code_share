import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/init_store.dart';
import 'package:flutter_app/app/backend/mobx-store/session_store.dart';
import 'package:flutter_app/app/controller/my_profile_controller.dart';
import 'package:flutter_app/app/controller/profile_controller.dart';
import 'package:flutter_app/app/controller/settings_controller.dart';
import 'package:flutter_app/app/view/components/profile/my-order-screen.dart';
import 'package:flutter_app/app/view/components/profile/profile-screen.dart';
import 'package:get/get.dart';
import 'package:flutter_app/app/util/theme.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import 'components/profile/settings-screen.dart';

class MyProfileScreen extends StatefulWidget with GetItStatefulWidgetMixin {
  MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late PageController _pageController;
  late ProfileController _profileController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _profileController = ProfileController(sessionStore: sessionStore,myProfileParser: Get.find());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final sessionStore = locator<SessionStore>();

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
    _currentPage = page;
  }

  void _goBack() {
    _pageController.animateToPage(
      0,
      duration: Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
    _currentPage = 0;
  }

  Widget _buildDot(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Colors.blue : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyProfileController>(builder: (value) {
      final SettingsController controllerCourse = Get.put(
          SettingsController(sessionStore: sessionStore, parser: Get.find()));
      return Column(children: [
        Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
          },
          children: [
            Profile(
                myProfileParser: value.parser,
                goToPage: (page) => _goToPage(page),
                goBack: (page) => _goBack(),
                profileController: _profileController,
            ),
            SettingsScreen(
                pageController: _pageController, goBack: (page) => _goBack()),
            MyOrderScreen(
                pageController: _pageController, goBack: (page) => _goBack()),
          ],
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 3; i++)
              GestureDetector(
                onTap: () => _goToPage(i),
                child: Container(),
              ),
          ],
        ),
      ]);
    });
  }
}

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text(
        "page 3",
        style: TextStyle(fontFamily: 'bold', color: ThemeProvider.blackColor),
      ),
    );
  }
}

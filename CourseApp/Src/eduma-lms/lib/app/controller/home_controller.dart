import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/init_store.dart';
import 'package:flutter_app/app/backend/mobx-store/session_store.dart';
import 'package:flutter_app/app/backend/mobx-store/wishlist_store.dart';
import 'package:flutter_app/app/backend/models/cate-model.dart';
import 'package:flutter_app/app/backend/models/course_model.dart';
import 'package:flutter_app/app/backend/models/instructor-model.dart';
import 'package:flutter_app/app/backend/parse/home_parse.dart';
import 'package:flutter_app/app/helper/dialog_helper.dart';
import 'package:flutter_app/app/helper/router.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/locale_keys.g.dart';
import '../backend/parse/profile_parse.dart';

class HomeController extends GetxController implements GetxService {
  final HomeParser parser;
  List<CourseModel> _topCourses = <CourseModel>[];
  List<CourseModel> get topCoursesList => _topCourses;
  List<CategoryModel> _categoriesList = <CategoryModel>[];

  List<CategoryModel> get cateHomeList => _categoriesList;
  List<CourseModel> _newCourseList = <CourseModel>[];

  List<CourseModel> get newCourseList => _newCourseList;
  List<UserInstructorModel> _instructor = <UserInstructorModel>[];

  List<UserInstructorModel> get instructorList => _instructor;
  dynamic _overview;

  dynamic get overview => _overview;
  String token = '';
  bool apiCalled = false;
  final sessionStore = locator<SessionStore>();

  // List<CourseModel> get wishlists => wishlistStore.data.obs;
  final WishlistStore wishlistStore = Get.find<WishlistStore>();
  bool haveData = false;

  String title = '';

  bool isNewNotification = false;

  HomeController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    token = parser.getToken();
    getTopCourses();
    getCategoryHome();
    getNewCourses();
    getIntructor();
    getOverview();
    wishlistStore.getWishlist();
  }

  updateShowNotification(status){
    isNewNotification = status=='true'?true:false;
    refresh();
    update();
  }

  void refreshScreen() {
    update();
  }

  Future<void> getTopCourses() async {
    Response response = await parser.getTopCourses();
    apiCalled = true;

    if (response.statusCode == 200) {
      _topCourses = [];
      response.body.forEach((data) {
        CourseModel course = CourseModel.fromJson(data);
        _topCourses.add(course);
      });
    }
    update();
  }

  Future<void> getNewCourses() async {
    Response response = await parser.getNewCourses();
    apiCalled = true;

    if (response.statusCode == 200) {
      _newCourseList = [];
      response.body.forEach((data) {
        CourseModel course = CourseModel.fromJson(data);
        _newCourseList.add(course);
      });
    }
    update();
  }

  Future<void> getIntructor() async {
    Response response = await parser.getIntructor();
    apiCalled = true;
    if (response.statusCode == 200) {
      _instructor = [];
      response.body.forEach((data) {
        UserInstructorModel intructor = UserInstructorModel.fromJson(data);
        _instructor.add(intructor);
      });
    }
    update();
  }

  Future<void> getCategoryHome() async {
    // var param = {"lat": parser.getLat(), "lng": parser.getLng()};
    Response response = await parser.getCategoryHome();
    apiCalled = true;
    if (response.statusCode == 200) {
      _categoriesList = [];
      response.body.forEach((data) {
        CategoryModel cateData = CategoryModel.fromJson(data);
        _categoriesList.add(cateData);
      });
    }
    update();
  }

  Future<void> getOverview() async {
    // var param = {"lat": parser.getLat(), "lng": parser.getLng()};
    Response response = await parser.getOverview();
    apiCalled = true;
    if (response.statusCode == 200) {
      _overview = response.body;
    }
    update();
    refresh();
  }

  Future<void> onToggleWishlist(CourseModel item) async {
    var context = Get.context as BuildContext;
    if (parser.getToken() == "") {
      Alert(
        context: context,
        title: tr(LocaleKeys.alert_notLoggedIn),
        desc: tr(LocaleKeys.alert_loggedIn),
        buttons: [
          DialogButton(
            color: Colors.red,
            child: Text(
             tr(LocaleKeys.alert_cancel),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () => {Navigator.pop(context)},
          ),
          DialogButton(
            child: Text(
              tr(LocaleKeys.alert_btnLogin),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () => {
              Navigator.pop(context),
              Get.toNamed(AppRouter.getLoginRoute())
            },
          ),
        ],
      ).show();
    } else {
      DialogHelper.showLoading();
      var status = await wishlistStore.toggleWishlist(item);
      DialogHelper.hideLoading();
      print("status: $status");
      if(!status) {
        DialogHelper.showLoading(tr(LocaleKeys.active_lpWishlist));
        Timer(Duration(seconds: 3), () => DialogHelper.hideLoading());
      }
    }
    update();
  }

  setOverviewId(value) {
    parser.setOverviewId(value);
  }

  handleCheckoutUser(id) async {
    Response response = await parser.getUser(id);

    if (response.statusCode != 200 &&response.body!=null&& response.body['code']=='rest_user_invalid_id') {
      final profileParser = ProfileParser();
      profileParser.clearAccount();
      sessionStore.token = "";
      update();
    }

  }

  Future<void> launchInBrowser(String link) async {
    var url = Uri.parse(link);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw '${'Could not launch'} $url';
    }
  }
}

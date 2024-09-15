import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/init_store.dart';
import 'package:flutter_app/app/backend/mobx-store/wishlist_store.dart';
import 'package:flutter_app/app/backend/models/course_model.dart';
import 'package:flutter_app/app/backend/models/instructor-model.dart';
import 'package:flutter_app/app/backend/parse/instructor_detail_parse.dart';
import 'package:flutter_app/app/helper/dialog_helper.dart';
import 'package:flutter_app/app/helper/router.dart';
// import 'package:flutter_app/app/helper/router.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../l10n/locale_keys.g.dart';

class InstructorDetailController extends GetxController {
  final InstructorDetailParser parser;
  InstructorDetailController({required this.parser});

  bool apiCalled = false;

  bool haveData = false;

  final List<CourseModel> _courses = <CourseModel>[];
  List<CourseModel> get coursesList => _courses;

  late ScrollController scrollController;
  bool isLoading = false;
  bool isLoadingMore = true;
  int _page = 1;
  UserInstructorModel? _instructor;
  UserInstructorModel? get instructor => _instructor;

  final int _pageSize = 10;
  final int _totalPages = 10;
  late List<String> list;
  late String _dropdownValue;
  String get dropdownValue => _dropdownValue;

  @override
  void onInit() {
    super.onInit();
    _instructor = Get.arguments[0];
    getData();

    if(_instructor?.instructor_data == null){
      String? userId = _instructor?.id.toString();
      getInstructor(userId);
    }

    scrollController = PageController(viewportFraction: 1.12);
    scrollController.addListener(_onScroll);
  }
  getInstructor(userId) async {
    UserInstructorModel userInstructorModel = UserInstructorModel();
    final response = await parser.getInstructor(userId);

    if (response.statusCode == 200) {
      userInstructorModel = UserInstructorModel.fromJson(response.body);
      _instructor = userInstructorModel;
    }
    return userInstructorModel;
  }
  Future<void> refreshData() async {
    _page = 1;
    isLoadingMore = true;
    _courses.clear();
    await getData();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (!isLoadingMore) return;
      _loadMore();
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (!isLoadingMore) return;
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    _page = _page + 1;
    getData();
  }

  // function to fetch courses from API
  Future<void> getData() async {
    if (!isLoading) {
      isLoading = true;
      var body = {
        "page": _page.toString(),
        "per_page": _pageSize.toString(),
        "optimize": "true",
        "user": _instructor?.id.toString(),
      };

      try {
        final response = await parser.getCourse(body);
        if (response.statusCode == 200) {
          // String temp = jsonEncode(response.body);
          // dynamic data = jsonDecode(temp);
          // ResponseV2 resV2 = ResponseV2.fromJson(data);
          List<CourseModel> lstTemp = [];
          response.body?.forEach((item) {
            CourseModel course = CourseModel.fromJson(item);
            lstTemp.add(course);
          });
          if (lstTemp.length < _pageSize) {
            isLoadingMore = false;
          }
          _courses.addAll(lstTemp);
        } else {
          throw Exception('Failed to load courses');
        }
      } catch (e) {
        print(e);
      } finally {
        isLoading = false; // hide loading indicator
      }
      refresh();
      update();
    }
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
      final WishlistStore wishlistStore = Get.find<WishlistStore>();
      await wishlistStore.toggleWishlist(item);
      DialogHelper.hideLoading();
    }
    update();
  }
}

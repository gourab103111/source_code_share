import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/wishlist_store.dart';
import 'package:flutter_app/app/backend/models/course_model.dart';
import 'package:flutter_app/app/backend/parse/wishlist_parse.dart';
import 'package:flutter_app/app/helper/dialog_helper.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/locale_keys.g.dart';
import '../helper/router.dart';

class WishlistController extends GetxController implements GetxService {
  final WishlistParser parser;

  bool apiCalled = false;

  bool haveData = false;

  final List<CourseModel> _courses = <CourseModel>[];
  List<CourseModel> get coursesList => _courses;

  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  bool isLoadingMore = true;
  int _page = 1;
  final int _pageSize = 10;
  final int _totalPages = 10;
  final WishlistStore wishlistStore = Get.find<WishlistStore>();
  WishlistController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    getData();
    scrollController.addListener(_onScroll);
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
    _courses.addAll(wishlistStore.data);
    isLoadingMore = false;
    isLoading = false; // hide loading indicator
    update();
    // }
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
      refreshData();
      DialogHelper.hideLoading();
    }
    update();
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

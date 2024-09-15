import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/wishlist_store.dart';
import 'package:flutter_app/app/backend/models/course_model.dart';
import 'package:flutter_app/app/backend/parse/review_parse.dart';
import 'package:flutter_app/app/helper/router.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
// import 'package:flutter_app/app/helper/router.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ReviewController extends GetxController {
  final ReviewParser parser;
  ReviewController({required this.parser});

  bool apiCalled = false;

  bool haveData = false;

  final List<dynamic> reviews = <dynamic>[];
  List<dynamic> get reviewList => reviews;

  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  bool isLoadingMore = true;
  int _page = 1;
  String courseId = "";

  final int _pageSize = 15;

  @override
  void onInit() {
    super.onInit();
    courseId = Get.arguments[0];
    getData();
    scrollController.addListener(_onScroll);
  }

  Future<void> refreshData() async {
    _page = 1;
    isLoadingMore = true;
    reviews.clear();
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
      };

      try {
        final response = await parser.getReview(courseId, body);
        if (response.statusCode == 200) {
          List<dynamic> lstTemp = [];
          if (response.body["status"] == "success") {
            response.body["data"]["reviews"]["reviews"]?.forEach((item) {
              lstTemp.add(item);
            });
            if (lstTemp.length < _pageSize) {
              isLoadingMore = false;
            }
            reviews.addAll(lstTemp);
          }
        } else {
          throw Exception('Failed to load review course --- Please check active plugin LP course review');
        }
      } catch (e) {
        print(e);
      } finally {
        isLoading = false; // hide loading indicator
      }
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
      context.loaderOverlay.show();
      final WishlistStore wishlistStore = Get.find<WishlistStore>();
      await wishlistStore.toggleWishlist(item);
      context.loaderOverlay.hide();
    }
    update();
  }
}

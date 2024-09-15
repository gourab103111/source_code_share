import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/wishlist_store.dart';
import 'package:flutter_app/app/backend/models/cate-model.dart';
import 'package:flutter_app/app/backend/models/course_model.dart';
import 'package:flutter_app/app/backend/parse/courses_parse.dart';
import 'package:flutter_app/app/helper/router.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import '../helper/dialog_helper.dart';

class CoursesController extends GetxController implements GetxService {
  final CoursesParser parser;

  bool apiCalled = false;

  bool haveData = false;

  final List<CourseModel> _courses = <CourseModel>[].obs;

  List<CourseModel> get coursesList => _courses;
  List<CategoryModel> _categoriesList = <CategoryModel>[];

  List<CategoryModel> get cateList => _categoriesList;
  late ScrollController scrollController;
  bool isLoading = false;
  bool isLoadingMore = true;
  int _page = 1;
  final int _pageSize = 10;
  final int _totalPages = 10;
  String search = '';
  List<int> _cateIds = [];

  List<int> get cateIds => _cateIds;
  List<dynamic> _list=[];
  List<dynamic> get list => _list;
  String _dropdownValue='';

  String get dropdownValue => _dropdownValue;

  CoursesController({required this.parser});

  void refreshScreen() {
    update();
  }

  Future<void> setKeywordSearch(String value) async {
    search = value;
    refreshData();
  }

  Future<void> onSetCateId(int id) async {
    _cateIds = [id];
    refreshData();
  }

  Future<void> onFilterValue(String v) async {
    _dropdownValue = v;
    refreshData();
  }

  @override
  void onInit() {
    super.onInit();
    getCategory();
    getData();
    handleGetOption();
    scrollController = PageController(viewportFraction: Platform.isAndroid?1.1:1.15);
    //scrollController = ScrollController();
    scrollController.addListener(_onScroll);
  }
  handleGetOption(){
    _list = [
      {
        "key":"Default",
        "index":0,
        "label":tr(LocaleKeys.courses_filters_default)
      },
      {
        "key":"Title",
        "index":1,
        "label":tr(LocaleKeys.courses_filters_title)
      },
      {
        "key":"Newest",
        "index":2,
        "label":tr(LocaleKeys.courses_filters_newest)
      },
      {
        "key":"Oldest",
        "index":3,
        "label":tr(LocaleKeys.courses_filters_oldest)
      },
      {
        "key":"Sale",
        "index":4,
        "label":tr(LocaleKeys.courses_filters_sale)
      },
      {
        "key":"Popular",
        "index":5,
        "label":tr(LocaleKeys.courses_filters_popular)
      }
    ];
    _dropdownValue = list.first['key'];
    update();
    refresh();
  }

  Future<void> onSearch() async {
    Get.toNamed(AppRouter.getSearchCourseRoute(), arguments: [search]);
  }

  Future<void> getCategory() async {
    Response response = await parser.getCategory();
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

  Future<void> refreshData() async {
    _page = 1;
    isLoadingMore = true;
    _courses.clear();
    await getData();
  }

  Future<void> onFilter(int id) async {
    if (_cateIds.contains(id)) {
      _cateIds = _cateIds.where((element) => element != id).toList();
    } else {
      _cateIds.add(id);
    }
    refreshData();
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
        "category": _cateIds.join(','),
      };
      if (search != "") {
        body = {
          ...body,
          "search": search,
        };
      }
      var itemElement = list.firstWhereOrNull((element) => element['key'] == _dropdownValue);
    int? index = 0;
    if(itemElement != null){
      index = itemElement['index'];
    }
      if (index == 4) {
        body = {
          ...body,
          "on_sale": "true",
        };
      }
      if (index == 5) {
        body = {
          ...body,
          "popular": "true",
        };
      }
      if (index == 1) {
        body = {...body, "orderby": "title", "order": "asc"};
      }
      if (index == 2) {
        body = {...body, "orderby": "date", "order": "desc"};
      }
      if (index == 3) {
        body = {...body, "orderby": "date", "order": "asc"};
      }

      try {

        final response = await parser.getCourses(body);
        if (response.statusCode == 200) {
          List<CourseModel> lstTemp = [];
          response.body.forEach((data) {
            CourseModel course = CourseModel.fromJson(data);
            lstTemp.add(course);
          });
          if (lstTemp.length < _pageSize) {
            isLoadingMore = false;
          }
          _courses.addAll(lstTemp);
        } else {
          print('error ${response.body}');
          throw Exception('Failed to load courses');
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
              "Cancel",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () => {Navigator.pop(context)},
          ),
          DialogButton(
            child: Text(
              "Login",
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

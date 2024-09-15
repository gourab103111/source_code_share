import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/models/course_model.dart';
import 'package:flutter_app/app/backend/parse/my_courses_parse.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MyCoursesController extends GetxController implements GetxService {
  final MyCoursesParser parser;
  bool apiCalled = false;

  bool haveData = false;

  final List<CourseModel> _myCourses = <CourseModel>[].obs;

  List<CourseModel> get coursesList => _myCourses;
  TextEditingController keywordController = TextEditingController();
  final ScrollController scrollController = PageController(viewportFraction: 1.1);
  bool isSearch = false;
  String keyword = "";
  bool isLoading = false;
  bool isLoadingMore = true;
  int _page = 1;
  final int _pageSize = 10;
  final int _totalPages = 10;
  late List<dynamic> list;
  late String _dropdownValue;

  String get dropdownValue => _dropdownValue;

  MyCoursesController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    list = [
      {
        "key":"all",
        "label":tr(LocaleKeys.myCourse_filters_all)
      },
      {
        "key":"Passed",
        "label":tr(LocaleKeys.myCourse_filters_passed)
      },
      {
        "key":"In progress",
        "label":tr(LocaleKeys.myCourse_filters_inProgress)
      },
      {
        "key":"Failed",
        "label":tr(LocaleKeys.myCourse_filters_failed)
      },
    ];
    _dropdownValue = list.first['key'];
    getData();
    scrollController.addListener(_onScroll);
  }

  Future<void> onSearch() async {
    keyword = keywordController.text;
    refreshData();
  }

  Future<void> onFilterValue(String v) async {
    _dropdownValue = v;
    refreshData();
  }

  Future<void> toggleSearch(bool v) async {
    isSearch = v;
    if (!isSearch) refreshData();
    update();
  }

  Future<void> setKeyword(String v) async {
    keyword = v;
    refreshData();
  }

  Future<void> refreshData() async {
    _page = 1;
    isLoadingMore = true;
    _myCourses.clear();
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
        "optimize":
            "sections,on_sale,can_finish,can_retake,ratake_count,rataken,rating,price,origin_price,sale_price,tags,count_students,instructor,meta_data",
        // "learned": true,
      };
      if (keyword != "") {
        body = {...body, "search": keyword};
      }

      if (_dropdownValue.contains("In progress")) {
        body = {...body, "course_filter": "in-progress"};
      }
      if (_dropdownValue.contains("Passed")) {
        body = {...body, "course_filter": "passed"};
      }
      if (_dropdownValue.contains("Failed")) {
        body = {...body, "course_filter": "failed"};
      }
      if (_dropdownValue.contains("All")) {
        body = {...body, "course_filter": "failed,passed,in-progress"};
      }
      body = {...body, "learned": "true"};

      try {
        final response = await parser.getMyCourse(body);
        if (response.statusCode == 200) {
          List<CourseModel> lstTemp = [];
          response.body?.forEach((item) {
            CourseModel course = CourseModel.fromJson(item);
            lstTemp.add(course);
          });
          if (lstTemp.length < _pageSize) {
            isLoadingMore = false;
          }
          _myCourses.addAll(lstTemp);
        } else {
          throw Exception('Failed to load my courses');
        }
      } catch (e) {
        print(e);
      } finally {
        isLoading = false; // hide loading indicator
      }
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

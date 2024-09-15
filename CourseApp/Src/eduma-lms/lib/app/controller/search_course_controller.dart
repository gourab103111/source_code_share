import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/parse/search_course_parse.dart';
import 'package:flutter_app/app/controller/courses_controller.dart';
import 'package:get/get.dart';

class SearchCourseController extends GetxController {
  final SearchCourseParser parser;

  bool apiCalled = false;

  bool haveData = false;

  TextEditingController keywordController = TextEditingController();

  SearchCourseController({required this.parser});
  final CoursesController courseController = Get.find<CoursesController>();
  List<String> listRecentSearch = [];
  @override
  void onInit() {
    super.onInit();
    keywordController.text = Get.arguments[0];
    getRecentSearch();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> onSearch(String? value) async {
    if (value == null) {
      courseController.setKeywordSearch(keywordController.text);
      parser.saveRecentSearch(keywordController.text);
    } else {
      if (value == "") return;
      courseController.setKeywordSearch(value);
    }
    onBack();
  }

  void onBack() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  Future<void> getRecentSearch() async {
    listRecentSearch = parser.getRecentSearch();
    update();
  }
}

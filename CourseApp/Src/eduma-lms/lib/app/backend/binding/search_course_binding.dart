import 'package:flutter_app/app/controller/search_course_controller.dart';
import 'package:get/get.dart';

class SearchCourseBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => SearchCourseController(parser: Get.find()),
    );
  }
}

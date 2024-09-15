import 'package:flutter_app/app/controller/course_detail_controller.dart';
import 'package:get/get.dart';

class CourseDetailBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => CourseDetailController(parser: Get.find()),fenix: true
    );
  }
}

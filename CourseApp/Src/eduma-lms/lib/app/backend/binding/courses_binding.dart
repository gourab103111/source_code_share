import 'package:flutter_app/app/controller/courses_controller.dart';
import 'package:get/get.dart';

class CoursesBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => CoursesController(parser: Get.find()),
      fenix: true
    );
  }
}

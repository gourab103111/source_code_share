import 'package:flutter_app/app/controller/courses_controller.dart';
import 'package:flutter_app/app/controller/home_controller.dart';
import 'package:flutter_app/app/controller/my_courses_controller.dart';
import 'package:flutter_app/app/controller/my_profile_controller.dart';
import 'package:flutter_app/app/controller/wishlish_controller.dart';
import 'package:get/get.dart';

import '../../controller/tabs_controller.dart';

class TabsBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => TabControllerX(),fenix: true);
    Get.lazyPut(() => HomeController(parser: Get.find()));
    Get.lazyPut(() => CoursesController(parser: Get.find()));
    Get.lazyPut(() => WishlistController(parser: Get.find()));
    Get.lazyPut(() => MyCoursesController(parser: Get.find()));
    Get.lazyPut(() => MyProfileController(parser: Get.find()));
  }
}

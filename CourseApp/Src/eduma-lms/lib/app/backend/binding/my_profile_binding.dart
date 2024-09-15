import 'package:flutter_app/app/controller/my_profile_controller.dart';
import 'package:get/get.dart';

class MyProfileBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => MyProfileController(parser: Get.find()),
    );
  }
}

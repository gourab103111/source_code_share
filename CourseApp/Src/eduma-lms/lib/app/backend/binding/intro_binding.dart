import 'package:flutter_app/app/controller/intro_controller.dart';
import 'package:get/get.dart';

class IntroBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => IntroController(parser: Get.find()),
    );
  }
}

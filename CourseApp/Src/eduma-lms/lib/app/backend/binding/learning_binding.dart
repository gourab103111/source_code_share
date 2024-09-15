import 'package:flutter_app/app/controller/learing_controller.dart';
import 'package:get/get.dart';

class LearningBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => LearningController(parser: Get.find(), courseDetailParser: Get.find()),
    );
  }
}

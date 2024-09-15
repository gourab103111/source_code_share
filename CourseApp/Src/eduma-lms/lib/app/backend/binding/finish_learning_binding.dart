import 'package:flutter_app/app/controller/finish_learning_controller.dart';
import 'package:get/get.dart';

class FinishLearningBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => FinishLearningController(parser: Get.find()),
      fenix: true
    );
  }
}

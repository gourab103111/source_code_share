import 'package:flutter_app/app/controller/review_controller.dart';
import 'package:get/get.dart';

class ReviewBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => ReviewController(parser: Get.find()),
    );
  }
}

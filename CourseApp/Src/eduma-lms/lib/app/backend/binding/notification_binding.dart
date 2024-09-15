import 'package:flutter_app/app/controller/notification_controller.dart';
import 'package:get/get.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => NotificationController(parser: Get.find()),
    );
  }
}

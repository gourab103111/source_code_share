import 'package:flutter_app/app/controller/wishlish_controller.dart';
import 'package:get/get.dart';

class WishlishBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => WishlistController(parser: Get.find()),
    );
  }
}

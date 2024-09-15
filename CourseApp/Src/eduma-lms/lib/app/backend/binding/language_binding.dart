import 'package:flutter_app/app/controller/language_controller.dart';
import 'package:get/get.dart';

class LanguageBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
          () => LanguageController(sharedPreferencesManager: Get.find()),
    );
  }
}

import 'package:flutter_app/app/backend/parse/intro_parse.dart';
// import 'package:flutter_app/app/helper/router.dart';
import 'package:get/get.dart';

class IntroController extends GetxController implements GetxService {
  final IntroParser parser;
  IntroController({required this.parser});

  // void onSkip() {
  //   Get.toNamed(AppRouter.getWelcomeRoute(), arguments: ['']);
  // }

  // void saveLanguage(String code) {
  //   parser.saveLanguage(code);
  //   update();
  // }
}

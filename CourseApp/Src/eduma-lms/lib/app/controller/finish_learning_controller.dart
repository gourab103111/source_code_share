
import 'package:flutter_app/app/backend/parse/finish-learning_parse.dart';
import 'package:get/get.dart';

class FinishLearningController extends GetxController implements GetxService {
  final FinishLearningParser parser;
  int retakeCount = 0;
  int id = 0;
  FinishLearningController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    // lesson = Get.arguments[0];
    retakeCount = Get.arguments[1];
    id = Get.arguments[2];
  }
}

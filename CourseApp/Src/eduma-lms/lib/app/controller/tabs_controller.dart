import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabControllerX extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  int tabId = 0;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 5, vsync: this, initialIndex: tabId);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void updateTabId(int id) {
    tabId = id;
    tabController.animateTo(tabId);
    update();
  }
}

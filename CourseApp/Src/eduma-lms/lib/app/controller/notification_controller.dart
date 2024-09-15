import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/models/notification_model.dart';
import 'package:flutter_app/app/backend/parse/notification_parse.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get.dart';

import '../helper/dialog_helper.dart';

class NotificationController extends GetxController implements GetxService {
  final NotificationParser parser;
  bool apiCalled = false;

  bool haveData = false;

  List<NotificationModel> _notification = <NotificationModel>[];

  List<NotificationModel> get notificationList => _notification;
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  bool isLoadingMore = true;
  int _page = 1;
  final int _pageSize = 10;
  final int _totalPages = 10;

  NotificationController({required this.parser}) {}

  @override
  Future<void> onInit() async {
    super.onInit();
    await refreshData();
    scrollController.addListener(_onScroll);
  }

  checkUpdateNotification(homeController) {
    if (homeController.isNewNotification) {
      homeController.updateShowNotification(false);
    }
  }

  Future<void> refreshData() async {
    _page = 1;
    isLoadingMore = true;
    _notification.clear();
    await getData();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (!isLoadingMore) return;
      _loadMore();
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (!isLoadingMore) return;
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    _page = _page + 1;
    await getData();
  }

  // function to fetch courses from API
  Future<void> getData() async {
    if (!isLoading) {
      isLoading = true;

      try {
        final response = await parser.getNotification();
        if (response.statusCode == 200) {
          List<NotificationModel> lstTemp = [];

          response.body["data"]["notifications"]?.forEach((item) {
            NotificationModel temp = NotificationModel.fromJson(item);
            lstTemp.add(temp);
          });
          if (lstTemp.length < _pageSize) {
            isLoadingMore = false;
          }
          _notification.addAll(lstTemp);
          if (await FlutterAppBadger.isAppBadgeSupported()) {
            FlutterAppBadger.removeBadge();
          }

          update();
          refresh();
        } else {
          if(parser.getToken() != ""){
            DialogHelper.showErrorDialog(title: 'Failed notifications', description: "Please update addons Announcement add-on for LearnPress version 4.0.5");
            throw Exception('Failed to load notifications');
          }
        }
      } catch (e) {
        print(e);
      } finally {
        isLoading = false; // hide loading indicator
        update();
        refresh();
      }
    }
  }

  Future<void> registerFCMToken(String fcmToken) async {
    try {
      final response = await parser.registerFCMToken(
          fcmToken, Platform.isIOS ? 'ios' : 'android');
      if (response.statusCode == 200) {
        print('Success register FCMToken ${fcmToken}');
      } else {
        throw Exception('Failed to register FCMToken');
      }
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<void> deleteFCMToken(fcmToken) async {
    try {
      final response = await parser.deleteFCMToken(fcmToken);
      if (response.statusCode == 200) {
        print('Success delete FCMToken ${fcmToken}');
      } else {
        throw Exception('Failed to delete FCMToken');
      }
    } catch (e) {
      print(e);
    } finally {}
  }
}

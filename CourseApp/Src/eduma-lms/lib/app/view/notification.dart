import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/controller/notification_controller.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:indexed/indexed.dart';
import '../controller/notification_local_controller.dart';
import 'components/item-notification.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);


  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  NotificationController notificationController = Get.find<NotificationController>();
  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);
  var screenHeight =
      (window.physicalSize.longestSide / window.devicePixelRatio);
  @override
  void initState(){
    NotificationLocalController.initialize(flutterLocalNotificationsPlugin);
    Future.delayed(Duration.zero, () async {
      await notificationController.onInit();
      if(Get.arguments != null){
        notificationController.checkUpdateNotification(Get.arguments);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(builder: (value) {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawerEnableOpenDragGesture: false,
        body: Stack(children: <Widget>[
          Indexed(
            index: 1,
            child: Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: (276 / 375) * screenWidth,
                height: (209 / 375) * screenWidth,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/images/banner-my-course.png',
                      ),
                      fit: BoxFit.contain),
                ),
              ),
            ),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 80.0,
                  width: screenWidth,
                  // color: Colors.blue,
                  padding: EdgeInsets.fromLTRB(
                      0, MediaQuery.of(context).viewPadding.top-10, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        // width: 40,
                        child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.arrow_back),
                          color: Colors.grey[900],
                          iconSize: 24,
                        ),
                      ),
                      Text(
                        tr( LocaleKeys.notification_title),
                        style: const TextStyle(
                          fontFamily: 'Poppins-Medium',
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                        ),
                      ),
                      Container(width: 40),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => value.refreshData(),
                    child: ListView.builder(
                        controller: value.scrollController,
                        itemCount: value.notificationList.length +
                            (value.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == value.notificationList.length) {
                            return const Center(
                                child: SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(),
                            ));
                          }
                          else if (index < value.notificationList.length) {
                            return ItemNotification(
                              item: value.notificationList[index],
                            );
                          } else {
                            return Container(
                              margin: EdgeInsets.only(top: 50),
                              child: Text(
                                tr(LocaleKeys.notification_empty),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade500),
                              ),
                            );
                          }
                        }),
                  ),
                ),
              ])
        ]),
      );
    });
  }
}

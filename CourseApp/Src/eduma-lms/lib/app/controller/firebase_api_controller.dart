import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app/app/controller/home_controller.dart';
import 'package:flutter_app/app/controller/notification_controller.dart';
import 'package:flutter_app/app/helper/shared_pref.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_local_controller.dart';
import '../helper/router.dart';

class FirebaseApiController extends GetxController {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    NotificationLocalController.initialize(flutterLocalNotificationsPlugin);
  }

  @pragma('vm:entry-point')
  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Handling a background message: ${message.messageId}");

    if (message.notification != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      HomeController homeController = Get.find<HomeController>();
      bool isBadge = await FlutterAppBadger.isAppBadgeSupported();
      if (isBadge) {
        //set number badges
        int numberBadge = (prefs.getInt("notify-numbed") ?? 0) + 1;
        prefs.setInt("notify-numbed", numberBadge);
        FlutterAppBadger.updateBadgeCount(numberBadge);
      }
      homeController.updateShowNotification('true');
      NotificationLocalController.showBigTextNotification(
          title: message.notification!.title.toString(),
          body: message.notification!.body.toString(),
          fln: flutterLocalNotificationsPlugin);
    }
  }

  @pragma('vm:entry-point')
  Future<void> initNotifications() async {
    initState();
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //check user login register token
    String tokenUser = prefs.getString("token").toString();
    if (tokenUser.isNotEmpty) {
      Future.delayed(Duration.zero, () async {
        NotificationController notificationController =
            Get.find<NotificationController>();
        notificationController.registerFCMToken(fCMToken.toString());
      });
    }

    prefs.setString(SharedPreferencesManager.keyFcmToken, fCMToken.toString());
    bool isBadge = await FlutterAppBadger.isAppBadgeSupported();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        HomeController homeController = Get.find<HomeController>();
        if (isBadge) {
          //set number badges
          int numberBadge = (prefs.getInt("notify-numbed") ?? 0) + 1;
          prefs.setInt("notify-numbed", numberBadge);
          FlutterAppBadger.updateBadgeCount(numberBadge);
        }
        homeController.updateShowNotification('true');
        NotificationLocalController.showBigTextNotification(
            title: message.notification!.title.toString(),
            body: message.notification!.body.toString(),
            fln: flutterLocalNotificationsPlugin);
      }
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Get.toNamed(AppRouter.getNotificationRoute(), preventDuplicates: false);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message!=null){
        _firebaseMessagingBackgroundHandler(message);
      }
    });
  }
}

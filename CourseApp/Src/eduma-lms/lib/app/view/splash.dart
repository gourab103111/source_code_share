import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/init_store.dart';
import 'package:flutter_app/app/backend/mobx-store/wishlist_store.dart';
import 'package:get/get.dart';
import 'package:flutter_app/app/controller/splash_controller.dart';
import 'package:flutter_app/app/env.dart';
import 'package:flutter_app/app/helper/router.dart';
import 'package:flutter_app/app/util/theme.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
// import 'package:flutter_app/app/util/toast.dart';

class SplashScreen extends StatefulWidget with GetItStatefulWidgetMixin {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // final Connectivity _connectivity = Connectivity();
  // late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    // initConnectivity();
    // _connectivitySubscription =
    //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    Get.find<SplashController>().initSharedData();

    _routing();
  }

  @override
  void dispose() {
    super.dispose();
    // _connectivitySubscription.cancel();
  }

  void _routing() {
    // Get.find<SplashController>().parser.saveWelcome(true);
    Future.delayed(Duration.zero, () {
      Get.offNamed(AppRouter.getTabsBarRoute());
    });
    //   Get.find<SplashController>().getConfigData().then((isSuccess) {
    //     if (isSuccess) {
    //       if (Get.find<SplashController>().getLanguageCode() != '') {
    //         var locale = Get.find<SplashController>().getLanguageCode();
    //         Get.updateLocale(Locale(locale));
    //       } else {
    //         // var locale =
    //         //     Get.find<SplashController>().defaultLanguage.languageCode != '' &&
    //         //             Get.find<SplashController>()
    //         //                     .defaultLanguage
    //         //                     .languageCode !=
    //         //                 ''
    //         //         ? Locale(Get.find<SplashController>()
    //         //             .defaultLanguage
    //         //             .languageCode
    //         //             .toString())
    //         //         : Locale('en'.tr);
    //         // Get.updateLocale(locale);
    //       }

    //       if (Get.find<SplashController>().parser.isNewUser() == false) {
    //         Get.find<SplashController>().parser.saveWelcome(true);
    //         Get.offNamed(AppRouter.getInitialRoute());
    //       } else {
    //         Get.find<SplashController>().parser.saveWelcome(true);
    //         // Get.offNamed(AppRouter.getChooseLocationRoutes());
    //       }
    //       // if (Get.find<SplashController>().parser.isNewUser() == false) {
    //       //   Get.find<SplashController>().parser.saveWelcome(true);
    //       //   Get.offNamed(AppRouter.getIntroRoutes());
    //       // } else {
    //       //   Get.find<SplashController>().parser.saveWelcome(true);
    //       //   Get.offNamed(AppRouter.getChooseLocationRoute());
    //       // }
    //     } else {
    //       // Get.toNamed(AppRouter.getErrorRoutes());
    //     }
    //   });
  }

  // Future<void> initConnectivity() async {
  //   late ConnectivityResult result;
  //   try {
  //     result = await _connectivity.checkConnectivity();
  //   } on PlatformException catch (e) {
  //     e;
  //     return;
  //   }
  //   if (!mounted) {
  //     return Future.value(null);
  //   }
  //   return _updateConnectionStatus(result);
  // }

  // Future<void> _updateConnectionStatus(ConnectivityResult result) async {
  //   bool isNotConnected = result != ConnectivityResult.wifi &&
  //       result != ConnectivityResult.mobile;
  //   if (isNotConnected) {
  //     // showToast('No Internet Connection'.tr);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (value) {
      return Scaffold(
        body: Stack(alignment: AlignmentDirectional.center, children: [
          // const Image(
          //   image: AssetImage('assets/images/splash.png'),
          //   fit: BoxFit.cover,
          //   height: double.infinity,
          //   width: double.infinity,
          //   alignment: Alignment.center,
          // ),
          // const Positioned(
          //   top: 100,
          //   child: Image(
          //     image: AssetImage('assets/images/logo_white.png'),
          //     fit: BoxFit.cover,
          //     height: 50,
          //     width: 50,
          //     alignment: Alignment.center,
          //   ), //CircularAvatar
          // ),
          const Positioned(
            top: 180,

            child: Center(
              child: Text(
                Environments.appName,
                style: TextStyle(
                    color: ThemeProvider.whiteColor, fontFamily: 'bold'),
              ),
            ), //CircularAvatar
          ),
          const Positioned(
            bottom: 50,
            child: Center(
              child: CircularProgressIndicator(
                color: ThemeProvider.whiteColor,
              ),
            ), //CircularAvatar
          ),
          Positioned(
            bottom: 20,
            child: Center(
              child: Text(
                'Developed By '.tr + Environments.companyName,
                style: const TextStyle(
                    color: ThemeProvider.whiteColor, fontFamily: 'bold'),
              ),
            ),
          ),
        ]),
      );
    });
  }
}

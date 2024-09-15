import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/app/backend/mobx-store/init_store.dart';
import 'package:flutter_app/app/backend/mobx-store/session_store.dart';
import 'package:flutter_app/app/backend/mobx-store/wishlist_store.dart';
import 'package:flutter_app/app/controller/language_controller.dart';
import 'package:flutter_app/app/helper/router.dart';
import 'package:flutter_app/app/controller/firebase_api_controller.dart';
import 'package:flutter_app/app/util/constant.dart';
import 'package:flutter_app/app/util/init.dart';
import 'package:get/get.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await MainBinding().dependencies();
  setupLocator();
  Get.put<WishlistStore>(WishlistStore());
  Get.put<SessionStore>(SessionStore());
  //firebase
  await Firebase.initializeApp();
  await FirebaseApiController().initNotifications();
  runApp(EasyLocalization(
    child: MultiProvider(
      providers: [
        Provider<SessionStore>(
          create: (_) => SessionStore(),
        ),
      ],
      child: MyApp(),
    ),
    supportedLocales: [
      Locale('en', 'US'),
      Locale('es', 'ES'),
      Locale('ko', 'KR'),
      Locale('pt', 'PT'),
      Locale('fa', 'IR'),
      Locale('bn', 'BN'),
    ],
    fallbackLocale: Locale('en', 'US'),
    path: 'assets/translations',
  ));
}

class MyApp extends StatelessWidget with GetItMixin {

  MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    LanguageController languageController = Get.find();
    String key = languageController.sharedPreferencesManager.getString("language")??'en';
    var currentLanguage = languageController.handleChoiceLanguage(key);
    var currentLocale = Locale(currentLanguage['key'], currentLanguage['countryCode']);
    context.setLocale(currentLocale);
    return
      GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: GlobalLoaderOverlay(
            child: GetMaterialApp(
              title: AppConstants.appName,
              debugShowCheckedModeBanner: false,
              navigatorKey: Get.key,
              initialRoute: AppRouter.splash,
              getPages: AppRouter.routes,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
            ),
          ));

  }
}

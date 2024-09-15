import 'package:flutter_app/app/backend/api/api.dart';
import 'package:flutter_app/app/backend/parse/course_detail_parse.dart';
import 'package:flutter_app/app/backend/parse/courses_parse.dart';
import 'package:flutter_app/app/backend/parse/finish-learning_parse.dart';
import 'package:flutter_app/app/backend/parse/forgot_password_parse.dart';
import 'package:flutter_app/app/backend/parse/home_parse.dart';
import 'package:flutter_app/app/backend/parse/intro_parse.dart';
import 'package:flutter_app/app/backend/parse/instructor_detail_parse.dart';
import 'package:flutter_app/app/backend/parse/learning_parse.dart';
import 'package:flutter_app/app/backend/parse/login_parse.dart';
import 'package:flutter_app/app/backend/parse/my_courses_parse.dart';
import 'package:flutter_app/app/backend/parse/my_profile_parse.dart';
import 'package:flutter_app/app/backend/parse/notification_parse.dart';
import 'package:flutter_app/app/backend/parse/payment_parse.dart';
import 'package:flutter_app/app/backend/parse/profile_parse.dart';
import 'package:flutter_app/app/backend/parse/register_parse.dart';
import 'package:flutter_app/app/backend/parse/review_parse.dart';
import 'package:flutter_app/app/backend/parse/search_course_parse.dart';
import 'package:flutter_app/app/backend/parse/settings_parse.dart';
import 'package:flutter_app/app/backend/parse/social_login_parse.dart';
import 'package:flutter_app/app/backend/parse/splash_parse.dart';
import 'package:flutter_app/app/backend/parse/tabs_parse.dart';
import 'package:flutter_app/app/backend/parse/wishlist_parse.dart';
import 'package:flutter_app/app/controller/social_login_controller.dart';
import 'package:flutter_app/app/controller/language_controller.dart';
import 'package:flutter_app/app/controller/notification_controller.dart';
import 'package:flutter_app/app/env.dart';
import 'package:flutter_app/app/helper/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import '../controller/tabs_controller.dart';

class MainBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    final sharedPref = await SharedPreferences.getInstance();
    Get.put(
      SharedPreferencesManager(sharedPreferences: sharedPref),
      permanent: true,
    );

    Get.lazyPut(() => ApiService(appBaseUrl: Environments.apiBaseURL));
    Get.lazyPut(
        () => SplashParser(
            apiService: Get.find(), sharedPreferencesManager: Get.find()),
        fenix: true);
    // Parser LazyLoad
    Get.lazyPut(
        () => IntroParser(
            apiService: Get.find(), sharedPreferencesManager: Get.find()),
        fenix: true);
    Get.lazyPut(
        () => SplashParser(
            apiService: Get.find(), sharedPreferencesManager: Get.find()),
        fenix: true);
    Get.lazyPut(
        () => TabsParser(
            apiService: Get.find(), sharedPreferencesManager: Get.find()),
        fenix: true);
    Get.lazyPut(
        () => HomeParser(
            apiService: Get.find(), sharedPreferencesManager: Get.find()),
        fenix: true);
    Get.lazyPut(
        () => CoursesParser(
            apiService: Get.find(), sharedPreferencesManager: Get.find()),
        fenix: true);
    Get.lazyPut(
        () => MyCoursesParser(
            apiService: Get.find(), sharedPreferencesManager: Get.find()),
        fenix: true);
    Get.lazyPut(
        () => WishlistParser(
            apiService: Get.find(), sharedPreferencesManager: Get.find()),
        fenix: true);
    Get.lazyPut(
        () => SearchCourseParser(
            apiService: Get.find(), sharedPreferencesManager: Get.find()),
        fenix: true);
    Get.lazyPut(
        () => MyProfileParser(
            apiService: Get.find(), sharedPreferencesManager: Get.find()),
        fenix: true);
    Get.lazyPut(
        () => CourseDetailParser(
            apiService: Get.find(), sharedPreferencesManager: Get.find()),
        fenix: true);
    Get.lazyPut(
        () => PaymentParser(
            apiService: Get.find(), sharedPreferencesManager: Get.find()),
        fenix: true);

    Get.lazyPut(
        () => LoginParser(
            apiService: Get.find(), sharedPreferencesManager: Get.find()),
        fenix: true);
    Get.lazyPut(() => ForgotPasswordParse(apiService: Get.find()), fenix: true);

    Get.lazyPut(
        () => RegisterParser(
            apiService: Get.find(), sharedPreferencesManager: Get.find()),
        fenix: true);

    Get.lazyPut(
        () => LearningParser(
            apiService: Get.find(), sharedPreferencesManager: Get.find()),
        fenix: true);
    Get.lazyPut(
        () => FinishLearningParser(
            apiService: Get.find(), sharedPreferencesManager: Get.find()),
        fenix: true);
    Get.lazyPut(
        () => InstructorDetailParser(
            apiService: Get.find(), sharedPreferencesManager: Get.find()),
        fenix: true);
    Get.lazyPut(
        () => NotificationParser(
            apiService: Get.find(), sharedPreferencesManager: Get.find()),
        fenix: true);
    Get.lazyPut(
        () => SettingsParser(
            apiService: Get.find(),
            sharedPreferencesManager: Get.find(),
            sessionStore: Get.find()),
        fenix: true);
    Get.lazyPut(
        () => ReviewParser(
            apiService: Get.find(), sharedPreferencesManager: Get.find()),
        fenix: true);
    Get.lazyPut(() => ProfileParser(), fenix: true);
    Get.lazyPut(
        () => SocialLoginParse(
            sharedPreferencesManager: Get.find(), apiService: Get.find()),
        fenix: true);
    Get.lazyPut(() => NotificationController(parser: Get.find()), fenix: true);
    Get.lazyPut(() => LanguageController(sharedPreferencesManager: Get.find()),
        fenix: true);
    Get.lazyPut(() => TabControllerX(), fenix: true);
    Get.lazyPut(() => SocialLoginController(), fenix: true);
  }
}

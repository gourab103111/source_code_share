import 'package:flutter_app/app/env.dart';

class AppConstants {
  static const String appName = Environments.appName;
  static const String companyName = Environments.companyName;
  static const String defaultCurrencyCode = 'USD'; // your currency code in 3 digit
  static const String defaultCurrencySide = 'right'; // default currency position
  static const String defaultCurrencySymbol = '\$'; // default currency symbol
  static const String defaultLanguageApp = 'en';
  static const int defaultMakeingOrder = 0; // 0=> from multiple stores // 1 = single store only
  static const String defaultSMSGateway = '1'; // 2 = firebase // 1 = rest
  static const double defaultDeliverRadius = 50;
  static const int userLogin = 0;
  static const int defaultVerificationForSignup = 0; // 0 = email // 1= phone
  static const int defaultShippingMethod = 0;

  // API Routes
  static const String getAppSettings = 'api/v1/settings/getDefault';
  static const String onlogin = 'wp-json/learnpress/v1/token';
  static const String register = 'wp-json/learnpress/v1/token/register';
  static const String getUser = 'wp-json/learnpress/v1/users';
  static const String forgotPassword = 'wp-json/learnpress/v1/users/reset-password';

  static const String loginWithPhonePassword = 'api/v1/auth/loginWithPhonePassword';
  static const String verifyPhoneFirebase = 'api/v1/auth/verifyPhoneForFirebase';
  static const String verifyPhone = 'api/v1/otp/verifyPhone';
  static const String loginWithMobileToken = 'api/v1/auth/loginWithMobileOtp';
  static const String updateFCM = 'api/v1/profile/update';
  static const String getTopCourses = 'wp-json/learnpress/v1/courses?popular=true&optimize=true';
  static const String getNewCourses = '/wp-json/learnpress/v1/courses?order=desc&optimize=true';
  static const String getIntructor = '/wp-json/learnpress/v1/users';
  static const String getCateHome = 'wp-json/learnpress/v1/course_category';
  static const String getCategory = 'wp-json/wp/v2/course_category';
  static const String getOverview = 'wp-json/learnpress/v1/courses';

  static const String getCourses = 'wp-json/learnpress/v1/courses';
  static const String getWishList = 'wp-json/learnpress/v1/wishlist';
  static const String toggleWishlist = 'wp-json/learnpress/v1/wishlist/toggle';

  static const String getProductIAP = 'wp-json/lp/v1/mobile-app/product-iap';
  static const String getCourseDetail = 'wp-json/learnpress/v1/courses/';
  static const String getWishlistWithId = 'wp-json/learnpress/v1/wishlist/course/';
  static const String enroll = 'wp-json/learnpress/v1/courses/enroll';
  static const String getLessonWithId = 'wp-json/learnpress/v1/lessons/';
  static const String completeLesson = 'wp-json/learnpress/v1/lessons/finish';
  static const String finishCourse = 'wp-json/learnpress/v1/courses/finish';
  static const String getQuizWithId = 'wp-json/learnpress/v1/quiz/';
  static const String getAssignmentWithId = 'wp-json/learnpress/v1/assignments/';
  static const String quizStart = 'wp-json/learnpress/v1/quiz/start';
  static const String quizFinish = 'wp-json/learnpress/v1/quiz/finish';
  static const String checkQuestion = 'wp-json/learnpress/v1/quiz/check_answer';
  static const String retakeAssignment = 'wp-json/learnpress/v1/assignments/retake';
  static const String startAssignment = 'wp-json/learnpress/v1/assignments/start';
  static const String saveOrSendAssignment = 'wp-json/learnpress/v1/assignments/submit';
  static const String deleteFileAssignment = 'wp-json/learnpress/v1/assignments/delete-submit-file';
  static const String checkAnswer = 'wp-json/learnpress/v1/quiz/check_answer';
  static const String getNotification = '/wp-json/learnpress/notifications/v1/notifications';
  static const String registerFCMToken = '/wp-json/learnpress/v1/push-notifications/register-device';
  static const String deleteFCMToken = '/wp-json/learnpress/v1/push-notifications/delete-device';
  static const String getRating = 'wp-json/learnpress/v1/review/course/';
  static const String createRating = 'wp-json/learnpress/v1/review/submit';
  static const String verifyReceipt = 'wp-json/learnpress/v1/courses/verify-receipt';
  static const String changePassword = 'wp-json/learnpress/v1/users/change-password';
  static const String deletePassword = 'wp-json/learnpress/v1/users/delete';
  static const String updateUser = 'wp-json/learnpress/v1/users/';
  static const String enableSocialLogin = '/wp-json/lp/v1/mobile-app/enable-social';
  static const String verifyGGLogin = '/wp-json/lp/v1/mobile-app/verify-google';
  static const String verifyAppleLogin = '/wp-json/lp/v1/mobile-app/verify-apple';
  static const String verifyFBLogin = '/wp-json/lp/v1/mobile-app/verify-facebook';
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';

class Helper {
  static bool checkHttpOrHttps(String link) {
    // Regular expression to check if the link starts with http:// or https://
    RegExp regex = RegExp(r"^(http:\/\/|https:\/\/)");

    // Test if the link matches the regular expression
    return regex.hasMatch(link);
  }

  static String handleTranslationsDuration(String duration) {
    String result = "";
    if (duration.isEmpty) {
      return result;
    }
    List<String> words = duration.split(' ');
    result += words[0] + " ";
    switch (words[1].toLowerCase()) {
      case "weeks":
      case "week":
        result += tr(LocaleKeys.weeks);
        break;
      case "hours":
      case "hour":
        result += tr(LocaleKeys.hour);
      case "days":
      case "day":
        result += tr(LocaleKeys.days);
      case "minutes":
      case "mins":
        result += tr(LocaleKeys.minutes);
    }
    return result;
  }

  static String handleTranslationsStatusOrder(String status) {
    String result = "";
    switch (status) {
      case "completed":
        result += tr(LocaleKeys.myOrders_completed);
        break;
    };
    return result;
  }
  static String handleTranslationsGraduationText(String graduationText){
    String result = "";
    switch (graduationText) {
      case "Failed":
        result += tr(LocaleKeys.reviewQuiz_status_failed);
        break;

      case "Success":
        result += tr(LocaleKeys.reviewQuiz_status_success);
        break;
    };
    return result;
  }
}

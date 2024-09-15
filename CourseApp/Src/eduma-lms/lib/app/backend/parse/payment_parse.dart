import 'package:get/get_connect/http/src/response/response.dart';

import '../../helper/shared_pref.dart';
import '../../util/constant.dart';
import '../api/api.dart';

class PaymentParser {
  final ApiService apiService;
  final SharedPreferencesManager sharedPreferencesManager;
  PaymentParser({required this.apiService,required this.sharedPreferencesManager});

  Future<Response> checkCourse(String receipt,isIos,String id) async {
    var param = {
    'receipt-data': receipt,
    'is-ios': isIos,
    'course-id': id,
    'platform': "flutter",
    };
    var response =
    await apiService.postPrivate(AppConstants.verifyReceipt, param, getToken());
    return response;
  }
  String getToken() {
    return sharedPreferencesManager.getString('token') ?? "";
  }
}
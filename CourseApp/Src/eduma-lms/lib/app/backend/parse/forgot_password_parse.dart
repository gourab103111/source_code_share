import 'package:get/get_connect/http/src/response/response.dart';

import '../../util/constant.dart';
import '../api/api.dart';

class ForgotPasswordParse{
  final ApiService apiService;
  ForgotPasswordParse({required this.apiService});
  Future<Response> forgotPassword(var body) async {
    var response = await apiService.postPublic(AppConstants.forgotPassword, body);
    return response;
  }
}
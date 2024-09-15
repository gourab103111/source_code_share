import 'package:get/get_connect/http/src/response/response.dart';

import '../../env.dart';
import '../../helper/shared_pref.dart';
import '../../util/constant.dart';
import '../api/api.dart';

class SocialLoginParse {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  SocialLoginParse({required this.sharedPreferencesManager,required this.apiService});

  Future<Response> verifyGGLogin(var body) async {
    var response =
        await apiService.postPublic(AppConstants.verifyGGLogin, body);
    return response;
  }
  Future<Response> verifyFbLogin(var body) async {
    var response =
    await apiService.postPublic(AppConstants.verifyFBLogin, body);
    return response;
  }
  Future<Response> checkTokenFB() async {
    Map<String, dynamic> param = Map();
    param['client_id'] = Environments.facebookClientId;
    param['client_secret'] = Environments.facebookClientSecret;
    param['grant_type'] = 'client_credentials';
    var response =
    await apiService.get('https://graph.facebook.com/oauth/access_token', param);
    return response;
  }

  Future<Response> enableSocialLogin() async {
    Map<String, dynamic> body =Map<String, dynamic>();
    var response =
    await apiService.getPrivate(AppConstants.enableSocialLogin,'',body);
    return response;
  }
}

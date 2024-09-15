import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ApiService extends GetxService {
  final String appBaseUrl;
  static const String connectionIssue = 'Connection failed!';
  final int timeoutInSeconds = 30;

  ApiService({required this.appBaseUrl});

  Future<Response> get(String uri, Map<String, dynamic>? params) async {
    final String queryString = "?${Uri(queryParameters: params).query}";
    final Uri url = Uri.parse(uri + queryString);

    try {
      http.Response response = await http.get(url, headers: {
        'Content-Type': 'application/json;'
      }).timeout(Duration(seconds: timeoutInSeconds));
      // print(response.body);
      return parseResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> getPublic(String uri, Map<String, dynamic>? params) async {
    final String queryString = "?${Uri(queryParameters: params).query}";
    final Uri url = Uri.parse(appBaseUrl + uri + queryString);

    try {
      http.Response response = await http.get(url, headers: {
        'Content-Type': 'application/json;',
        'x-platform': 'flutter',
      }).timeout(Duration(seconds: timeoutInSeconds));
      // print(response.body);
      return parseResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> getPrivate(
      String uri, String token, Map<String, dynamic>? params) async {
    Random random = Random();
    int randomNumber = random.nextInt(4294967296);
    final String queryString = "?${Uri(queryParameters: params).query}";
    final Uri url =
        Uri.parse(appBaseUrl + uri + queryString + "?v=$randomNumber");
    try {
      http.Response response = await http.get(url, headers: {
        'Content-Type': 'application/json;',
        'x-platform': 'flutter',
        'Authorization': 'Bearer $token'
      }).timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> getPrivateV2(String uri, String token, var params) async {
    Random random = Random();

    int randomNumber = random.nextInt(4294967296);
    final String queryString =
        "?learned=true&${Uri(queryParameters: params).query}";
    String uriTemp = appBaseUrl + uri + queryString + "&?v=$randomNumber";
    final Uri url = Uri.parse(uriTemp);
    try {
      http.Response response = await http.get(url, headers: {
        'Content-Type': 'application/json;',
        'x-platform': 'flutter',
        'Authorization': 'Bearer $token'
      }).timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> uploadFilesAssignment(
      String uri, Map<String, dynamic>? param, String token) async {
    try {
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(appBaseUrl + uri));
      request.headers.addAll({
        'Content-Type': 'application/json;',
        'x-platform': 'flutter',
        'Authorization': 'Bearer $token'
      });

      request.fields['id'] = param!['id'].toString();
      request.fields['note'] = param['note'];
      request.fields['action'] = param['action'];
      if (param['files'] != null && !param['files'].isEmpty) {
        for (int i = 0; i < param['files'].length; i++) {
          request.files.add(await http.MultipartFile.fromPath(
              'file[]', param['files'][i].path));
        }
      }

      http.Response response =
          await http.Response.fromStream(await request.send());
      return parseResponse(response, uri);
    } catch (e) {
      print(e);
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> postPublic(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      http.Response response = await http
          .post(
            Uri.parse(appBaseUrl + uri),
            headers: {
              "Content-Type": "application/json",
              'x-platform': 'flutter',
              "Accept": 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, appBaseUrl + uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> postPrivate(
    String uri,
    dynamic body,
    String token,
  ) async {
    try {
      http.Response response = await http
          .post(Uri.parse(appBaseUrl + uri), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
        'x-platform': 'flutter',
        'Authorization': 'Bearer $token'
      }).timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> postPrivateMultipart(
    String uri,
    dynamic body,
    String token,
  ) async {
    try {
      final url = Uri.parse(appBaseUrl + uri);
      var request = new http.MultipartRequest('POST', url);
      request = jsonToFormData(request, body);
      var headers = {
        // 'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $token',
        'x-platform': 'flutter',
      };
      request.headers.addAll(headers);
      http.Response response =
          await http.Response.fromStream(await request.send());

      return parseResponse(response, appBaseUrl + uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  jsonToFormData(http.MultipartRequest request, Map<String, dynamic> data) {
    for (var key in data.keys) {
      if (key != "lp_avatar_file") {
        request.fields[key] = data[key].toString();
      } else {
        File file = data[key];
        request.files.add(http.MultipartFile(
          key,
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: file.path.split('/').last,
        ));
      }
    }
    return request;
  }

  Future<Response> logout(
    String uri,
    String token,
  ) async {
    try {
      http.Response response =
          await http.post(Uri.parse(appBaseUrl + uri), headers: {
        'Content-Type': 'application/json',
        'x-platform': 'flutter',
        'Authorization': 'Bearer $token'
      }).timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Response parseResponse(http.Response res, String uri) {
    dynamic body;
    try {
      body = jsonDecode(res.body);
    } catch (e) {
      print(e);
    }
    Response response = Response(
      body: body != '' ? body : res.body,
      bodyString: res.body.toString(),
      headers: res.headers,
      statusCode: res.statusCode,
      statusText: res.reasonPhrase,
    );

    if (response.statusCode != 200 &&
        response.body != null &&
        response.body is! String) {
      if (response.body.toString().startsWith('{errors: [{code:')) {
        response = Response(
            statusCode: response.statusCode,
            body: response.body,
            statusText: 'error');
      } else if (response.body.toString().startsWith('{message')) {
        response = Response(
            statusCode: response.statusCode,
            body: response.body,
            statusText: response.body['message']);
      }
    } else if (response.statusCode != 200 && response.body == null) {
      response = const Response(statusCode: 0, statusText: connectionIssue);
    }
    return response;
  }
}

class MultipartBody {
  String key;
  XFile file;

  MultipartBody(this.key, this.file);
}

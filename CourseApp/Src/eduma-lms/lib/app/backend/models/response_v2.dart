import 'dart:convert';

class ResponseV2 {
  String? status;
  String? message;
  dynamic data;

  ResponseV2({
    this.status,
    this.message,
    this.data,
  });

  ResponseV2.fromJson(
    Map<String, dynamic> json,
  ) {
    status = json['status'].toString();
    message = json['message'].toString();
    String dataTemp = jsonEncode(json['data']);
    dynamic newData = jsonDecode(dataTemp);
    dynamic items = newData["items"];
    data = items;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['data'] = data;

    return data;
  }
}

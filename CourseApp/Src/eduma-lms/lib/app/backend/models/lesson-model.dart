import 'dart:convert';

import 'package:flutter_app/app/backend/models/cate-model.dart';

class ItemLesson {
  int? id;
  String? type;
  String? title;
  bool? preview;
  String? duration;
  String? graduation;
  String? status;
  bool? locked;
  ItemLesson({
    this.id,
    this.type,
    this.title,
    this.preview,
    this.duration,
    this.graduation,
    this.status,
    this.locked,
  });
  ItemLesson.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    type = json['type'];
    title = json['title'];
    preview = json['preview'] as bool;
    duration = json['duration'];
    graduation = json['graduation'];
    status = json['status'];
    locked = json['locked'] as bool;
  }
}

class LessonModel {
  int? id;
  String? title;
  int? course_id;
  String? description;
  int? order;
  List<ItemLesson>? items;
  bool isExpanded = false;

  List<CategoryModel>? categories = [];
  dynamic meta_data;
  int count_students = 0;
  LessonModel({
    this.id,
    this.title,
    this.course_id,
    this.description,
    this.order,
    this.items,
    this.isExpanded = false,
  });

  LessonModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    course_id = int.parse(json['course_id'].toString());
    order = int.parse(json['order'].toString());
    title = json['title'];
    description = json['description'];

    String data = jsonEncode(json['items']);
    List<dynamic> newData = jsonDecode(data);
    List<ItemLesson>? temp = [];
    for (var element in newData) {
      ItemLesson? cate = ItemLesson.fromJson(element);
      temp.add(cate);
    }
    items = temp;
  }
}

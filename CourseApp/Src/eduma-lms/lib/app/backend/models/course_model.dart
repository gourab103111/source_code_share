import 'dart:convert';

import 'package:flutter_app/app/backend/models/cate-model.dart';
import 'package:flutter_app/app/backend/models/lesson-model.dart';

class CourseModel {
  int? id;
  String? name;
  String? slug;
  String? permalink;
  String? image;
  String? date_created;
  String? date_created_gmt;
  String? status;
  bool? on_sale;
  String? content;
  String? excerpt;
  String? duration = "";
  double? rating = 0;
  double? price;
  String? price_rendered;
  double? origin_price;
  String? origin_price_rendered;
  double? sale_price;
  String? sale_price_rendered;
  List<CategoryModel>? categories = [];
  MetaData? meta_data;
  int count_students = 0;
  CourseDataModel? course_data;
  bool? can_retake;
  dynamic instructor;

  List<LessonModel>? sections;
  CourseModel({
    this.id,
    this.name,
    this.slug,
    this.permalink,
    this.image,
    this.date_created,
    this.date_created_gmt,
    this.status,
    this.on_sale,
    this.content,
    this.excerpt,
    this.duration,
    this.rating,
    this.price,
    this.price_rendered,
    this.origin_price,
    this.origin_price_rendered,
    this.sale_price,
    this.sale_price_rendered,
    this.categories,
    this.meta_data,
    this.count_students = 0,
    this.course_data,
    this.can_retake,
    this.instructor,
  });

  CourseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.parse(json['id'].toString());
    // print(json['course_data']);
    name = json['name'];
    slug = json['slug'];
    permalink = json['permalink'];
    image = json['image'];
    date_created = json['date_created'];
    date_created_gmt = json['date_created_gmt'];
    status = json['status'];
    on_sale = json['on_sale'];
    content = json['content'];

    excerpt = json['excerpt'];
    if (json['duration'] != null) duration = json['duration'];
    if (json['instructor'] != null) instructor = json['instructor'];
    if (json['count_students'] != null) {
      count_students = int.parse(json['count_students'].toString());
    }
    if (json['rating'] != null && json['rating'].runtimeType == String)
      rating = double.parse(json['rating'].toString());
    if (json['price'] != null) price = double.parse(json['price'].toString());
    price_rendered = json['price_rendered'];
    if (json['origin_price'] != null&&json['origin_price'] != "") {
      origin_price = double.parse(json['origin_price'].toString());
    }
    origin_price_rendered = json['origin_price_rendered'];
    if (json['sale_price'] != null) {
      sale_price = double.parse(json['sale_price'].toString());
    }
    sale_price_rendered = json['sale_price_rendered'];
    if (json['categories'] != null) {
      String data = jsonEncode(json['categories']);
      List<dynamic> newData = jsonDecode(data);
      List<CategoryModel> cates = [];
      for (var element in newData) {
        CategoryModel cate = CategoryModel.fromJson(element);
        cates.add(cate);
      }
      categories = cates;
    }
    String dataMetaData = jsonEncode(json['meta_data']);
    // List<dynamic> newMetaData = jsonDecode(dataMetaData);
    if (dataMetaData != "[]" && json['meta_data'] != null) {
      meta_data = MetaData.fromJson(json['meta_data']);
    }
    if (json['sections'] != null) {
      String jsonSection = jsonEncode(json['sections']);
      List<dynamic> newDataSection = jsonDecode(jsonSection);
      List<LessonModel> sectionsTemp = [];
      for (var element in newDataSection) {
        LessonModel temp = LessonModel.fromJson(element);
        sectionsTemp.add(temp);
      }
      sections = sectionsTemp;
    }
    if (json['course_data'] != null) {
      course_data = CourseDataModel.fromJson(json['course_data']);
    }

    if (json['can_retake'] != null) {
      if (json["can_retake"].toString() == "0") {
        can_retake =
            int.parse(json["can_retake"].toString()) == 0 ? false : true;
      }
      if (json["can_retake"] == false || json["can_retake"] == true) {
        can_retake = json["can_retake"];
      }
    } else {
      can_retake = false;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['permalink'] = permalink;
    data['image'] = image;
    data['date_created'] = date_created;
    data['date_created_gmt'] = date_created_gmt;
    data['status'] = status;
    data['on_sale'] = on_sale;
    data['content'] = content;

    data['excerpt'] = excerpt;
    data['duration'] = duration;
    data['rating'] = rating;
    data['price'] = price;
    data['price_rendered'] = price_rendered;
    data['origin_price'] = origin_price;
    data['origin_price_rendered'] = origin_price_rendered;
    data['sale_price'] = sale_price;
    data['sale_price_rendered'] = sale_price_rendered;
    data['categories'] = categories;
    data['meta_data'] = meta_data;
    data['sections'] = sections;

    return data;
  }
}

class CourseDataModel {
  String? graduation;
  String? status;
  String? start_time;
  String? end_time;
  String? expiration_time;
  CourseDataResult? result;
  CourseDataModel({
    this.graduation,
    this.status,
    this.start_time,
    this.end_time,
    this.expiration_time,
    this.result,
  });
  CourseDataModel.fromJson(Map<String, dynamic> json) {
    graduation = json['graduation'];
    status = json['status'];
    start_time = json['start_time'];
    end_time = json['end_time'];
    expiration_time = json['expiration_time'];
    result = CourseDataResult.fromJson(json['result']);
  }
}

class CourseDataResult {
  double? result;
  int? pass;
  int? count_items;
  int? completed_items;
  ItemResult? items;
  CourseDataResult({
    this.result,
    this.pass,
    this.count_items,
    this.completed_items,
    this.items,
  });
  CourseDataResult.fromJson(Map<String, dynamic> json) {
    result = double.parse(json['result'].toString());
    pass = json['pass'];
    count_items = int.parse(json['count_items'].toString());
    completed_items = int.parse(json['completed_items'].toString());
    if(json['items'].isNotEmpty){
      items = ItemResult.fromJson(json['items']);
    }

  }
}

class ItemResult {
  ItemOption? lesson;
  ItemOption? quiz;
  ItemResult({this.lesson, this.quiz});
  ItemResult.fromJson(Map<String, dynamic> json) {
    lesson = ItemOption.fromJson(json['lesson']);
    quiz = ItemOption.fromJson(json['quiz']);
  }
}

class ItemOption {
  int? completed;
  int? passed;
  int? total;
  ItemOption({this.completed, this.passed, this.total});
  ItemOption.fromJson(Map<String, dynamic> json) {
    completed = int.parse(json['completed'].toString());
    passed = int.parse(json['passed'].toString());
    total = int.parse(json['total'].toString());
  }
}

class MetaData {
  double? lp_passing_condition;
  MetaData({this.lp_passing_condition});
  MetaData.fromJson(Map<String, dynamic> json) {
    if (json['_lp_passing_condition'] != null) {
      lp_passing_condition =
          double.parse(json['_lp_passing_condition'].toString());
    }
  }
}

import 'dart:ffi';

import 'package:flutter/material.dart';

class UserInfoModel extends ChangeNotifier {
  int? id;
  String? username;
  String? name;
  String? first_name;
  String? last_name;
  String? email;
  String? url;
  String? description;
  String? nickname;
  //UserTab? tabs;
  dynamic tabs;
  late String avatar_url = "";
  dynamic instructor_data;

  UserInfoModel({
    this.id,
    this.username,
    this.name,
    this.first_name,
    this.last_name,
    this.email,
    this.url,
    this.description,
    this.nickname,
    this.tabs,
    this.avatar_url = "",
    this.instructor_data,
  });

  UserInfoModel.fromJson(Map<String, dynamic> json) {

    id = int.parse(json['id'].toString());
    username = json['username'].toString();
    name = json['name'];
    first_name = json['first_name'].toString();
    nickname = json['nickname'].toString();
    last_name = json['last_name'].toString();
    email = json['email'].toString();
    url = json['url'].toString();
    description = json['description'].toString();

    // if(json['tabs'] != null){
    //   tabs = UserTab.fromJson(json['tabs']);
    // }
    tabs = json['tabs'];

    if (json['avatar_url'] != null) {
      avatar_url = json['avatar_url'].toString();
    } else
      avatar_url = "";
    instructor_data = json['instructor_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['name'] = name;
    data['first_name'] = first_name;
    data['last_name'] = last_name;
    data['email'] = email;
    data['url'] = url;
    data['description'] = description;
    data['tabs'] = tabs;
    data['avatar_url'] = avatar_url;
    data['instructor_data'] = instructor_data;
    data['nickname'] = nickname;

    return data;
  }
}
class UserTab {
  MyCourses? my_courses;
  OrderData? orders;
  UserTab({this.my_courses,this.orders});

  UserTab.fromJson(Map<String, dynamic> json){
    my_courses = MyCourses.fromJson(json['my-courses']);
    orders = OrderData.fromJson(json['orders']);
  }

}

class Order {
  final String orderKey;
  final int total;
  final String currency;
  final String status;
  final String date;

  Order({
    required this.orderKey,
    required this.total,
    required this.currency,
    required this.status,
    required this.date,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderKey: json['order_key'],
      total: json['total'],
      currency: json['currency'],
      status: json['status'],
      date: json['date'],
    );
  }
}

class OrderData {
  final String title;
  final String slug;
  final int priority;
  final String icon;
  final Map<String, Order> content;

  OrderData({
    required this.title,
    required this.slug,
    required this.priority,
    required this.icon,
    required this.content,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    Map<String, Order> orders = {};
    json['content'].forEach((orderId, orderJson) {
      Order order = Order.fromJson(orderJson);
      orders[orderId] = order;
    });

    return OrderData(
      title: json['title'],
      slug: json['slug'],
      priority: json['priority'],
      icon: json['icon'],
      content: orders,
    );
  }
}

class MyCourses {

  String? title;
  String? slug;
  int? priority;
  String? icon;
  String? content;

  MyCourses.fromJson(Map<String, dynamic> json) {

    title = json['title'].toString();
    slug = json['slug'].toString();
    priority = int.parse(json['priority'].toString());
    icon = json['icon'].toString();
    content = json['content'].toString();
  }

  MyCourses({this.title, this.slug, this.priority, this.icon, this.content});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['slug'] = slug;
    data['priority'] = priority;
    data['icon'] = icon;
    data['content'] = content;
    return data;
  }
}
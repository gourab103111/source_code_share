import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/models/notification_model.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../helper/router.dart';

class ItemNotification extends StatelessWidget {
  final NotificationModel item;

  ItemNotification({super.key, required this.item});

  void onNavigate() {}
  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          RegExp regExp = RegExp(r'\d+');
          Iterable<RegExpMatch> matches = regExp.allMatches(item.source??"");
          List<String> numbers = matches.map((match) => match.group(0)!).toList();
          if(numbers.isNotEmpty){
            Get.toNamed(AppRouter.getCourseDetailRoute(),arguments: [numbers[0]],preventDuplicates: false);
          }
        },
        child: Container(
            width: screenWidth,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1), // Thay đổi hướng đổ bóng
                ),
              ],
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.image != null &&
                      item.image != '' &&
                      item.image != 'null')
                    Container(
                        width: screenWidth,
                        height: (180 / 375) * screenWidth,
                        margin: EdgeInsetsDirectional.only(bottom: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(item.image!),
                            ))),
                  if (item.title != null && item.title != '')

                    Text(
                      item.title!,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16,fontFamily: "medium"),
                    ),
                  SizedBox(height: 10,),
                  Text(
                    item.content!,
                    style: TextStyle(color: Colors.grey.shade700,fontFamily: "poppins"),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    item.date_created!,
                    style: TextStyle(color: Colors.grey.shade700,fontFamily: "poppins"),
                  ),
                ]))
    );
  }
}

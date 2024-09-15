import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/models/lesson-model.dart';
import 'package:flutter_app/app/view/components/item-lesson.dart';
import 'package:get/get.dart';

import '../../controller/course_detail_controller.dart';
typedef OnNavigateCallback = void Function(dynamic item);
class AccordionLesson extends StatefulWidget {
  final List<LessonModel> data;
  final int indexLesson;
  final OnNavigateCallback onNavigate;
  const AccordionLesson({Key? key, required this.data, required this.indexLesson, required this.onNavigate}) : super(key: key);
  @override
  State<AccordionLesson> createState() => _AccordionState();
}

class _AccordionState extends State<AccordionLesson> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);
  @override
  Widget build(BuildContext context) {
    CourseDetailController value = Get.find();
    return SizedBox(
      width: double.infinity,
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              direction: Axis.vertical,
              children: List.generate(widget.data.length,
                  (index) => AccordionItemLesson(
                    item: widget.data[index],
                      onNavigate: (item) => {
                        value.onNavigateLearning(item,index),
                        _scaffoldKey.currentState?.closeDrawer()
                      },
                    showContent: widget.indexLesson==index,
                  )
              )
          ),
        ],
      ),
    );
  }
}

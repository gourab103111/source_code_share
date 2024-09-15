import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/models/lesson-model.dart';
import 'package:flutter_app/app/view/components/item-lesson-accordion.dart';

import '../../controller/learing_controller.dart';

typedef OnNavigateCallback = void Function(dynamic item);

class AccordionLessonLearning extends StatefulWidget {
  final List<LessonModel> data;

  // final void onNavigate;
  final OnNavigateCallback onNavigate;
  final int index;
  final LearningController controller;
  final ItemLesson itemLesson;

  const AccordionLessonLearning({
    Key? key,
    required this.data,
    required this.onNavigate,
    required this.index,
    required this.itemLesson,
    required this.controller,
  }) : super(key: key);

  @override
  State<AccordionLessonLearning> createState() => _AccordionState();
}

class _AccordionState extends State<AccordionLessonLearning> {
  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth * 0.5,
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              direction: Axis.vertical,
              children: List.generate(
                  widget.data.length,
                  (index) => ItemLessonAccordion(
                        item: widget.data[index],
                        onNavigate: widget.onNavigate,
                        showContent: index == widget.index,
                        lessonIndex: index,
                        itemLesson: widget.itemLesson,
                        controller: widget.controller,
                      ))),
        ],
      ),
    );
  }
}

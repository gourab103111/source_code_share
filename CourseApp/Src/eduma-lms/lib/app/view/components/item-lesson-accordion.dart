import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/init_store.dart';
import 'package:flutter_app/app/backend/models/lesson-model.dart';
import 'package:flutter_app/app/backend/mobx-store/course_store.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../controller/learing_controller.dart';
import '../../helper/function_helper.dart';

typedef OnNavigateCallback = void Function(dynamic item);

class ItemLessonAccordion extends StatefulWidget {
  final LessonModel item;

  final OnNavigateCallback onNavigate;
  final bool showContent;
  final int lessonIndex;
  final ItemLesson itemLesson;
  final LearningController controller;

  const ItemLessonAccordion({
    Key? key,
    required this.item,
    required this.onNavigate,
    required this.showContent,
    required this.itemLesson,
    required this.lessonIndex,
    required this.controller,
  }) : super(key: key);

  @override
  State<ItemLessonAccordion> createState() => _ItemLessonState();
}

class _ItemLessonState extends State<ItemLessonAccordion> {
  final courseStore = locator<CourseStore>();

  // Show or hide the content
  bool _showContent = false;
  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);

  @override
  void initState() {
    _showContent = widget.showContent;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {
              setState(() {
                _showContent = !_showContent;
                //widget.controller.handleCheckCurrentShowLesson(widget.lessonIndex);
              })
            },
        child: Column(children: [
          Container(
            width: screenWidth * 0.7,
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _showContent = !_showContent;
                          });
                        },
                        splashColor: Colors.transparent,
                        // Set the splash color to transparent
                        highlightColor: Colors.transparent,
                        child: Icon(_showContent
                            ? Icons.arrow_drop_up
                            : Icons
                                .arrow_drop_down), // Set the highlight color to transparent
                      ),
                      SizedBox(
                        width: screenWidth * 0.7 - 80,
                        child: Text(
                          widget.item.title!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                Text(
                  widget.item.items!.length.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          _showContent
              ? Container(
                  // padding:
                  //     const EdgeInsets.symmetric(horizontal: 15),
                  child: Wrap(
                      direction: Axis.vertical,
                      children: List.generate(
                        widget.item.items!.length,
                        (i) => Container(
                            child: GestureDetector(
                          onTap: () {
                            widget.onNavigate(widget.item.items![i]);
                          },
                          child: Container(
                            width: screenWidth * 0.7,
                            padding: const EdgeInsets.fromLTRB(14, 4, 10, 4),
                            child: Opacity(
                                opacity: (courseStore.detail?.status ==
                                                'finished' ||
                                            courseStore.detail?.status == '') &&
                                        widget.item.items![i].preview == null
                                    ? 0.5
                                    : 1.0,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(children: [
                                        if (widget.item.items![i].type ==
                                            'lp_lesson')
                                          const Icon(Feather.book,
                                              color: Colors.black, size: 14),
                                        if (widget.item.items![i].type ==
                                            'lp_quiz')
                                          const Icon(Feather.help_circle,
                                              color: Colors.black, size: 14),
                                        if (widget.item.items![i].type ==
                                            'lp_assignment')
                                          const Icon(Feather.file,
                                              color: Colors.black, size: 14),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        SizedBox(
                                            width: screenWidth * 0.7 - 130,
                                            child: Text(
                                                widget.item.items![i].title!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 12,
                                                  fontWeight:
                                                      widget.itemLesson.id ==
                                                              widget.item
                                                                  .items![i].id!
                                                          ? FontWeight.bold
                                                          : FontWeight.w100,
                                                )))
                                      ]),
                                      if (['completed', 'evaluated'].contains(
                                              widget.item.items![i].status) &&
                                          widget.item.items![i].type !=
                                              "lp_quiz")
                                        const Icon(
                                          Icons.check_circle,
                                          size: 16,
                                          color: Colors.green,
                                        ),
                                      // check quizi icon
                                      if (widget.item.items![i].type == "lp_quiz" && widget.item.items![i].graduation != '')
                                        widget.item.items![i].graduation ==
                                                'passed'
                                            ? Icon(
                                                Icons.check_circle,
                                                size: 16,
                                                color: Colors.green,
                                              )
                                            : Icon(Icons.close,
                                                color: Colors.red, size: 16),

                                      if (widget.item.items![i].status !=
                                              'failed' &&
                                          !['completed', 'evaluated'].contains(
                                              widget.item.items![i].status)&& widget.item.items![i].status == '')
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (widget.item.items![i].preview ==
                                                true)
                                              const Icon(Icons.remove_red_eye,
                                                  size: 16,
                                                  color: Colors.green),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            if (widget.item.items![i].locked ==
                                                true)
                                              const Icon(
                                                Icons.lock,
                                                color: Colors.grey,
                                                size: 16,
                                              ),
                                            if ((widget.item.items![i].duration != '' && widget.item.items![i].graduation == ''))
                                              Text(
                                                Helper.handleTranslationsDuration(widget.item.items![i].duration!),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey.shade500
                                                ),
                                              ),
                                          ],
                                        ),
                                    ])),
                          ),
                        )),
                      )),
                )
              : Container()
        ]));
  }
}

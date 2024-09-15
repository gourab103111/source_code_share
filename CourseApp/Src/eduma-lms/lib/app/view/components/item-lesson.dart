import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/models/lesson-model.dart';
import 'package:flutter_app/app/helper/function_helper.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

typedef OnNavigateCallback = void Function(dynamic item);

class AccordionItemLesson extends StatefulWidget {
  final LessonModel item;
  final OnNavigateCallback onNavigate;

  const AccordionItemLesson(
      {Key? key,
      required this.item,
      required this.showContent,
      required this.onNavigate})
      : super(key: key);
  final bool showContent;

  @override
  State<AccordionItemLesson> createState() => _ItemLessonState();
}

class _ItemLessonState extends State<AccordionItemLesson> {
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
              })
            },
        child: Column(children: [
          Container(
            width: screenWidth,
            padding: const EdgeInsets.fromLTRB(0, 8, 24, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _showContent = !_showContent;
                          });
                        },
                        splashColor: Colors
                            .transparent, // Set the splash color to transparent
                        highlightColor: Colors.transparent,
                        child: Icon(_showContent
                            ? Icons.arrow_drop_up
                            : Icons
                                .arrow_drop_down), // Set the highlight color to transparent
                      ),
                      SizedBox(
                        width: screenWidth - 80,
                        child: Text(
                          widget.item.title!,
                          style:
                              TextStyle(fontFamily: 'semibold', fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
                Text(
                  widget.item.items!.length.toString(),
                  style: TextStyle(fontFamily: 'semibold'),
                ),
              ],
            ),
          ),
          _showContent
              ? Container(
                  child: Wrap(
                      direction: Axis.vertical,
                      children: List.generate(
                        widget.item.items!.length,
                        (i) => Container(
                            child: GestureDetector(
                          onTap: () {
                            if (widget.item.items![i].status == "completed" ||
                                widget.item.items![i].locked.toString() ==
                                    'false') {
                              widget.onNavigate(widget.item.items![i]);
                            }
                          },
                          child: Container(
                              width: screenWidth,
                              padding: const EdgeInsets.fromLTRB(16, 4, 24, 4),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(children: [
                                      if (widget.item.items![i].type ==
                                          'lp_lesson')
                                        Icon(Feather.book,
                                            color: Colors.grey.shade800,
                                            size: 18),
                                      if (widget.item.items![i].type ==
                                          'lp_quiz')
                                        Icon(Feather.help_circle,
                                            color: Colors.grey.shade800,
                                            size: 18),
                                      if (widget.item.items![i].type ==
                                          'lp_assignment')
                                        Icon(Feather.file,
                                            color: Colors.grey.shade800,
                                            size: 18),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      ConstrainedBox(
                                        constraints:
                                            BoxConstraints(maxWidth: 250),
                                        child: Text(
                                          widget.item.items![i].title!,
                                          style: TextStyle(
                                            fontFamily: 'poppins',
                                            fontSize: 14,
                                            color: Colors.grey.shade800,
                                            fontWeight: FontWeight.w100,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      )
                                    ]),
                                    //check icon quiz
                                    (widget.item.items![i].type == 'lp_quiz' &&
                                            widget.item.items![i].status != '')
                                        ? ((widget.item.items![i].graduation !=
                                                    '' &&
                                                widget.item.items![i]
                                                        .graduation ==
                                                    'passed')
                                            ? Icon(
                                                Icons.check_circle,
                                                size: 18,
                                                color: Colors.green,
                                              )
                                            : Icon(Icons.close,
                                                color: Colors.red, size: 16))
                                        : Text(''),

                                    if (['completed', 'evaluated'].contains(
                                            widget.item.items![i].status) &&
                                        widget.item.items![i].type != 'lp_quiz')
                                      Icon(
                                        Icons.check_circle,
                                        size: 18,
                                        color: Colors.green,
                                      ),
                                    if (widget.item.items![i].status != 'failed' && !['completed', 'evaluated'].contains(widget.item.items![i].status) && widget.item.items![i].status == '')
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (widget.item.items![i].preview ==
                                              true)
                                            const Icon(Icons.remove_red_eye,
                                                size: 16, color: Colors.green),
                                          if (widget.item.items![i].duration !=
                                              '')
                                            SizedBox(
                                              width: 2,
                                            ),
                                          if (widget.item.items![i].duration !=
                                              '')
                                            Text(
                                            //widget.item.items![i].duration!,
                                              Helper.handleTranslationsDuration(widget.item.items![i].duration!),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey.shade500),
                                            ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          if (widget.item.items![i].locked ==
                                              true)
                                            const Icon(
                                              Icons.lock,
                                              color: Colors.black,
                                              size: 18,
                                            ),
                                        ],
                                      ),
                                  ])),
                        )),
                      )),
                )
              : Container()
        ]));
  }
}

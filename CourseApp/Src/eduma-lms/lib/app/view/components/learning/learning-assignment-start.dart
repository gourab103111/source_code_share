import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/course_store.dart';
import 'package:flutter_app/app/backend/mobx-store/init_store.dart';
import 'package:flutter_app/app/backend/models/learning-lesson-model.dart';
import 'package:flutter_app/app/controller/learing_controller.dart';
import 'package:flutter_app/app/helper/function_helper.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../backend/models/lesson-model.dart';

class LearningAssignmentStart extends StatelessWidget with GetItMixin {
  final LessonsAssignment data;
  final LearningController value;
  final ItemLesson itemLesson;

  LearningAssignmentStart(
      {super.key,
      required this.data,
      required this.value,
      required this.itemLesson});

  final courseStore = locator<CourseStore>();

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    void showReviewQuizModal() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              insetPadding: EdgeInsets.zero,
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Text(
                  tr(LocaleKeys.learningScreen_assignment_timeRemaining),
                  style: TextStyle(fontFamily: "medium", fontSize: 12),
                ),
              ));
        },
      );
    }

    return GetBuilder<LearningController>(builder: (value) {
      return Column(
        children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Text(tr(LocaleKeys.learningScreen_assignment_title),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 22)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                            tr(LocaleKeys
                                .learningScreen_assignment_acceptAllowed),
                            style: const TextStyle(
                                color: Colors.black,
                                fontFamily: "poppins",
                                fontSize: 14)),
                        SizedBox(
                          width: 10,
                        ),
                        Text(data.files_amount.toString())
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Text(tr(LocaleKeys.learningScreen_assignment_durations),
                            style: const TextStyle(
                                color: Colors.black,
                                fontFamily: "poppins",
                                fontSize: 14)),
                        SizedBox(
                          width: 10,
                        ),
                        Text(Helper.handleTranslationsDuration(data.duration!.format.toString()))
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Text(
                            tr(LocaleKeys
                                .learningScreen_assignment_passingGrade),
                            style: const TextStyle(
                                color: Colors.black,
                                fontFamily: "poppins",
                                fontSize: 14)),
                        SizedBox(
                          width: 10,
                        ),
                        Text(tr(LocaleKeys.learningScreen_assignment_point)
                            .replaceAll(
                                '{{point}}', data.passing_grade.toString()))
                      ],
                    ),
                    if (data.introdution.toString() != '')
                      const SizedBox(height: 24),
                    if (data.introdution.toString() != '')
                      Text(tr(LocaleKeys.learningScreen_assignment_overview),
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 22)),
                    if (data.introdution.toString() != '')
                      const SizedBox(height: 14),
                    HtmlWidget(data.introdution.toString()),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              value.onStartAssignment(itemLesson.id.toString());
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow.shade800,
                                padding:
                                    const EdgeInsets.fromLTRB(16, 10, 16, 10)),
                            child: Row(children: [
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                  tr(LocaleKeys
                                      .learningScreen_assignment_start),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: "medium",
                                      fontSize: 14)),
                            ])),
                      ],
                    )
                  ])),
        ],
      );
    });
  }
}

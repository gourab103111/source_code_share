import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/course_store.dart';
import 'package:flutter_app/app/backend/mobx-store/init_store.dart';
import 'package:flutter_app/app/backend/models/learning-lesson-model.dart';
import 'package:flutter_app/app/controller/learing_controller.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../env.dart';

class LearningAssignmentResult extends StatelessWidget with GetItMixin {
  final LessonsAssignment data;

  LearningAssignmentResult({super.key, required this.data});

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
      int countRetake =
          value.dataAssignment.retake_count! - value.dataAssignment.retaken!;
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
                            fontSize: 20)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            tr(LocaleKeys
                                .learningScreen_assignment_attachmentFile),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16)),
                        SizedBox(
                          width: 50,
                        ),
                        (value.dataAssignment.attachment.isEmpty)
                            ? Text(
                                tr(LocaleKeys
                                    .learningScreen_assignment_missingAttachments),
                                style: const TextStyle(color: Colors.black),
                              )
                            : GestureDetector(
                                onTap: () {
                                  _launchUrl(value.dataAssignment.attachment[0]
                                      ['url']);
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.add_link_sharp),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    SizedBox(
                                      width: 160,
                                      child: Text(
                                        value.dataAssignment.attachment[0]
                                            ['name'],
                                        overflow: TextOverflow.fade,
                                      ),
                                    )
                                  ],
                                ),
                              )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(tr(LocaleKeys.learningScreen_assignment_yourAnswer),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 10),
                      child: Text(
                          value.dataAssignment.assignment_answer?.note ?? ""),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            tr(LocaleKeys
                                .learningScreen_assignment_yourUploadedFiles),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16)),
                      ],
                    ),
                    if (value.dataAssignment.assignment_answer?.file != null &&
                        value.dataAssignment.assignment_answer?.file!.length !=
                            0)
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListView.builder(
                                itemCount: value.dataAssignment
                                    .assignment_answer?.file?.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    height: 30,
                                    child: SizedBox(
                                        height: 20,
                                        child: GestureDetector(
                                          onTap: () {
                                            _launchUrl(Environments.apiBaseURL +
                                                value
                                                    .dataAssignment
                                                    .assignment_answer!
                                                    .file?[index]
                                                    .values
                                                    .first['url']);
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.link,
                                                size: 14,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(child: Text(
                                                value
                                                    .dataAssignment
                                                    .assignment_answer!
                                                    .file?[index]
                                                    .values
                                                    .first['filename'],
                                                overflow: TextOverflow.ellipsis,
                                              ))
                                            ],
                                          ),
                                        )),
                                  );
                                })
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              if (countRetake > 0) {
                                value.onRetakeAssignment(
                                    value.dataAssignment.id);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF46647),
                                padding:
                                    const EdgeInsets.fromLTRB(16, 10, 16, 10)),
                            child: Row(children: [
                              SizedBox(
                                width: 4,
                              ),
                              if (countRetake <= 0)
                                Text(
                                    tr(LocaleKeys
                                        .learningScreen_quiz_result_btnRetakeUnlimited),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: "bold",
                                        fontSize: 14)),
                              if (countRetake > 0)
                                Text(
                                    tr(LocaleKeys
                                        .learningScreen_quiz_result_btnRetake),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "bold",
                                        fontSize: 12)),
                              if (countRetake > 0)
                                Text("(" + countRetake.toString() + ")",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "poppins",
                                        fontSize: 12)),
                            ])),
                      ],
                    )
                  ])),
        ],
      );
    });
  }
}

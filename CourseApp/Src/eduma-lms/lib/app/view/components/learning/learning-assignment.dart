import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/course_store.dart';
import 'package:flutter_app/app/backend/mobx-store/init_store.dart';
import 'package:flutter_app/app/controller/learing_controller.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

import '../countdown.dart';
import 'learning-assignment-result.dart';

class _LearningAssignment extends State<LearningAssignment> {
  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  final courseStore = locator<CourseStore>();
  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);
  var screenHeight =
      (window.physicalSize.longestSide / window.devicePixelRatio);

  @override
  void initState() {
    LearningController learningController = Get.find<LearningController>();
    learningController.handleResetFileAssignment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LearningController>(builder: (value) {
      num answerFile = value.dataAssignment.assignment_answer?.file == null
          ? 0
          : value.dataAssignment.assignment_answer?.file!.length as num;
      var countFile = value.dataAssignment.files_amount == null
          ? 0
          : value.dataAssignment.files_amount! - answerFile;
      if (value.dataAssignment.results == null) {
        return Container();
      }
      return !value.dataAssignment.results.isEmpty &&
              value.dataAssignment.results?['status'] == "completed"
          ? LearningAssignmentResult(
              data: value.dataAssignment,
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: SingleChildScrollView(
                  controller: value.scrollController,
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: screenWidth,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.lightBlueAccent.shade100),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Countdown(
                                duration: value.dataAssignment.duration != null
                                    ? value.dataAssignment.duration
                                            ?.time_remaining ??
                                        0
                                    : 0,
                                callBack: () {
                                  value.onSaveOrSendAssignment(
                                      value.dataAssignment.id, 'send');
                                },
                              ),
                              Text(
                                tr(LocaleKeys
                                    .learningScreen_assignment_timeRemaining),
                                style: TextStyle(
                                    fontFamily: "medium", fontSize: 12),
                              )
                            ],
                          )),
                      const SizedBox(
                        height: 30,
                      ),
                      HtmlWidget(value.dataAssignment.content ?? ""),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            tr(LocaleKeys
                                .learningScreen_assignment_attachmentFile),
                            style: TextStyle(fontFamily: "medium"),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          value.dataAssignment.attachment.isEmpty
                              ? Text(
                                  tr(LocaleKeys
                                      .learningScreen_assignment_missingAttachments),
                                  style: const TextStyle(color: Colors.black),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    _launchUrl(
                                        value.dataAssignment.attachment.isEmpty
                                            ? ""
                                            : value.dataAssignment.attachment[0]
                                                ['url']);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.add_link_sharp),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      SizedBox(
                                        width: 190,
                                        child: Text(
                                          value.dataAssignment.attachment
                                                  .isEmpty
                                              ? ""
                                              : value.dataAssignment
                                                  .attachment[0]['name'],
                                          overflow: TextOverflow.clip,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(tr(LocaleKeys.learningScreen_assignment_answer),
                          style: TextStyle(fontFamily: "medium")),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        minLines: 8,
                        keyboardType: TextInputType.multiline,
                        controller: value.answerAssignment,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(gapPadding: 20.0),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Colors.black,
                              width: 0.5,
                              style: BorderStyle.solid),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey),
                              child: Text(
                                tr(LocaleKeys
                                    .learningScreen_assignment_chooseFile),
                                style: const TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                if (countFile > 0) {
                                  if (value.assignmentFiles.length <
                                      int.parse(value
                                          .dataAssignment.files_amount
                                          .toString())) {
                                    value.onUploadFiles();
                                  }
                                }
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            (value.isAssignmentFileUpload)
                                ? Flexible(
                                    flex: 3,
                                    child: Wrap(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          verticalDirection:
                                              VerticalDirection.up,
                                          children: [
                                            Wrap(
                                              direction: Axis.vertical,
                                              children: List.generate(
                                                  value.assignmentFiles.length,
                                                  (i) => TextButton.icon(
                                                      onPressed: () => value
                                                          .onActionDeleteFileAssignmentChoose(
                                                              value.assignmentFiles[
                                                                  i]),
                                                      icon: Icon(
                                                        Icons.close,
                                                        size: 14,
                                                        color: Colors.red,
                                                      ),
                                                      label: Container(
                                                        width: screenWidth*0.5,
                                                        child: Text(
                                                          value.assignmentFiles[i]
                                                              .name,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              fontFamily:
                                                              "medium"),
                                                        ),
                                                      )
                                                  )
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ))
                                : Text(
                                    tr(LocaleKeys
                                        .learningScreen_assignment_nofile),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Sniglet",
                                        fontSize: 14))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        tr(LocaleKeys
                                .learningScreen_assignment_chooseFileDescription)
                            .replaceAll(
                                "{{files_amount}}", countFile.toString())
                            .replaceAll(
                                "{{allow_file_type}}",
                                value.dataAssignment.allow_file_type
                                    .toString()),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Sniglet",
                            fontSize: 11),
                      ),
                      if (value.dataAssignment.assignment_answer?.file != null)
                        Container(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ListView.builder(
                                  itemCount: value.dataAssignment
                                      .assignment_answer?.file?.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      height: 40,
                                      child: SizedBox(
                                        height: 30,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(child: TextButton.icon(
                                                onPressed: () {
                                                  Alert(
                                                    context: context,
                                                    title: tr(LocaleKeys
                                                        .learningScreen_assignment_deleteFileTitle),
                                                    desc: tr(LocaleKeys
                                                        .learningScreen_assignment_deleteFileMessage),
                                                    buttons: [
                                                      DialogButton(
                                                        child: Text(
                                                          tr(LocaleKeys
                                                              .learningScreen_assignment_cancel),
                                                          style:
                                                          const TextStyle(
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                        onPressed: () => {
                                                          Navigator.pop(context)
                                                        },
                                                      ),
                                                      DialogButton(
                                                        child: Text(
                                                          tr(LocaleKeys
                                                              .learningScreen_assignment_ok),
                                                          style:
                                                          const TextStyle(
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                        onPressed: () => {
                                                          Navigator.pop(
                                                              context),
                                                          value.onDeleteFileAssignment(
                                                              value
                                                                  .dataAssignment
                                                                  .id,
                                                              value
                                                                  .dataAssignment
                                                                  .assignment_answer!
                                                                  .file?[index]
                                                                  .keys
                                                                  .first
                                                                  .toString())
                                                        },
                                                      ),
                                                    ],
                                                  ).show();
                                                },
                                                icon: const Icon(
                                                  Icons.restore_from_trash,
                                                  size: 16,
                                                  color: Colors.red,
                                                ),
                                                label: Text(
                                                  value
                                                      .dataAssignment
                                                      .assignment_answer!
                                                      .file?[index]
                                                      .values
                                                      .first['filename'],
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: "medium"),
                                                )
                                            ))
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                            ],
                          ),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () => value.onSaveOrSendAssignment(
                                value.dataAssignment.id, "save"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding:
                                    const EdgeInsets.fromLTRB(20, 16, 20, 16)),
                            child: Text(
                              tr(LocaleKeys.learningScreen_assignment_save),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Sniglet",
                                  fontSize: 12),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => value.onSaveOrSendAssignment(
                                value.dataAssignment.id, "send"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding:
                                    const EdgeInsets.fromLTRB(20, 16, 20, 16)),
                            child: Text(
                              tr(LocaleKeys.learningScreen_assignment_send),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Sniglet",
                                  fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                    ],
                  )),
            );
    });
  }
}

class LearningAssignment extends StatefulWidget {
  final int? id;

  const LearningAssignment({super.key, required this.id});

  @override
  State<LearningAssignment> createState() => _LearningAssignment();
}

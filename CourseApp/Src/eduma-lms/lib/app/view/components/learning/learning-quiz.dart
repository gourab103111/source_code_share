import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/course_store.dart';
import 'package:flutter_app/app/backend/mobx-store/init_store.dart';
import 'package:flutter_app/app/backend/models/learning-lesson-model.dart';
import 'package:flutter_app/app/controller/learing_controller.dart';
import 'package:flutter_app/app/helper/function_helper.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class LearningQuiz extends StatelessWidget with GetItMixin {
  final LearningLessonModel data;
  final QuizModel dataQuiz;

  LearningQuiz({super.key, required this.data, required this.dataQuiz});

  final courseStore = locator<CourseStore>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LearningController>(builder: (value) {
      return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 22,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      Helper.handleTranslationsDuration(data.duration.toString()) ?? "",
                      style: TextStyle(color: Colors.red[500]),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  data.name ?? '',
                  style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(tr(
                      LocaleKeys.learningScreen_quiz_questionCount,
                    )),
                    Text(
                      data.questions != null && data.questions != null
                          ? data.questions!.length.toString()
                          : "0",
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(tr(
                      LocaleKeys.learningScreen_quiz_passingGrade,
                    )),
                    Text(
                      data.meta_data?.lp_passing_grade != null &&
                              data.meta_data?.lp_passing_grade != 0
                          ? "${data.meta_data!.lp_passing_grade}%"
                          : "0%",
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16),
                child: HtmlWidget(
                  data.content.toString(),
                  textStyle: TextStyle(
                    // padding: const EdgeInsets.symmetric(horizontal: 8),
                    fontFamily: 'Poppins-ExtraLight',
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                    0xFF36CE61,
                  )),
                  onPressed: value.onStartQuiz,
                  child: Text(
                    tr(
                      LocaleKeys.learningScreen_quiz_btnStart,
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ));
    });
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/course_store.dart';
import 'package:flutter_app/app/backend/mobx-store/init_store.dart';
import 'package:flutter_app/app/backend/models/learning-lesson-model.dart';
import 'package:flutter_app/app/controller/learing_controller.dart';
import 'package:flutter_app/app/helper/function_helper.dart';
import 'package:flutter_app/app/view/components/learning/review-quiz.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class LearningResult extends StatelessWidget with GetItMixin {
  final LearningLessonModel data;
  LearningResult({super.key, required this.data});
  final courseStore = locator<CourseStore>();

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
                child: ReviewQuiz(
                    data: data, onClose: () => Navigator.pop(context))),
          );
        },
      );
    }

    return GetBuilder<LearningController>(builder: (value) {
      String  result = data.results?.results?["result"].round().toString()??"";
      String  passingGrade = data.results?.results?["passing_grade"].toString()??"";

      return Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  // flex: 1,
                  child: Container(
                    child: CircularPercentIndicator(
                      radius: 70,
                      percent: (data.results?.results["result"].round() / 100),
                      lineWidth: 10,
                      backgroundColor: Colors.grey.shade100,
                      progressColor:
                          data.results?.results["graduation"] == 'failed'
                              ? const Color(0xFFF46647)
                              : const Color(0xFF58C3FF),
                      center: Text(
                        "${data.results?.results["result"]!.round()}%",
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  // flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr(LocaleKeys.learningScreen_quiz_result_title),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        Helper.handleTranslationsGraduationText(data.results?.results["graduationText"] ?? ""),
                        style: (data.results?.results["graduation"] != 'failed')
                            ? const TextStyle(color: Colors.blue, fontSize: 20,fontFamily: 'semibold')
                            : const TextStyle(color: Colors.red, fontSize: 25,fontFamily: 'semibold'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(children: [
                if (data.results?.results["graduation"] == 'failed')
                  Text(
                    tr(LocaleKeys.reviewQuiz_graduation,args: [result,passingGrade]),
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        tr(LocaleKeys.learningScreen_quiz_result_questions),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16)),
                    Text((data.results?.results['question_count']).toString() ??
                        '',style: TextStyle(fontFamily: 'semibold')),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        tr(LocaleKeys.learningScreen_quiz_result_correct),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16)),
                    Text((data.results?.results['question_correct'])
                            .toString() ??
                        '',style: TextStyle(fontFamily: 'semibold')),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        tr(LocaleKeys.learningScreen_quiz_result_wrong),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16)),
                    Text((data.results?.results['question_wrong']).toString() ?? '',style: TextStyle(fontFamily: 'semibold'),),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        tr(LocaleKeys.learningScreen_quiz_result_skipped),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16)),
                    Text((data.results?.results['question_empty']).toString() ??
                        '',style: TextStyle(fontFamily: 'semibold')),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        tr(LocaleKeys.learningScreen_quiz_result_points),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16)),
                    Text((data.results?.results['user_mark']).toString() ?? '',style: TextStyle(fontFamily: 'semibold')),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        tr(LocaleKeys.learningScreen_quiz_result_timespent),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16)),
                    Text(
                        (data.results?.results['time_spend']).toString() ?? '',style: TextStyle(fontFamily: 'semibold')),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if ((data.results?.retake_count == -1 ||
                        (data.results?.retake_count != null &&
                            data.results?.retaken != null &&
                            (data.results!.retake_count! -
                                    data.results!.retaken! >
                                0))))
                      ElevatedButton(
                          onPressed: () => {value.onStartQuiz()},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF46647),
                              padding:
                                  const EdgeInsets.fromLTRB(40, 16, 40, 16)),
                          child: Row(children: [
                            Text(
                                tr(LocaleKeys.learningScreen_quiz_result_btnRetake),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Sniglet",
                                    fontSize: 12)),
                            SizedBox(
                              width: 4,
                            ),
                            if (data.results!.retake_count!.toString() == "-1")
                              Text(
                                  tr(LocaleKeys.learningScreen_quiz_result_btnRetakeUnlimited),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Sniglet",
                                      fontSize: 12)),
                            if (data.results!.retake_count!.toString() != "-1")
                              Text(
                                  "(" +
                                      (data.results!.retake_count! -
                                              data.results!.retaken!)
                                          .toString() +
                                      ")",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Sniglet",
                                      fontSize: 12)),
                          ])),
                    ElevatedButton(
                      onPressed: showReviewQuizModal,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFBC815),
                          padding: const EdgeInsets.fromLTRB(40, 16, 40, 16)),
                      child: Text(
                        tr(LocaleKeys.learningScreen_quiz_result_btnReview),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Sniglet",
                            fontSize: 12),
                      ),
                    )
                  ],
                )
              ])),
        ],
      );
    });
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/course_store.dart';
import 'package:flutter_app/app/backend/mobx-store/init_store.dart';
import 'package:flutter_app/app/backend/models/learning-lesson-model.dart';
import 'package:flutter_app/app/controller/learing_controller.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_just_audio/fwfh_just_audio.dart';
import 'package:fwfh_webview/fwfh_webview.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class LearningLesson extends StatelessWidget with GetItMixin {
  final LearningLessonModel data;

  LearningLesson({super.key, required this.data});

  final courseStore = locator<CourseStore>();

  get webView => true;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LearningController>(builder: (value) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (data.name != null)
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 32),
              child: Text(
                data.name!,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'medium',
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              )),
        if (data.video_intro != null)
          Container(
              // padding: EdgeInsets.only(left: 10),
              child: HtmlWidget( data.video_intro.toString(),textStyle: TextStyle(
                    fontFamily: 'Poppins-ExtraLight',
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
              ),
      )),
        if (data.content != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: HtmlWidget(
              data.content.toString(),
              factoryBuilder: () => MyWidgetFactory(),
              textStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (value.courseModel.course_data?.status == 'enrolled')
              if (value.courseModel.sections != null &&
                  value.courseModel.sections!.isNotEmpty &&
                  value.lesson?.status != 'completed')
                Container(
                  margin: const EdgeInsets.fromLTRB(16,16,0,0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green[600],
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12), // foreground color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => {value.onCompleteLesson()},
                    child: Text(tr(LocaleKeys.learningScreen_lesson_btnComplete)),
                  ),
                ),
            if (data.can_finish_course == true)
              Container(
                margin: const EdgeInsets.fromLTRB(16,16,16,0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12), // foreground color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => {value.onFinishCourse()},
                  child: Text(tr(LocaleKeys.learningScreen_finishCourse)),
                ),
              ),
          ],
        )
      ]);
    });
  }
}

class MyWidgetFactory extends WidgetFactory with WebViewFactory,JustAudioFactory {
  @override
  bool get webViewMediaPlaybackAlwaysAllow => true;
}

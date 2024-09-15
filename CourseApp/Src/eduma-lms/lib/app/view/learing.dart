import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/course_store.dart';
import 'package:flutter_app/app/backend/mobx-store/init_store.dart';
import 'package:flutter_app/app/controller/course_detail_controller.dart';
import 'package:flutter_app/app/controller/learing_controller.dart';
import 'package:flutter_app/app/view/components/accordion-lesson-learning.dart';
import 'package:flutter_app/app/view/components/learning/learning-assignment.dart';
import 'package:flutter_app/app/view/components/learning/learning-lesson.dart';
import 'package:flutter_app/app/view/components/learning/learning-quiz.dart';
import 'package:flutter_app/app/view/components/learning/learning-result.dart';
import 'package:flutter_app/app/view/components/learning/learning-start-quiz.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/get.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:indexed/indexed.dart';

import '../backend/models/lesson-model.dart';
import 'components/learning/learning-assignment-start.dart';

class LearningScreen extends StatefulWidget with GetItStatefulWidgetMixin {
  LearningScreen({Key? key}) : super(key: key);

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final courseStore = locator<CourseStore>();
  int indexSection = 0;
  final CourseDetailController courseDetailController = Get.find();
  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);
  var screenHeight =
      (window.physicalSize.longestSide / window.devicePixelRatio);

  @override
  void initState() {
    super.initState();
  }

  handleGetIndexLesson() {
    ItemLesson? itemRedirect = ItemLesson();
    int i = 0;
    for (var item in courseStore.detail!.sections!) {
      itemRedirect = item.items?.firstWhere(
        (x) => x.status != 'completed',
        orElse: () => ItemLesson(),
      );
      if (itemRedirect?.id != null) {
        break;
      }
      i++;
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LearningController>(builder: (value) {
      bool isStatusResultAssignmentEmpty =
          value.dataAssignment.results is List &&
              value.dataAssignment.results.isEmpty;
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawerEnableOpenDragGesture: false,
        drawer: Drawer(
          child: Container(
            padding: EdgeInsets.fromLTRB(
                16, MediaQuery.of(context).viewPadding.top, 0, 0),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Colors.amber,
                  width: 4.0,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        courseStore.detail!.name!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'medium',
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.13,
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                        ),
                      ),
                      child: SizedBox(
                        width: 200,
                        child: IconButton(
                          onPressed: () {
                            _scaffoldKey.currentState?.closeDrawer();
                          },
                          icon: const Icon(
                            Icons.close,
                            size: 24,
                            weight: 100,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                  child: Divider(
                    thickness: 1,
                    endIndent: 20,
                    color: Color(0xFF9E9E9ECB),
                  ),
                ),
                value.courseModel.sections != null
                    ? Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top: 10),
                          width: screenWidth,
                          child: AccordionLessonLearning(
                            data: value.courseModel.sections!,
                            index: value.isCheckCurrentShowLesson
                                ? value.indexCurrentShowLesson
                                : value.indexLesson ?? handleGetIndexLesson(),
                            itemLesson: value.lesson!,
                            controller: value,
                            onNavigate: (item) => {
                              value.onNavigateLearning(item),
                              _scaffoldKey.currentState?.closeDrawer(),
                            },
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Indexed(
              index: 1,
              child: Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: (276 / 375) * screenWidth,
                  height: (209 / 375) * screenWidth,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          'assets/images/banner-my-course.png',
                        ),
                        fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
            Column(children: <Widget>[
              Container(
                height: 80.0,
                width: screenWidth,
                // color: Colors.blue,
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      // width: 40,
                      child: IconButton(
                        onPressed: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        icon: const Icon(Icons.menu),
                        color: Colors.grey[900],
                        iconSize: 30,
                      ),
                    ),
                    Container(
                      // width: 40,
                      child: IconButton(
                        onPressed: () {
                          courseDetailController.refreshData();
                          Get.back();
                        },
                        icon: const Icon(Icons.close),
                        color: Colors.grey[900],
                        iconSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: RefreshIndicator(
                      onRefresh: () => value.refreshData(),
                      child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 100),
                          scrollDirection: Axis.vertical,
                          child: Container(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                if (value.isLesson)
                                  LearningLesson(
                                    data: value.data,
                                  ),
                                if (value.isQuiz &&
                                    !value.isStartQuiz &&
                                    value.data.results?.status == '')
                                  LearningQuiz(
                                      data: value.data,
                                      dataQuiz: value.dataQuiz),
                                if (value.isAssignment &&
                                    !isStatusResultAssignmentEmpty)
                                  LearningAssignment(id: value.id),
                                if (value.isAssignment &&
                                    isStatusResultAssignmentEmpty)
                                  LearningAssignmentStart(
                                    data: value.dataAssignment,
                                    value: value,
                                    itemLesson: value.lesson ?? ItemLesson(),
                                  ),
                                if (value.isStartQuiz && value.isQuiz)
                                  LearningStartQuiz(
                                    data: value.data,
                                    dataQuiz: value.dataQuiz,
                                    itemQuestion: value.itemQuestion,
                                  ),
                                if (value.isQuiz &&
                                    !value.isStartQuiz &&
                                    value.data.results?.status != '')
                                  LearningResult(data: value.data),
                                if (value.data.can_finish_course == true &&
                                    value.isQuiz)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    color: Colors.white,
                                    margin: const EdgeInsets.only(top: 30),
                                    child: GestureDetector(
                                      onTap: value.onFinishCourse,
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF222222),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 21),
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: Text(
                                          tr(LocaleKeys.learningScreen_finishCourse,
                                          ),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ]))))),
            ]),
          ],
        ),
      );
    });
  }
}

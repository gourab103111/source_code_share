import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/course_store.dart';
import 'package:flutter_app/app/backend/mobx-store/init_store.dart';
import 'package:flutter_app/app/backend/mobx-store/learing_quiz_store.dart';
import 'package:flutter_app/app/backend/parse/course_detail_parse.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/get.dart';
import 'package:flutter_app/app/backend/models/learning-lesson-model.dart';
import 'package:flutter_app/app/backend/models/lesson-model.dart';
import 'package:flutter_app/app/backend/parse/learning_parse.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../backend/models/course_model.dart';
import '../helper/dialog_helper.dart';
import '../helper/router.dart';

class LearningController extends GetxController {
  final LearningParser parser;
  final CourseDetailParser courseDetailParser;

  LearningController({required this.parser, required this.courseDetailParser});

  String courseId = "";
  ItemLesson? lesson;
  int? index;
  int? indexLesson;
  int indexCurrentShowLesson = -1;
  bool isCheckCurrentShowLesson = false;
  LearningLessonModel _data = LearningLessonModel();
  final ScrollController scrollController = ScrollController();

  LearningLessonModel get data => _data;
  LessonsAssignment _dataAssignment = LessonsAssignment();
  Map<String, AnswerDataCheck> _answerDataCheck = {};

  Map<String, AnswerDataCheck> get listAnswerDataCheck => _answerDataCheck;

  LessonsAssignment get dataAssignment => _dataAssignment;
  bool isLesson = false;
  bool isQuiz = false;
  bool isStartQuiz = false;
  bool isAssignment = false;
  bool isAssignmentFileUpload = false;
  bool isShowMenu = true;
  List<PlatformFile> assignmentFiles = [];
  bool isLoadingMore = true;
  List<dynamic> listAnswer = [];

  QuizModel _dataQuiz = QuizModel();

  QuizModel get dataQuiz => _dataQuiz;
  QuestionModel? itemQuestion;
  int? pageActive = 0;
  int? id;
  int? sectionId;
  dynamic itemCheck = [];
  final courseStore = locator<CourseStore>();
  final learingQuizStore = locator<LearingQuizStore>();
  CourseModel _courseModel = CourseModel();

  CourseModel get courseModel => _courseModel;
  var context = Get.context as BuildContext;
  TextEditingController answerAssignment = TextEditingController();
  Map<String, TextEditingController> listTextFieldQuiz = {};

  @override
  void onInit() {
    lesson = Get.arguments[0];
    index = Get.arguments[1];
    sectionId = Get.arguments[3];
    courseId = Get.arguments[2].toString();
    getCourseDetail();
    getLesson();
    super.onInit();
    scrollController.addListener(_onScroll);
  }

  handleResetFileAssignment() {
    isAssignmentFileUpload = false;
    assignmentFiles = [];
  }

  handleOnInitAnswered() async {
    final response = await parser.getQuiz(lesson!.id.toString());
    Map<String, AnswerDataCheck> data = {};
    if (response.statusCode == 200) {
      LearningLessonModel lessonModel =
          LearningLessonModel.fromJson(response.body);
      if (lessonModel.results?.answered.isNotEmpty) {
        lessonModel.results?.answered.forEach((questionId, value) {
          if (value['answered'] != '') {
            var question = lessonModel.questions?.firstWhereOrNull(
                (element) => element.id.toString() == questionId.toString());
            data[questionId.toString()] = AnswerDataCheck(
                question?.explanation,
                '',
                AnswerDataResult(value['answered'], value['correct'],
                    value['mark'].toString()),
                question?.options);
          }
        });
        _answerDataCheck = data;
        refresh();
        update();
      }
    }
  }

  getIndexLesion() {
    ItemLesson? itemRedirect = ItemLesson();
    int i = 0;
    for (var item in courseModel.sections!) {
      itemRedirect = item.items?.firstWhere(
        (x) => x.status != 'completed',
        orElse: () => ItemLesson(),
      );
      if (itemRedirect?.id != null) {
        if (item.items?.last.id == itemRedirect?.id) {
          i++;
        }
        break;
      }
      i++;
    }
    return i;
  }

  getCourseDetail() async {
    final response = await courseDetailParser.getDetailCourse(courseId);
    if (response.statusCode == 200) {
      _courseModel = CourseModel.fromJson(response.body);
      courseStore.setDetail(_courseModel);
      update();
      refresh();
    }
  }

  Future<void> refreshData() async {
    getCourseDetail();
    getLesson();
  }

  Future<void> callBackFinishQuiz() async {
    onFinish();
  }

  Future<void> onFinish() async {
    final itemTemp = <String, dynamic>{};
    learingQuizStore.dataQuiz?.questions?.forEach((question) {
      if (itemCheck.length != 0 &&
          itemCheck.firstWhere(
                (y) => y.id == question.id,
                orElse: () => null,
              ) ==
              null) return;
      if (question.type == 'sorting_choice') {
        itemTemp[question.id.toString()] =
            question.options?.map((item) => item.value).toList();
      } else if (question.answer != null) {
        if (question.type == 'true_or_false') {
          itemTemp[question.id.toString()] = question.answer[0].value;
        } else if (question.type == 'fill_in_blanks') {
          itemTemp[question.id.toString()] = question.answer;
        } else if (question.type == 'multi_choice') {
          itemTemp[question.id.toString()] =
              question.answer.map((item) => item.value).toList();
        } else {
          itemTemp[question.id.toString()] =
              question.answer.map((item) => item.value).toList();
        }
      }
    });
    final response = await parser.finishQuiz(lesson!.id.toString(), itemTemp);
    if (response.body["status"] == "success") {
      reloadFinish();
    } else {
      var context = Get.context as BuildContext;
      Alert(context: context, title: "Error", desc: response.body["message"])
          .show();
    }
  }

  Future<void> reloadFinish() async {
    isShowMenu = false;
    pageActive = 0;
    _data = LearningLessonModel();
    final response = await parser.getQuiz(lesson!.id.toString());

    if (response.statusCode == 200) {
      LearningLessonModel temp = LearningLessonModel.fromJson(response.body);
      _data = temp;
      isQuiz = true;
      isStartQuiz = false;
      _dataQuiz = QuizModel(
          questions: temp.questions,
          status: temp.results?.status,
          passing_grade: temp.results?.passing_grade,
          negative_marking: temp.results?.negative_marking,
          instant_check: temp.results?.instant_check,
          retake_count: temp.results?.retake_count,
          questions_per_page: temp.results?.questions_per_page,
          page_numbers: temp.results?.page_numbers,
          review_questions: temp.results?.review_questions,
          support_options: temp.results?.support_options,
          duration: temp.results?.duration,
          results: temp.results);
      learingQuizStore.setData(_dataQuiz);
      refresh();
      update();
    }
  }

  Future<void> onStartQuiz() async {
    final responseStart = await parser.quizStart(id!);
    final response = await parser.getQuiz(id.toString());
    var context = Get.context as BuildContext;
    if (response.statusCode == 200) {
      if (responseStart.body["status"] == "success") {
        listAnswer = [];
        isStartQuiz = true;
        LearningLessonModel temp = LearningLessonModel.fromJson(response.body);
        _dataQuiz = QuizModel(
            questions: temp.questions,
            status: temp.results?.status,
            passing_grade: temp.results?.passing_grade,
            negative_marking: temp.results?.negative_marking,
            instant_check: temp.results?.instant_check,
            retake_count: temp.results?.retake_count,
            questions_per_page: temp.results?.questions_per_page,
            page_numbers: temp.results?.page_numbers,
            review_questions: temp.results?.review_questions,
            support_options: temp.results?.support_options,
            duration: temp.results?.duration,
            total_time: temp.results?.total_time,
            results: temp.results);
        learingQuizStore.setData(_dataQuiz);
        if (temp.questions != null) {
          itemQuestion = temp.questions![0];
          learingQuizStore.setQuestion(itemQuestion);
          refresh();
          update();
        }
      } else {
        Alert(context: context, title: "Error", desc: response.body["message"])
            .show();
      }
    } else {
      Alert(context: context, title: "Error", desc: response.body["message"])
          .show();
    }
  }

  List<LessonModel> dataLesson() {
    List<LessonModel> dataTemp = [];
    _courseModel.sections?.forEach((obj) => dataTemp.add(obj));
    return dataTemp;
  }

  void onNavigateLearning(value) {
    lesson = value;
    List<LessonModel> dataTemp = dataLesson();
    if (dataTemp.isEmpty) return;
    index = dataTemp.indexWhere((x) => x.id == sectionId);
    getLesson();
  }

  Future<void> getLesson() async {
    if (lesson?.type == 'lp_lesson') {
      final response = await parser.getLesson(lesson!.id.toString());
      if (response.statusCode == 200) {
        LearningLessonModel temp = LearningLessonModel.fromJson(response.body);
        _data = temp;
        isLesson = true;
        isQuiz = false;
        isAssignment = false;
      }
    }
    if (lesson?.type == 'lp_quiz') {
      final response = await parser.getQuiz(lesson!.id.toString());

      if (response.statusCode == 200) {
        // print(response.body);
        LearningLessonModel temp = LearningLessonModel.fromJson(response.body);
        _data = temp;

        isLesson = false;
        isQuiz = true;
        isAssignment = false;
        isStartQuiz = temp.results?.status == "started" ? true : false;
        // isStartQuiz = true;
        pageActive = 0;
        if (temp.results != null) {
          _dataQuiz = QuizModel(
            questions: temp.questions,
            status: temp.results?.status,
            passing_grade: temp.results?.passing_grade,
            negative_marking: temp.results?.negative_marking,
            instant_check: temp.results?.instant_check,
            retake_count: temp.results?.retake_count,
            questions_per_page: temp.results?.questions_per_page,
            page_numbers: temp.results?.page_numbers,
            review_questions: temp.results?.review_questions,
            support_options: temp.results?.support_options,
            duration: temp.results?.duration,
            total_time: temp.results?.total_time,
          );
          learingQuizStore.setData(_dataQuiz);
          if (temp.questions != null && temp.questions?.length != 0) {
            itemQuestion = temp.questions![0];
            learingQuizStore.setQuestion(itemQuestion);
          }
        }
      }
    }
    if (lesson?.type == 'lp_assignment') {
      isAssignment = true;
      isLesson = false;
      isQuiz = false;
      final response = await parser.getAssignment(lesson!.id.toString());
      if (response.statusCode == 200) {
        // print(response.body);
        LessonsAssignment temp = LessonsAssignment.fromJson(response.body);
        _dataAssignment = temp;
        answerAssignment.text = _dataAssignment.assignment_answer?.note ?? "";
      }
    }
    //current lesson id
    id = lesson?.id;
    update();
    refresh();
  }

  Future<void> onNext() async {
    List<LessonModel> dataTemp = dataLesson();
    getCourseDetail();
    if (dataTemp.isEmpty) return;
    int index = dataTemp.indexWhere((x) => x.id == sectionId);

    ItemLesson? itemRedirect = ItemLesson();
    int i = 0;
    for (var item in courseModel.sections!) {
      itemRedirect = item.items?.firstWhere(
        (x) => x.status != 'completed',
        orElse: () => ItemLesson(),
      );
      sectionId = item.id!;
      if (itemRedirect?.id != null) {
        break;
      }
      i++;
    }
    indexLesson = i;
    onNavigateLearning(itemRedirect);
  }

  Future<void> onActiveQuiz(item, index) async {
    learingQuizStore.setQuestion(item);
    pageActive = index;
    update();
  }

  Future<void> onPrevQuiz() async {
    learingQuizStore.setQuestion(dataQuiz.questions![pageActive! - 1]);
    pageActive = pageActive! - 1;
    update();
  }

  Future<void> onNextQuiz() async {
    var context = Get.context as BuildContext;
    if (dataQuiz.questions?.length == pageActive! + 1) {
      Alert(
              context: context,
              title: "",
              desc: tr(LocaleKeys.learningScreen_quiz_nextQuestion))
          .show();
      return;
    }
    learingQuizStore.setQuestion(dataQuiz.questions![pageActive! + 1]);
    pageActive = pageActive! + 1;
    update();
  }

  Future<void> onCompleteLesson() async {
    var context = Get.context as BuildContext;
    DialogHelper.showLoading();
    final response = await parser.completeLesson(id.toString());

    Future.delayed(const Duration(seconds: 1), () {
      getCourseDetail();
      if (response.statusCode == 200 && response.body["status"] == 'success') {
        DialogHelper.hideLoading();
        Alert(
          context: context,
          desc: tr(LocaleKeys.learningScreen_lesson_notificationLessonSuccess),
          buttons: [
            DialogButton(
              child: Text(
                tr(LocaleKeys.learningScreen_lesson_alert_ok),
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () => {Navigator.pop(context), onNext()},
            )
          ],
        ).show();
      } else {
        DialogHelper.hideLoading();
        Alert(
          context: context,
          desc: response.body["message"],
          buttons: [
            DialogButton(
              child: Text(
                tr(LocaleKeys.learningScreen_lesson_alert_ok),
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () => {Navigator.pop(context), onNext()},
            )
          ],
        ).show();
      }
    });
  }

  Future<void> onFinishCourse() async {
    var context = Get.context as BuildContext;
    Alert(
      context: context,
      title: tr(LocaleKeys.learningScreen_finishCourseAlert_title),
      desc: tr(LocaleKeys.learningScreen_finishCourseAlert_description),
      buttons: [
        DialogButton(
          color: Colors.red,
          child: Text(
            tr(LocaleKeys.learningScreen_finishCourseAlert_cancel),
            style: const TextStyle(color: Colors.white),
          ),
          onPressed: () => {Navigator.pop(context)},
        ),
        DialogButton(
          child: Text(
            tr(LocaleKeys.learningScreen_finishCourseAlert_ok),
            style: const TextStyle(color: Colors.white),
          ),
          onPressed: () => {Navigator.pop(context), onFinishAPI()},
        ),
      ],
    ).show();
  }

  Future<void> onFinishAPI() async {
    final response = await parser.finish(courseId.toString());
    if (response.statusCode == 200) {
      Get.toNamed(AppRouter.getCourseDetailRoute(),
          arguments: [courseId, "reloadPage"], preventDuplicates: false);
    }
  }

  Future<void> selectQuestion(item) async {
    try {
      if (learingQuizStore.itemQuestion?.type == 'single_choice') {
        learingQuizStore.itemQuestion?.answer = [item];
      }
      if (learingQuizStore.itemQuestion?.type == 'true_or_false') {
        learingQuizStore.itemQuestion?.answer = [item];
      }
      if (learingQuizStore.itemQuestion?.type == 'multi_choice') {
        if (learingQuizStore.itemQuestion?.answer != null &&
            learingQuizStore.itemQuestion?.answer.isNotEmpty) {
          dynamic temp = learingQuizStore.itemQuestion?.answer?.firstWhere(
            (x) => x.value == item.value,
            orElse: () => null,
          );
          if (temp != null) {
            learingQuizStore.itemQuestion?.answer = learingQuizStore
                .itemQuestion?.answer
                .where((x) => x.value != item.value);
          } else {
            learingQuizStore.itemQuestion?.answer = [
              ...learingQuizStore.itemQuestion?.answer,
              item
            ];
          }
        } else {
          learingQuizStore.itemQuestion?.answer = [item];
        }
      }

      if (learingQuizStore.itemQuestion?.type != 'sorting_choice') {
        var index = listAnswer.indexWhere((x) =>
            x['id'].toString() == learingQuizStore.itemQuestion?.id.toString());

        if (index != -1 &&
            learingQuizStore.itemQuestion?.type == 'multi_choice') {
          List<dynamic> currentDataAnswered =
              json.decode(listAnswer[index]["answered"]);
          if (currentDataAnswered.contains(item.value.toString())) {
            currentDataAnswered.remove(item.value.toString());
          } else {
            currentDataAnswered.add(item.value.toString());
          }
          listAnswer[index] = {
            "id": learingQuizStore.itemQuestion?.id,
            "answered": json.encode(currentDataAnswered)
          };
        } else if (index != -1 &&
            learingQuizStore.itemQuestion?.type == 'single_choice') {
          listAnswer[index] = {
            "id": learingQuizStore.itemQuestion?.id,
            "answered": item.value.toString()
          };
        } else {
          List data = [];
          if (learingQuizStore.itemQuestion?.type == 'multi_choice') {
            data.add(item.value);
          }
          listAnswer.add({
            "id": learingQuizStore.itemQuestion?.id,
            "answered": learingQuizStore.itemQuestion?.type == 'multi_choice'
                ? json.encode(data)
                : item.value
          });
        }
      }
      refresh();
      update();
    } catch (e) {
      print(e);
    }
  }

  Future<void> onChangeFillBlank(id, value) async {
    if (learingQuizStore.itemQuestion?.answer != null) {
      if (learingQuizStore.itemQuestion?.answer[id] == value) {
        learingQuizStore.itemQuestion?.answer[id] = value;
      } else {
        learingQuizStore.itemQuestion?.answer[id] = value;
      }
    } else {
      learingQuizStore.itemQuestion?.answer = {};
      learingQuizStore.itemQuestion?.answer[id] = value;
    }
    //check index question exits
    var index = listAnswer.indexWhere((x) =>
        x['id'].toString() == learingQuizStore.itemQuestion?.id.toString());

    if (index != -1) {
      listAnswer[index]['answered'][id] = value;
    } else {
      var mapValue = {};
      mapValue[id] = value;
      listAnswer
          .add({"id": learingQuizStore.itemQuestion?.id, "answered": mapValue});
    }
  }

  handleRenderFieldControl(id) {
    if (learingQuizStore.itemQuestion?.answer != null &&
        listTextFieldQuiz.isNotEmpty) {
      var textController = listTextFieldQuiz[id];
      if (learingQuizStore.itemQuestion?.answer[id] != null) {
        textController?.text = learingQuizStore.itemQuestion?.answer[id];
      }
      return textController;
    } else {
      var textController = TextEditingController();
      listTextFieldQuiz[id] = textController;
    }
  }

  Future<void> onCheck() async {
    var context = Get.context as BuildContext;
    if (learingQuizStore.itemQuestion?.answer == null &&
        learingQuizStore.itemQuestion?.type != 'sorting_choice') {
      Alert(
              context: context,
              title: "",
              desc: tr(LocaleKeys.learningScreen_quiz_checkAlert))
          .show();
      return;
    }
    var itemTemp = {};
    if (learingQuizStore.itemQuestion?.type == 'sorting_choice') {
      itemTemp['value'] =
          learingQuizStore.itemQuestion?.options?.map((y) => y.value).toList();
    } else if (learingQuizStore.itemQuestion?.answer != null) {
      if (learingQuizStore.itemQuestion?.type == 'true_or_false') {
        itemTemp['value'] = learingQuizStore.itemQuestion?.answer.value;
      } else if (learingQuizStore.itemQuestion?.type == 'fill_in_blanks') {
        itemTemp['value'] = learingQuizStore.itemQuestion?.answer;
      } else if (learingQuizStore.itemQuestion?.type == 'multi_choice') {
        itemTemp['value'] =
            learingQuizStore.itemQuestion?.answer.map((y) => y.value).toList();
      } else {
        itemTemp['value'] =
            learingQuizStore.itemQuestion?.answer.map((y) => y.value).toList();
      }
    }
    var param = {
      'id': lesson?.id,
      'question_id': learingQuizStore.itemQuestion?.id,
      'answered': itemTemp['value'],
    };
    final response = await parser.checkQuestion(param);
    if (response.statusCode == 200 &&
        (response.body["code"] == 'cannot_check_answer' ||
            response.body["status"] == 'error')) {
      Alert(context: context, title: response.body["message"]).show();
    }
    var dataTemp = {
      'id': learingQuizStore.itemQuestion?.id,
      'result': response.body['result'],
      'explanation': response.body['explanation'],
    };
    if (response.body['options'] != null) {
      learingQuizStore.itemQuestion!.options = response.body['options'];
    }
    itemCheck.add(dataTemp);
    update();
  }

  Future<void> showHint() async {
    var context = Get.context as BuildContext;
    if (learingQuizStore.itemQuestion?.hint != null) {
      Alert(
        context: context,
        title: tr(LocaleKeys.learningScreen_quiz_hint),
        desc: learingQuizStore.itemQuestion?.hint,
        buttons: [
          DialogButton(
            child: Text(
              tr(LocaleKeys.learningScreen_finishCourseAlert_cancel),
              style: const TextStyle(color: Colors.white),
            ),
            onPressed: () => {Navigator.pop(context)},
          ),
        ],
      ).show();
    } else {
      Alert(
        context: context,
        title: tr(LocaleKeys.learningScreen_quiz_hintEmpty),
        buttons: [
          DialogButton(
            child: Text(
              tr(LocaleKeys.learningScreen_finishCourseAlert_cancel),
              style: const TextStyle(color: Colors.white),
            ),
            onPressed: () => {Navigator.pop(context)},
          ),
        ],
      ).show();
    }
  }

  bool isDisable() {
    if (itemCheck.length != 0 &&
        itemCheck?.firstWhere(
              (x) => x['id'] == learingQuizStore.itemQuestion?.id,
              orElse: () => null,
            ) !=
            null) {
      return true;
    }
    if (learingQuizStore.dataQuiz?.checked_questions != null &&
        learingQuizStore.dataQuiz?.checked_questions?.firstWhere(
              (x) => x == learingQuizStore.itemQuestion?.id,
              orElse: () => null,
            ) !=
            null) {
      return true;
    }
    return false;
  }

  Future<void> onUploadFiles() async {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: dataAssignment.files_amount! > 1,
      allowedExtensions: dataAssignment.allow_file_type != null
          ? dataAssignment.allow_file_type?.split(',')
          : ['jpg', 'pdf', 'txt', 'zip', 'docx', 'doc', 'ppt'],
    );
    if (result != null) {
      for (var element in result.files) {
        var file = assignmentFiles
            .firstWhereOrNull((file) => file.name == element.name);
        if (file == null) {
          assignmentFiles.add(element);
        }
      }
      isAssignmentFileUpload = true;
      refresh();
      update();
    }
  }

  onActionDeleteFileAssignmentChoose(PlatformFile platformFile) {
    if (assignmentFiles != []) {
      for (int i = 0; i < assignmentFiles.length; i++) {
        if (assignmentFiles[i].name == platformFile.name) {
          assignmentFiles.removeAt(i);
        }
      }
    }
    if (assignmentFiles.isEmpty) {
      isAssignmentFileUpload = false;
    }
    refresh();
    update();
  }

  Future<void> onRetakeAssignment(id) async {
    try {
      final response = await parser.retakeAssignment(id);
      if (response.statusCode == 200) {
        getLesson();
      } else {
        // throw Exception('Failed to load courses');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> onStartAssignment(id) async {
    try {
      final response = await parser.startAssignment(id);

      if (response.statusCode == 200) {
        getLesson();
      } else {
        // throw Exception('Failed to load courses');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> onSaveOrSendAssignment(id, action) async {
    try {
      DialogHelper.showLoading();
      Map<String, dynamic> param = {};
      param['id'] = id;
      param['note'] = answerAssignment.text;
      param['action'] = action;

      if (assignmentFiles.length > 0) {
        List<dynamic> files = [];

        for (var element in assignmentFiles) {
          files.add(element);
        }
        param['files'] = files;
      }

      final response = await parser.saveOrSendAssignment(param);
      if (response.statusCode == 200) {
        DialogHelper.hideLoading();
        Alert(
          context: context,
          title: tr(LocaleKeys.learningScreen_assignment_title),
          desc: action == 'save'
              ? tr(LocaleKeys.learningScreen_assignment_messageSaveAssignment)
              : tr(LocaleKeys.learningScreen_assignment_notificationSuccess),
          buttons: [
            DialogButton(
              child: Text(
                tr(LocaleKeys.learningScreen_finishCourseAlert_ok),
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () => {Navigator.pop(context), getLesson()},
            ),
          ],
        ).show();
      } else {
        DialogHelper.hideLoading();
        Alert(
                context: context,
                title: tr(LocaleKeys.learningScreen_assignment_title),
                desc: response.body['message'])
            .show();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> onDeleteFileAssignment(id, fileId) async {
    try {
      final response = await parser.deleteFileAssignment(id, fileId);
      if (response.statusCode == 200) {
        isAssignmentFileUpload = false;
        var context = Get.context as BuildContext;
        Alert(
          context: context,
          desc:
              tr(LocaleKeys.learningScreen_assignment_deleteFileSuccessMessage),
          buttons: [
            DialogButton(
              child: Text(
                tr(LocaleKeys.learningScreen_finishCourseAlert_ok),
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () => {Navigator.pop(context), getLesson()},
            ),
          ],
        ).show();
      } else {
        // throw Exception('Failed to load courses');
      }
    } catch (e) {
      print(e);
    }
  }

  checkAnswer(itemQuestion) async {
    var item = listAnswer.firstWhereOrNull((x) => x['id'] == itemQuestion.id);

    if (item != null) {
      final response = await parser.checkAnswer(
          lesson!.id.toString(), item['id'].toString(), item['answered']);
      if (response.statusCode == 200 && response.body['status'] == "success") {
        _answerDataCheck[itemQuestion.id.toString()] =
            AnswerDataCheck.fromJson(response.body);
      }
      refresh();
      update();
    } else {
      Alert(
        context: context,
        title: tr(LocaleKeys.learningScreen_quiz_checkAlert),
        buttons: [
          DialogButton(
            child: Text(
              tr(LocaleKeys.learningScreen_finishCourseAlert_ok),
              style: const TextStyle(color: Colors.white),
            ),
            onPressed: () => {Navigator.pop(context)},
          ),
        ],
      ).show();
    }
  }

  onHandleSortingChoice(answered) {
    var index = listAnswer.indexWhere((x) =>
        x['id'].toString() == learingQuizStore.itemQuestion?.id.toString());
    if (index != -1) {
      listAnswer[index] = {
        "id": learingQuizStore.itemQuestion?.id,
        "answered": answered
      };
    } else {
      listAnswer
          .add({"id": learingQuizStore.itemQuestion?.id, "answered": answered});
    }
  }

  void scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (!isLoadingMore) return;
    }
  }

  void dispose() {
    scrollController.removeListener(scrollListener);
    super.dispose();
  }

  void _onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (!isLoadingMore) return;
    }
  }

  handleCheckCurrentShowLesson(index) {
    isCheckCurrentShowLesson = true;
    indexCurrentShowLesson = index;
    refresh();
    update();
  }
}

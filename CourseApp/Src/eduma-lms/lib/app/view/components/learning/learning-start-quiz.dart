import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/course_store.dart';
import 'package:flutter_app/app/backend/mobx-store/init_store.dart';
import 'package:flutter_app/app/backend/mobx-store/learing_quiz_store.dart';
import 'package:flutter_app/app/backend/models/learning-lesson-model.dart';
import 'package:flutter_app/app/controller/learing_controller.dart';
import 'package:flutter_app/app/view/components/countdown.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../../../l10n/locale_keys.g.dart';

class _LearningStartQuiz extends State<LearningStartQuiz> {
  final courseStore = locator<CourseStore>();
  final learingQuizStore = locator<LearingQuizStore>();
  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);
  var screenHeight =
      (window.physicalSize.longestSide / window.devicePixelRatio);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LearningController>(builder: (value) {
      bool isQuestionAnswer = value.listAnswerDataCheck
          .containsKey(learingQuizStore.itemQuestion?.id.toString());
      return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        widget.data.name ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontFamily: "semibold", fontSize: 16),
                      ),
                    ),
                    Row(
                      children: [
                        Countdown(
                          duration: widget.dataQuiz.total_time != null
                              ? widget.dataQuiz.total_time!
                              : 0,
                          callBack: value.callBackFinishQuiz,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          tr(LocaleKeys.learningScreen_quiz_timeRemaining),
                          style: const TextStyle(
                              color: Colors.red, fontFamily: "semibold"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (widget.dataQuiz.questions!.length > 1)
                Container(
                  width: screenWidth,
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        // width: 10,
                        // height: 20,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFFE4E4E4),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () =>
                              value.pageActive == 0 ? null : value.onPrevQuiz(),
                          child: const Icon(
                            Icons.chevron_left,
                            size: 18,
                          ),
                        ),
                      ),
                      SizedBox(
                        // width: screenWidth - 100,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Wrap(
                                  direction: Axis.horizontal,
                                  children: List.generate(
                                    widget.dataQuiz.questions!.length,
                                    (index) => GestureDetector(
                                      onTap: () {
                                        value.onActiveQuiz(
                                            widget.dataQuiz.questions![index],
                                            index);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 2),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 6),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4)),
                                          color: value.pageActive == index
                                              ? const Color(0xFFFBC815)
                                              : Colors.white,
                                          border: Border.all(
                                            color: value.pageActive == index
                                                ? const Color(0xFFFBC815)
                                                : const Color(0xFFE4E4E4),
                                          ),
                                        ),
                                        child: Text(
                                          '${index + 1}',
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        // width: 30,
                        // height: 35,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFFE4E4E4),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () => value.pageActive ==
                                  widget.dataQuiz.questions!.length
                              ? null
                              : value.onNextQuiz(),
                          child: const Icon(
                            Icons.chevron_right,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (learingQuizStore.itemQuestion != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: isQuestionAnswer
                          ? handleRenderQuestionAfterClickCheckAnswer(
                              learingQuizStore.itemQuestion,
                              value.listAnswerDataCheck[
                                  learingQuizStore.itemQuestion?.id.toString()])
                          : handleRenderQuestion(value)),
                ),
              if (learingQuizStore.dataQuiz?.instant_check != null &&
                  learingQuizStore.dataQuiz!.checked_questions != null &&
                  learingQuizStore.dataQuiz!.checked_questions!
                      .contains(learingQuizStore.itemQuestion?.id))
                Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        tr(LocaleKeys.learningScreen_quiz_questionAnswered),
                        style: const TextStyle(color: Colors.green),
                      ),
                      const Icon(Icons.check, color: Colors.green),
                    ],
                  ),
                ),
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (!isQuestionAnswer) {
                          value.checkAnswer(learingQuizStore.itemQuestion);
                        }
                      },
                      child: Container(
                        width: screenWidth,
                        height: 50,
                        decoration: BoxDecoration(
                          color:
                              !isQuestionAnswer ? Colors.green : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              tr(LocaleKeys.learningScreen_quiz_btnCheck),
                              style: TextStyle(
                                fontFamily: 'Poppins-Medium',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: !isQuestionAnswer
                                    ? Colors.white
                                    : Colors.green,
                              ),
                            ),
                            Icon(
                              Icons.check,
                              size: 20,
                              color: !isQuestionAnswer
                                  ? Colors.white
                                  : Colors.green,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: value.showHint,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFF626FE2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.lightbulb_outline,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => value.onFinish(),
                          child: Container(
                            height: 50,
                            width: screenWidth - 150,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBC815),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                tr(LocaleKeys.learningScreen_quiz_btnFinish),
                                style: const TextStyle(
                                  fontFamily: 'Poppins-Medium',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: value.onNextQuiz,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.chevron_right),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ));
    });
  }

  Future<void> _dialogBuilder(BuildContext context, explanation) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            tr(LocaleKeys.learningScreen_quiz_explanation),
            style: TextStyle(
              fontFamily: 'medium',
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            explanation,
            style: TextStyle(
              fontFamily: 'medium',
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(tr(LocaleKeys.alert_ok),
                  style: TextStyle(
                    fontFamily: 'medium',
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> handleRenderQuestionAfterClickCheckAnswer(question, answer) {
    List<Widget> listWidget = [];

    if (question != null)
      listWidget.add(Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(children: [
            HtmlWidget(
              question!.title.toString(),
              textStyle: TextStyle(fontFamily: "medium"),
            ),
          ])));
    if (question?.content != null)
      listWidget.add(Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: HtmlWidget(question!.content.toString()),
      ));
    if (question?.type == 'single_choice' || question?.type == 'true_or_false')
      listWidget.add(Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Wrap(
            direction: Axis.vertical,
            children: List.generate(
                question!.options!.length,
                (index) =>
                    itemOption(question!.options?[index], answer, index))),
      ));
    if (question?.type == 'multi_choice')
      listWidget.add(Wrap(
          direction: Axis.vertical,
          children: List.generate(
              question!.options!.length,
              (index) => itemOptionMultiChoice(
                  question!.options?[index], answer, index))));
    if (question?.type == 'sorting_choice')
      listWidget.add(Container(
        child: Column(
          children: [...handleSortingChoice(answer)],
        ),
      ));
    if (question?.type == 'fill_in_blanks')
      listWidget.add(renderFillInBlanksAnswer(answer));

    listWidget.add(Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: answer.result.correct
                  ? const Color(0xFF58C3FF)
                  : const Color(0xFFF46647),
              padding: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: 12), // foreground color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {},
            child: Text(
              answer.result.correct
                  ? tr(LocaleKeys.reviewQuiz_status_success)
                  : tr(LocaleKeys.reviewQuiz_status_failed),
              style: TextStyle(fontFamily: "medium"),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
              child: Text(
            tr(LocaleKeys.learningScreen_quiz_pointResult,
                args: [answer.result.mark.toString()]),
            style: TextStyle(fontFamily: "medium"),
          )),
          SizedBox(
            width: 20,
          ),
          if (answer.explanation != "" && answer.explanation != null)
            ElevatedButton(
                onPressed: () => _dialogBuilder(context, answer.explanation),
                child: Row(children: [
                  Icon(Icons.north_east),
                  Text(tr(LocaleKeys.learningScreen_quiz_explanation))
                ]))
        ],
      ),
    ));
    return listWidget;
  }

  Widget itemOption(item, userAnswer, index) {
    return GestureDetector(
      onTap: () {
        // Handle tap event
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (userAnswer.result.correct != null &&
                    userAnswer.result.answered.contains(item.value) &&
                    userAnswer.options[index]?.is_true == 'yes')
                ? Icon(
                    Icons.check_circle_outline,
                    size: 14,
                    color: item.is_true == "yes" ? Colors.green : Colors.red,
                  )
                : userAnswer.result.answered.contains(item.value)
                    ? const Icon(
                        Icons.cancel_outlined,
                        size: 14,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.radio_button_unchecked,
                        size: 14,
                        color: Colors.grey,
                      ),
            const SizedBox(width: 9),
            Text(
              item.title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                height: 1.46,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> handleRenderQuestion(value) {
    List<Widget> listQuestion = [];
    listQuestion.add(HtmlWidget(
      learingQuizStore.itemQuestion!.title.toString(),
      textStyle: TextStyle(fontFamily: "medium"),
    ));
    listQuestion.add(SizedBox(
      height: 10,
    ));
    if (learingQuizStore.itemQuestion?.content != null)
      listQuestion
          .add(HtmlWidget(learingQuizStore.itemQuestion!.content.toString()));
    if (learingQuizStore.itemQuestion?.type == 'single_choice')
      listQuestion.add(Wrap(
        direction: Axis.vertical,
        children: List.generate(
            learingQuizStore.itemQuestion!.options!.length,
            (index) => GestureDetector(
                  onTap: () {
                    value.isDisable()
                        ? null
                        : value.selectQuestion(
                            learingQuizStore.itemQuestion!.options?[index]);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Icon(
                          learingQuizStore.itemQuestion?.answer != null &&
                                  learingQuizStore.itemQuestion?.answer.any(
                                      (x) =>
                                          x.value ==
                                          learingQuizStore.itemQuestion
                                              ?.options?[index].value)
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: screenWidth - 50,
                          child: Text(
                            learingQuizStore
                                .itemQuestion!.options![index].title!,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
      ));
    if (learingQuizStore.itemQuestion?.type == 'true_or_false')
      listQuestion.add(Wrap(
        direction: Axis.vertical,
        children: List.generate(
            learingQuizStore.itemQuestion!.options!.length,
            (index) => GestureDetector(
                  onTap: () {
                    value.isDisable()
                        ? null
                        : value.selectQuestion(
                            learingQuizStore.itemQuestion!.options?[index]);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Icon(
                          learingQuizStore.itemQuestion?.answer != null &&
                                  learingQuizStore.itemQuestion?.answer.any(
                                      (x) =>
                                          x.value ==
                                          learingQuizStore.itemQuestion
                                              ?.options?[index].value)
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: screenWidth - 50,
                          child: Text(
                            learingQuizStore
                                .itemQuestion!.options![index].title!,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
      ));
    if (learingQuizStore.itemQuestion?.type == 'multi_choice')
      listQuestion.add(Wrap(
        direction: Axis.vertical,
        children: List.generate(
            learingQuizStore.itemQuestion!.options!.length,
            (index) => GestureDetector(
                  onTap: () {
                    value.isDisable()
                        ? null
                        : value.selectQuestion(
                            learingQuizStore.itemQuestion!.options?[index]);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Icon(
                          learingQuizStore.itemQuestion?.answer != null &&
                                  learingQuizStore.itemQuestion?.answer.any(
                                      (x) =>
                                          x.value ==
                                          learingQuizStore.itemQuestion
                                              ?.options?[index].value)
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: screenWidth - 50,
                          child: Text(
                            learingQuizStore
                                .itemQuestion!.options![index].title!,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
      ));
    if (learingQuizStore.itemQuestion?.type == 'sorting_choice') {
      listQuestion.add(ReorderableListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        // padding: const EdgeInsets.symmetric(horizontal: 40),
        children: <Widget>[
          for (int index = 0;
              index < learingQuizStore.itemQuestion!.options!.length;
              index += 1)
            Card(
              key: Key('$index'),
              shape:
                  ShapeBorder.lerp(Border.symmetric(), Border.symmetric(), 5),
              child: ListTile(
                title:
                    Text(learingQuizStore.itemQuestion!.options![index].title!),
                leading: Icon(
                  Icons.reorder_outlined,
                  color: Colors.black,
                ),
              ),
            )
        ],
        onReorder: (int oldIndex, int newIndex) {
          if (value.isDisable()) return;
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            var item =
                learingQuizStore.itemQuestion!.options!.removeAt(oldIndex);
            learingQuizStore.itemQuestion!.options!.insert(newIndex, item);

            //handle list sort answer
            List<String> list = learingQuizStore.itemQuestion!.options!
                .map((e) => e.value.toString())
                .toList();
            value.onHandleSortingChoice(list.toString());
          });
        },
      ));
    }
    if (learingQuizStore.itemQuestion?.type == 'fill_in_blanks')
      listQuestion.add(renderFillInBlanks(value));
    listQuestion.add(SizedBox(
      height: 36,
    ));
    return listQuestion;
  }

  Widget renderFillInBlanks(valueController) {
    final itemQuestion = learingQuizStore.itemQuestion;
    var lstIdKeys = <Map<String, dynamic>>[];
    final options = itemQuestion?.options![0];
    final ids = options?.ids;
    var titleApi = options?.title_api;

    ids?.forEach((id) {
      lstIdKeys.add({'id': id, 'key': '{{FIB_$id}}'});
    });

    final words = titleApi!.split(' ');

    List<Widget> list = [];
    int index = 0;
    for (var e in words) {
      var word = words[index];
      var itemKey = lstIdKeys.firstWhereOrNull((item) => item['key'] == word);
      if (itemKey != null) {
        final itemId = itemKey['id'];
        list.add(SizedBox(
          width: 100,
          child: TextField(
            controller: valueController.handleRenderFieldControl(itemId),
            key: Key(index.toString()),
            // enabled: !this.itemCheck.any((x) => x['id'] == itemQuestion['id']),
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              //contentPadding: EdgeInsets.zero,
              isDense: true,
              border: UnderlineInputBorder(borderSide: BorderSide(width: 1)),
            ),
            onChanged: (value) =>
                valueController.onChangeFillBlank(itemId, value),
          ),
        ));
      } else {
        list.add(Text(e));
      }

      index++;
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 1.5,
      runSpacing: 3,
      children: list,
    );
  }

  Widget renderFillInBlanksAnswer(question) {
    final itemQuestion = question;
    var lstIdKeys = <Map<String, dynamic>>[];
    final options = itemQuestion?.options![0];
    final ids = options?.ids;
    final titleApi = options?.title_api;

    ids?.forEach((id) {
      lstIdKeys.add({'id': id, 'key': '{{FIB_$id}}'});
    });

    final words = titleApi!.split(' ');

    List<Widget> list = [];
    int index = 0;

    for (var e in words) {
      var word = words[index];
      var itemKey = lstIdKeys.firstWhereOrNull((x) => x['key'] == word);

      if (itemKey != null) {
        final itemId = itemKey['id'];
        list.add(SizedBox(
            width: calculateWidth(options?.answers[itemId]['answer']) +
                calculateWidth(options?.answers[itemId]['correct']) +
                50,
            child: Container(
              color: Colors.grey.shade300,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(options?.answers[itemId]['answer'],
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(color: Colors.black, fontFamily: 'medium')),
                  Icon(Icons.arrow_forward),
                  Text(
                    options?.answers[itemId]['correct'],
                    style: TextStyle(color: Colors.green, fontFamily: 'medium'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )));
      } else {
        list.add(Text(e));
      }

      index++;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 1.5,
        runSpacing: 3,
        children: list,
      ),
    );
  }

  Widget itemOptionMultiChoice(item, userAnswer, index) {
    return GestureDetector(
      onTap: () {
        // Handle tap event
      },
      child: Container(
        width: screenWidth,
        margin: const EdgeInsets.only(top: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (userAnswer.result.correct &&
                    userAnswer.result.answered != null &&
                    userAnswer.result.answered.contains(item.value))
                ? const Icon(
                    Icons.check_circle_outline,
                    size: 14,
                    color: Colors.green,
                  )
                : userAnswer.options[index]?.is_true == 'yes'
                    ? Icon(
                        Icons.check_circle_outline,
                        size: 14,
                        color: userAnswer.result.answered.contains(item.value)
                            ? Colors.green
                            : Colors.red,
                      )
                    : Icon(
                        Icons.radio_button_unchecked,
                        size: 14,
                        color: userAnswer.result.answered.contains(item.value)
                            ? Colors.red
                            : Colors.grey,
                      ),
            const SizedBox(width: 9),
            SizedBox(
              width: screenWidth - 32,
              child: Text(
                item.title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> handleSortingChoice(dataSortingChoice) {
    List<Widget> list = [];
    String cleanedString = dataSortingChoice.result.answered
        .replaceAll("[", "")
        .replaceAll("]", "")
        .replaceAll(" ", "");
    List<String> answered = cleanedString.split(",");
    List<dynamic> options = [];
    if (dataSortingChoice.options != null) {
      dataSortingChoice.options.forEach((item) {
        options.add(item);
      });
    }
    for (int index = 0; index < answered.length; index += 1) {
      var itemAnswered = options
          .firstWhereOrNull((element) => element.value == answered[index]);
      if (itemAnswered != null) {
        list.add(Card(
          key: Key('$index'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(color: Colors.grey.shade300, width: 1.0),
          ),
          child: ListTile(
            title: Text(itemAnswered.title!),
            leading: Icon(
              Icons.reorder_outlined,
              color: Colors.black,
            ),
          ),
        ));
      }

      var itemCorrect =
          options.firstWhereOrNull((element) => element.sorting == index);
      if (itemCorrect != null) {
        list.add(Card(
          key: Key('12$index'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(color: Colors.green, width: 1.0),
          ),
          child: ListTile(
            title: Text(itemCorrect.title!),
          ),
        ));
      }
    }
    return list;
  }

  double calculateWidth(String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
          text: text,
          style: TextStyle(color: Colors.black, fontFamily: 'medium')),
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.width;
  }

  @override
  void initState() {
    final LearningController learningController =
        Get.find<LearningController>();
    learningController.handleOnInitAnswered();
    super.initState();
  }
}

class LearningStartQuiz extends StatefulWidget {
  const LearningStartQuiz(
      {super.key,
      required this.data,
      required this.dataQuiz,
      this.itemQuestion});

  final LearningLessonModel data;
  final QuizModel dataQuiz;
  final QuestionModel? itemQuestion;

  @override
  State<LearningStartQuiz> createState() => _LearningStartQuiz();
}

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/course_store.dart';
import 'package:flutter_app/app/backend/mobx-store/init_store.dart';
import 'package:flutter_app/app/backend/models/learning-lesson-model.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import 'package:get_it_mixin/get_it_mixin.dart';

typedef OnNavigateCallback = void Function();

class ReviewQuiz extends StatefulWidget with GetItStatefulWidgetMixin {
  final LearningLessonModel data;
  final OnNavigateCallback onClose;

  ReviewQuiz({super.key, required this.data, required this.onClose});

  @override
  _ReviewQuizState createState() => _ReviewQuizState();

  calculateWidth(answer) {}
}

class _ReviewQuizState extends State<ReviewQuiz> {
  static ReviewQuiz createWithData(
      LearningLessonModel data, OnNavigateCallback onClose) {
    return ReviewQuiz(data: data, onClose: onClose);
  }

  final courseStore = locator<CourseStore>();
  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);
  var screenHeight =
      (window.physicalSize.longestSide / window.devicePixelRatio);
  int pageActive = 0;
  QuestionModel? question;

  @override
  void initState() {
    super.initState();
    setState(() {
      question = widget.data.questions![0];
      pageActive = 0;
    });
  }

  Future<void> _dialogBuilder(BuildContext context) {
    String content = widget.data.results!.answered[question?.id.toString()]['explanation'].toString();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            tr(LocaleKeys.learningScreen_quiz_explanation),
            style: TextStyle(fontFamily: 'medium', fontSize: 20),
          ),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text(tr(LocaleKeys.alert_ok)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> onActiveQuiz(item, index) async {
    setState(() {
      question = item;
      pageActive = index;
    });
  }

  Future<void> onPrevQuiz() async {
    if (pageActive - 1 < 0) return;
    setState(() {
      question = widget.data.questions![pageActive - 1];
      pageActive = pageActive - 1;
    });
  }

  Future<void> onNextQuiz() async {
    setState(() {
      question = widget.data.questions![pageActive + 1];
      pageActive = pageActive + 1;
    });
  }

  Widget renderFillInBlanks() {
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
        list.add(
            SizedBox(
              width: calculateWidth(options?.answers[itemId]['answer'])+calculateWidth(options?.answers[itemId]['correct'])+50,
              child: Container(
                color: Colors.grey.shade300,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 10,),
                    Text(
                        options?.answers[itemId]['answer'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black,fontFamily: 'medium')
                    ),
                    Icon(Icons.arrow_forward),
                    Text(
                      options?.answers[itemId]['correct'],
                      style: TextStyle(color: Colors.green,fontFamily: 'medium'),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            )
        );
      }else{
        list.add(Text(e));
      }

      index++;
    }


    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 1.5,
        runSpacing: 3,
        children: list,
      ),
    );
  }

  Widget itemOption(item) {

    dynamic userAnswer =
        widget.data.results?.answered[question?.id.toString()];
    return GestureDetector(
      onTap: () {
        // Handle tap event
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (userAnswer["correct"] != null &&
                        userAnswer["answered"].contains(item.value)) ||
                    item?.is_true == 'yes'
                ?  Icon(
                    Icons.check_circle_outline,
                    size: 14,
                    color: item.is_true == "yes" ?
                    Colors.green:
                    Colors.red,
                  )
                : userAnswer["answered"].contains(item.value)
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

  Widget itemOptionMultiChoice(item) {
    dynamic userAnswer =
        widget.data.results?.answered[question?.id.toString()];
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
            (userAnswer['correct'] &&
                    userAnswer['answered'] != null &&
                    userAnswer['answered'].contains(item.value))
                ? const Icon(
                    Icons.check_circle_outline,
                    size: 14,
                    color: Colors.green,
                  )
                : item?.is_true == 'yes'
                    ? Icon(
                        Icons.check_circle_outline,
                        size: 14,
                        color: userAnswer['answered'].contains(item.value)
                            ? Colors.green
                            : Colors.red,
                      )
                    : Icon(
                        Icons.radio_button_unchecked,
                        size: 14,
                        color: userAnswer['answered'].contains(item.value)
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
            onPressed: () => {widget.onClose()}, icon: const Icon(Icons.close)),
        Expanded(
            child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                scrollDirection: Axis.vertical,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          widget.data.name ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              fontFamily: "semibold"),
                        ),
                      ),
                      if (widget.data.questions!.length > 1)
                        Container(
                          width: screenWidth,
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                // width: 10,
                                // height: 20,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 6),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color(0xFFE4E4E4),
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () =>
                                      pageActive == 0 ? null : onPrevQuiz(),
                                  child: const Icon(
                                    Icons.chevron_left,
                                    size: 18,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: screenWidth - 100,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Wrap(
                                          direction: Axis.horizontal,
                                          children: List.generate(
                                            widget.data.questions!.length,
                                            (index) => GestureDetector(
                                              onTap: () {
                                                onActiveQuiz(
                                                    widget
                                                        .data.questions![index],
                                                    index);
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 6),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(4)),
                                                  color: pageActive == index
                                                      ? const Color(0xFFFBC815)
                                                      : Colors.white,
                                                  border: Border.all(
                                                    color: pageActive == index
                                                        ? const Color(
                                                            0xFFFBC815)
                                                        : const Color(
                                                            0xFFE4E4E4),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color(0xFFE4E4E4),
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () => pageActive ==
                                          widget.data.questions!.length - 1
                                      ? null
                                      : onNextQuiz(),
                                  child: const Icon(
                                    Icons.chevron_right,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (question != null)
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(children: [
                              HtmlWidget(
                                question!.title.toString(),
                                textStyle: TextStyle(fontFamily: "medium"),
                              ),
                            ])),
                      if (question?.content != null)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: HtmlWidget(question!.content.toString()),
                        ),
                      if (question?.type == 'single_choice' ||
                          question?.type == 'true_or_false')
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Wrap(
                              direction: Axis.vertical,
                              children: List.generate(
                                  question!.options!.length,
                                  (index) =>
                                      itemOption(question!.options?[index]))),
                        ),
                      if (question?.type == 'multi_choice')
                        Wrap(
                            direction: Axis.vertical,
                            children: List.generate(
                                question!.options!.length,
                                (index) => itemOptionMultiChoice(
                                    question!.options?[index]))),
                      if (question?.type == 'sorting_choice')
                        Container(
                          child: Column(
                           children: [
                             ...handleSortingChoice()
                           ],
                          ),
                        ),
                      if (question?.type == 'fill_in_blanks')
                        renderFillInBlanks(),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.data.results?.answered[question?.id.toString()]['correct']
                                    ?const Color(0xFF58C3FF)
                                    :const Color(0xFFF46647),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 12), // foreground color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                widget.data.results?.answered[question?.id.toString()]['correct']
                                    ? tr( LocaleKeys.reviewQuiz_status_success)
                                    : tr(LocaleKeys.reviewQuiz_status_failed),
                                style: TextStyle(fontFamily: "medium"),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              widget.data.results!.answered[question?.id.toString()]['mark'].toString()+'/1 point',
                              style: TextStyle(fontFamily: "medium"),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                                onPressed: () => _dialogBuilder(context),
                                child: Row(children: [
                                  Icon(Icons.north_east),
                                  Text(tr(LocaleKeys.learningScreen_quiz_explanation))
                                ]))
                          ],
                        ),
                      )
                    ],
                  ),
                ))),
      ],
    );
  }

  List<Widget> handleSortingChoice(){
    List<Widget> list = [];
    var dataSortingChoice = widget.data.results?.answered[question?.id.toString()];

    List<dynamic> options = [];
    List<dynamic> answered = [];
    if(dataSortingChoice['answered'] is String){
      String cleanedString = dataSortingChoice['answered'].replaceAll("[", "").replaceAll("]", "").replaceAll(" ", "");
      answered = cleanedString.split(",");
    }
    if(dataSortingChoice['answered'] is List){
      answered = dataSortingChoice['answered'];
    }

    if(dataSortingChoice['options'] != null){
      dataSortingChoice['options'].forEach((item){
        options.add(item);
      });
    }

    for (int index = 0; index < answered.length; index += 1)
    {
      var itemAnswered = options.firstWhereOrNull((element) => element['value'] == answered[index]);
      if(itemAnswered != null) list.add(Card(
        key: Key('$index'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
        child: ListTile(
          title: Text(itemAnswered['title']!),
          leading: Icon(
            Icons.reorder_outlined,
            color: Colors.black,
          ),
        ),
      ));

      var itemCorrect = options.firstWhereOrNull((element) => element['sorting'] == index);
      if(itemCorrect != null) list.add(
          Card(
            key: Key('12$index'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(color: Colors.green, width: 1.0),
              ),
            child: ListTile(
                    title: Text(itemCorrect['title']!),
                  ),
          )
      );

    }
    return list;
  }

  double calculateWidth(String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
          text: text,
          style: TextStyle(color: Colors.black,fontFamily: 'medium')
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.width;
  }
}

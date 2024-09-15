import 'dart:convert';

import 'package:flutter_app/app/backend/models/learning-lesson-model.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'learing_quiz_store.g.dart';

class LearingQuizStore = _LearingQuizStore with _$LearingQuizStore;

abstract class _LearingQuizStore with Store {
  @observable
  QuizModel? dataQuiz;
  @observable
  QuestionModel? itemQuestion;
  @observable
  dynamic itemCheck;


  @action
  void setData(value) {
    dataQuiz = value;
  }

  @action
  void setQuestion(value) {
    itemQuestion = value;
  }

  @action
  void setItemCheckuestion(value) {
    itemCheck = value;
  }
}

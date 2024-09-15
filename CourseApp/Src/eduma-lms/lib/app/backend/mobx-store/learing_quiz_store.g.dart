// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learing_quiz_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LearingQuizStore on _LearingQuizStore, Store {
  late final _$dataQuizAtom =
      Atom(name: '_LearingQuizStore.dataQuiz', context: context);

  @override
  QuizModel? get dataQuiz {
    _$dataQuizAtom.reportRead();
    return super.dataQuiz;
  }

  @override
  set dataQuiz(QuizModel? value) {
    _$dataQuizAtom.reportWrite(value, super.dataQuiz, () {
      super.dataQuiz = value;
    });
  }

  late final _$itemQuestionAtom =
      Atom(name: '_LearingQuizStore.itemQuestion', context: context);

  @override
  QuestionModel? get itemQuestion {
    _$itemQuestionAtom.reportRead();
    return super.itemQuestion;
  }

  @override
  set itemQuestion(QuestionModel? value) {
    _$itemQuestionAtom.reportWrite(value, super.itemQuestion, () {
      super.itemQuestion = value;
    });
  }

  late final _$itemCheckAtom =
      Atom(name: '_LearingQuizStore.itemCheck', context: context);

  @override
  dynamic get itemCheck {
    _$itemCheckAtom.reportRead();
    return super.itemCheck;
  }

  @override
  set itemCheck(dynamic value) {
    _$itemCheckAtom.reportWrite(value, super.itemCheck, () {
      super.itemCheck = value;
    });
  }

  late final _$_LearingQuizStoreActionController =
      ActionController(name: '_LearingQuizStore', context: context);

  @override
  void setData(dynamic value) {
    final _$actionInfo = _$_LearingQuizStoreActionController.startAction(
        name: '_LearingQuizStore.setData');
    try {
      return super.setData(value);
    } finally {
      _$_LearingQuizStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setQuestion(dynamic value) {
    final _$actionInfo = _$_LearingQuizStoreActionController.startAction(
        name: '_LearingQuizStore.setQuestion');
    try {
      return super.setQuestion(value);
    } finally {
      _$_LearingQuizStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setItemCheckuestion(dynamic value) {
    final _$actionInfo = _$_LearingQuizStoreActionController.startAction(
        name: '_LearingQuizStore.setItemCheckuestion');
    try {
      return super.setItemCheckuestion(value);
    } finally {
      _$_LearingQuizStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
dataQuiz: ${dataQuiz},
itemQuestion: ${itemQuestion},
itemCheck: ${itemCheck}
    ''';
  }
}

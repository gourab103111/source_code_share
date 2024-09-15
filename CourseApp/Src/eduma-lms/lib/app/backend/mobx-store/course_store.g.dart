// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CourseStore on _CourseStore, Store {
  late final _$detailAtom = Atom(name: '_CourseStore.detail', context: context);

  @override
  CourseModel? get detail {
    _$detailAtom.reportRead();
    return super.detail;
  }

  @override
  set detail(CourseModel? value) {
    _$detailAtom.reportWrite(value, super.detail, () {
      super.detail = value;
    });
  }

  late final _$_CourseStoreActionController =
      ActionController(name: '_CourseStore', context: context);

  @override
  void setDetail(dynamic value) {
    final _$actionInfo = _$_CourseStoreActionController.startAction(
        name: '_CourseStore.setDetail');
    try {
      return super.setDetail(value);
    } finally {
      _$_CourseStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
detail: ${detail}
    ''';
  }
}

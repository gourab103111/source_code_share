import 'package:flutter_app/app/backend/models/course_model.dart';
import 'package:mobx/mobx.dart';

part 'course_store.g.dart';

class CourseStore = _CourseStore with _$CourseStore;

abstract class _CourseStore with Store {
  @observable
  CourseModel? detail;

  @action
  void setDetail(value) {
    detail = value;
  }
}

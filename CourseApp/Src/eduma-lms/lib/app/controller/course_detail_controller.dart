import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/course_store.dart';
import 'package:flutter_app/app/backend/mobx-store/init_store.dart';
import 'package:flutter_app/app/backend/mobx-store/wishlist_store.dart';
import 'package:flutter_app/app/backend/models/course_model.dart';
import 'package:flutter_app/app/backend/models/lesson-model.dart';
import 'package:flutter_app/app/backend/parse/course_detail_parse.dart';
import 'package:flutter_app/app/helper/dialog_helper.dart';
import 'package:flutter_app/app/helper/router.dart';
import 'package:flutter_app/app/util/toast.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CourseDetailController extends GetxController {
  final CourseDetailParser parser;
  final courseStore = locator<CourseStore>();
  String courseId = "";
  bool apiCalled = false;

  bool haveData = false;

  String title = '';
  bool isLoading = false;
  CourseModel _course = CourseModel();
  CourseModel get course => _course;
  CourseDetailController({required this.parser});
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  double rating = 5;
  dynamic review;
  String reviewMessage = "";
  int sectionId = 0;
  bool callAgainRoute=false;

  @override
  void onInit() {
    super.onInit();
    courseId = Get.arguments[0].toString();
    getData();
  }
  handleGetIndexLesson(){
    ItemLesson? itemRedirect = ItemLesson();
    int i =0;
    for (var item in course.sections!) {
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

  void onBack() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  void start() {
    DialogHelper.showLoading();
    Future.delayed(const Duration(seconds: 1),(){
      if (_course.sections != null &&
          _course.sections!.isNotEmpty &&
          _course.sections![0].items!.isNotEmpty) {
        ItemLesson? itemRedirect;
        for (var item in _course.sections!) {
          itemRedirect = item.items?.firstWhere(
                (x) => x.status != 'completed',
            orElse: () => ItemLesson(),
          );
          sectionId = item.id!;
          if (itemRedirect?.id != null) {
            break;
          }
        }
        DialogHelper.hideLoading();
        onNavigateLearning(
            itemRedirect?.id != null
                ? itemRedirect
                : _course.sections![0].items![0],
            0);
      }
    });

  }

  void onNavigateLearning(item, index) {
    Get.toNamed(AppRouter.getLearningRoute(),
        arguments: [item, index, courseId,sectionId]);
  }

  Future<void> onStartContinue() async {
    if (_course.sections!.isNotEmpty &&
        _course.sections != null &&
        _course.sections?[0].items != null) {
      List<ItemLesson>? itemRedirect = [];
      for (var section in _course.sections!) {
        if (itemRedirect == null &&
            section.items!.isNotEmpty &&
            section.items != null) {
          itemRedirect = section.items?.where((x) => x.status != 'completed')
              as List<ItemLesson>;
        }
      }

      final item = itemRedirect != null && itemRedirect.isNotEmpty
          ? itemRedirect[0]
          : _course.sections?[0].items?[0];
      onNavigateLearning(item, 0);
    }
  }

  Future<void> onStartCourse() async {
    try {
      final response = await parser.enroll(courseId);
      if (response.statusCode == 200) {
        start();
      } else {
        // throw Exception('Failed to load courses');
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false; // hide loading indicator
    }
  }

  Future<void> onRetake() async {
    try {
      DialogHelper.showLoading();
      final response = await parser.enroll(courseId);
      Future.delayed(const Duration(seconds: 1),(){
        DialogHelper.hideLoading();
        if (response.statusCode == 200) {
          getData();
          start();
        }
      });

    } catch (e) {
      print(e);
    } finally {
      isLoading = false; // hide loading indicator
    }
  }

  Future<void> onEnroll() async {
    try {
      var context = Get.context as BuildContext;
      if (parser.getToken() == "") {
        Alert(
          context: context,
          title: tr(LocaleKeys.alert_notLoggedIn),
          desc: tr(LocaleKeys.alert_loggedIn),
          buttons: [
            DialogButton(
              color: Colors.red,
              child: Text(
                tr(LocaleKeys.alert_cancel),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () => {Navigator.pop(context)},
            ),
            DialogButton(
              child: Text(
                tr(LocaleKeys.alert_btnLogin),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () => {
                Navigator.pop(context),
                Get.toNamed(AppRouter.getLoginRoute())
              },
            ),
          ],
        ).show();
      } else {
        final response = await parser.enroll(courseId);
        if (response.statusCode == 200) {
          start();
        } else {
          // throw Exception('Failed to load courses');
        }
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false; // hide loading indicator
    }
  }

  Future<void> refreshData() async {
    await getData();
  }

  // function to fetch courses from API
  Future<void> getData() async {
    isLoading = true;
    try {
      parser.setOverview(courseId);
      final response = await parser.getDetailCourse(courseId);
      if (response.statusCode == 200) {
        // print(response.body);
        CourseModel courseTemp = CourseModel.fromJson(response.body);
        _course = courseTemp;
        // print("status");
        courseStore.setDetail(courseTemp);
        getRating(3);
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false; // hide loading indicator
    }
    refresh();
    update();
  }

  Future<CourseModel> getDetailCourse(courseId) async {
    final response = await parser.getDetailCourse(courseId.toString());
    if(response.statusCode == 200){
      update();
      refresh();
      return CourseModel.fromJson(response.body);
    }
    return CourseModel();
  }

  Future<void> onToggleWishlist(CourseModel item) async {
    var context = Get.context as BuildContext;
    if (parser.getToken() == "") {
      Alert(
        context: context,
        title: tr(LocaleKeys.alert_notLoggedIn),
        desc: tr(LocaleKeys.alert_loggedIn),
        buttons: [
          DialogButton(
            color: Colors.red,
            child: Text(
              tr(LocaleKeys.alert_cancel),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () => {Navigator.pop(context)},
          ),
          DialogButton(
            child: Text(
             tr(LocaleKeys.alert_btnLogin),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () => {
              Navigator.pop(context),
              Get.toNamed(AppRouter.getLoginRoute())
            },
          ),
        ],
      ).show();
    } else {
      DialogHelper.showLoading();
      final WishlistStore wishlistStore = Get.find<WishlistStore>();
      await wishlistStore.toggleWishlist(item);
      DialogHelper.hideLoading();
      refreshData();
    }
    update();
  }

  Future<void> getRating(int? per_page) async {
    try {
      final response = await parser.getRating(courseId, per_page);
      if (response.statusCode == 200) {
        review = response.body["data"];
        reviewMessage = response.body["message"];
        update();
      } else {
        throw Exception('Failed to load review course --- Please check active plugin LP course review');
      }
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<void> submitRating() async {
    var context = Get.context as BuildContext;
    try {
      if (titleController.text == "") {
        Alert(
          context: context,
          title: tr(LocaleKeys.singleCourse_review),
          desc: tr(LocaleKeys.singleCourse_reviewTitleEmpty),
          buttons: [
            DialogButton(
              child: Text(
               tr(LocaleKeys.alert_ok),
              ),
              onPressed: () => {Navigator.pop(context)},
            ),
          ],
        ).show();
        return;
      }
      if (contentController.text == "") {
        Alert(
          context: context,
          title: tr( LocaleKeys.singleCourse_review),
          desc:
              tr(LocaleKeys.singleCourse_reviewContentEmpty),
          buttons: [
            DialogButton(
              child: Text(
                tr(LocaleKeys.alert_ok),
              ),
              onPressed: () => {Navigator.pop(context)},
            ),
          ],
        ).show();
        return;
      }

      var param = {
        "id": courseId,
        "title": titleController.text,
        "rate": rating.toString(),
        "content": contentController.text,
      };
      context.loaderOverlay.show();
      final response = await parser.createRating(param);
      context.loaderOverlay.hide();
      if (response.statusCode == 200) {
        getRating(3);
        titleController.text = "";
        contentController.text = "";
        showToast(response.body["message"]);
        refresh();
        update();
      } else {
        showToast(response.body["message"]);
      }
    } catch (e) {
      print(e);
    } finally {}
  }
}

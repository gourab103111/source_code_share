import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/course_store.dart';
import 'package:flutter_app/app/backend/mobx-store/init_store.dart';
import 'package:flutter_app/app/backend/mobx-store/wishlist_store.dart';
import 'package:flutter_app/app/backend/models/instructor-model.dart';
import 'package:flutter_app/app/controller/course_detail_controller.dart';
import 'package:flutter_app/app/controller/courses_controller.dart';
import 'package:flutter_app/app/controller/home_controller.dart';
import 'package:flutter_app/app/controller/payment_controller.dart';
import 'package:flutter_app/app/helper/function_helper.dart';
import 'package:flutter_app/app/helper/router.dart';
import 'package:flutter_app/app/view/components/accordion-lesson.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_just_audio/fwfh_just_audio.dart';
import 'package:fwfh_webview/fwfh_webview.dart';
import 'package:get/get.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:indexed/indexed.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helper/dialog_helper.dart';


class CourseDetailScreen extends StatefulWidget with GetItStatefulWidgetMixin {
  CourseDetailScreen({Key? key}) : super(key: key);

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);
  var screenHeight =
      (window.physicalSize.longestSide / window.devicePixelRatio);

  final courseStore = locator<CourseStore>();
  final WishlistStore wishlistStore = Get.find<WishlistStore>();
  final CoursesController courseController = Get.find<CoursesController>();
  final PaymentController paymentController = Get.find<PaymentController>();
  final HomeController homeController = Get.find<HomeController>();
  final CourseDetailController courseDetailController =
      Get.find<CourseDetailController>();

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  void initState() {
    if (Get.arguments.length > 1 && Get.arguments[1] == 'reloadPage') refreshData();
    super.initState();
  }

  refreshData() async {
    await courseDetailController.refreshData();
  }

  void onNaviInstructor(value) {
    UserInstructorModel instructor = UserInstructorModel.fromJson(value);
    Get.toNamed(AppRouter.getIntructorDetailRoute(), arguments: [instructor]);
  }

  Widget renderItemRating(value) {
    if (value.review == null) {
      return Container();
    }
    return Column(children: [
      Wrap(
          direction: Axis.horizontal,
          children: List.generate(
            value.review["reviews"]["reviews"].length,
            (index) => Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.only(
                bottom: 16,
                // border: Border(bottom: BorderSide(color: Colors.grey))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value.review["reviews"]["reviews"][index]
                            ["display_name"],
                        style: TextStyle(
                          fontSize: 14, fontFamily: 'poppins',
                          color: Colors.grey.shade700
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      RatingBar.builder(
                        ignoreGestures: true,
                        initialRating: double.parse(
                            value.review["reviews"]["reviews"][index]["rate"]),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 12,
                        unratedColor: Colors.grey,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    value.review["reviews"]["reviews"][index]["title"],
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'bold',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    value.review["reviews"]["reviews"][index]["content"],
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'poppins',

                    ),
                  ),
                  Divider(
                    height: 20,
                    thickness: 0.7,
                    indent: 0,
                    endIndent: 0,
                    color: Colors.grey.shade400,
                  )
                ],
              ),
            ),
          )),
      if (value.review["reviews"]["reviews"].isNotEmpty&&value.review["reviews"]["paged"] < value.review["reviews"]['pages'])
        InkWell(
          onTap: () {
            Get.toNamed(AppRouter.getReview(), arguments: [value.courseId]);
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tr(LocaleKeys.singleCourse_showAllReview) +
                      " (" +
                      value.review["total"].toString() +")",
                  style: TextStyle(
                    fontFamily: 'medium',
                    fontSize: 14,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                ),
              ],
            ),
          ),
        )
    ]);
  }

  Widget renderComment(value) {
    if (value.review != null && value.review["can_review"] == true) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr(LocaleKeys.singleCourse_leaveAReview),
              style: TextStyle(
                fontFamily: 'Poppins-Medium',
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              tr(LocaleKeys.singleCourse_leaveAReviewDescription),
              style: TextStyle(
                fontFamily: 'Poppins-ExtraLight',
                fontSize: 13,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr(LocaleKeys.singleCourse_reviewTitle),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: BorderSide(
                              color: Color(0xFFF3F3F3),
                            ),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                          isDense: true,
                        ),
                        controller: value.titleController,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tr(LocaleKeys.singleCourse_reviewRating)),
                      SizedBox(height: 8),
                      RatingBar.builder(
                        initialRating: 5,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 25,
                        itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Color(0xFFFBC815),
                        ),
                        onRatingUpdate: (rating) {
                          value.rating = rating;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(tr(LocaleKeys.singleCourse_reviewContent)),
            SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide: BorderSide(
                    color: Color(0xFFF3F3F3),
                  ),
                ),
                contentPadding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                isDense: true,
                // minLines: 4,
                // maxLines: 4,
              ),
              controller: value.contentController,
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () => value.submitRating(),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tr(LocaleKeys.singleCourse_reviewSubmit),
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins-Medium',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.38,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(); // Return an empty container if the condition is not met
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CourseDetailController>(builder: (value) {
      if (value.course.name == null) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
        );
      } else {

        homeController.setOverviewId(value.courseId);

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          drawerEnableOpenDragGesture: false,
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
              Column(
                children: <Widget>[
                  Container(
                    height: 80.0,
                    width: screenWidth,
                    // color: Colors.blue,
                    padding: EdgeInsets.fromLTRB(
                        0, MediaQuery.of(context).viewPadding.top - 5, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          // width: 40,
                          child: IconButton(
                            onPressed: () {
                              homeController.getOverview();
                              value.onBack();
                            },
                            icon: Image.asset('assets/images/icon/icon-back.png',color: Colors.black,height: 14,width: 14,),
                          ),
                        ),
                        Text(
                          tr( LocaleKeys.singleCourse_title),
                          style: const TextStyle(
                            fontFamily: 'Poppins-Medium',
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                          ),

                        ),
                        Container(width: 40),
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
                              Stack(children: [
                                Observer(
                                    builder: (_) => Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Container(
                                            width: screenWidth,
                                            height: (250 / 375) * screenWidth,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: !courseStore
                                                        .detail!.image!
                                                        .contains('placeholder')
                                                    ? NetworkImage(courseStore
                                                        .detail!.image!)
                                                    : Image.asset(
                                                            "assets/images/placeholder-500x300.png")
                                                        .image,
                                              ), // Widget con của
                                            ),
                                          ),
                                        )),
                                Positioned(
                                  top: 25,
                                  right: 15,
                                  child: wishlistStore.data.any((element) =>
                                              element.id ==
                                              courseStore.detail?.id) ==
                                          true
                                      ? GestureDetector(
                                          onTap: () async => {
                                                await value.onToggleWishlist(
                                                    courseStore.detail!),
                                                courseController
                                                    .refreshScreen(),
                                                homeController.refreshScreen(),
                                              },
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(10)),
                                              color: Colors.amber,
                                            ),
                                            child: Icon(
                                              Icons.favorite_border,
                                              color: Colors.white,
                                              size: 22,
                                            ),
                                          )
                                  )
                                      : GestureDetector(
                                          onTap: () async => {
                                                await value.onToggleWishlist(
                                                    courseStore.detail!),
                                                courseController
                                                    .refreshScreen(),
                                                homeController.refreshScreen(),
                                              },
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(10)),
                                              color: Colors.black.withOpacity(0.2),
                                            ),
                                            child: Icon(
                                              Icons.favorite_border,
                                              color: Colors.white,
                                              size: 22,
                                            ),
                                          )
                                  ),
                                ),
                                Positioned(
                                    bottom: 16,
                                    left: 16,
                                    child: SizedBox(
                                      width: screenWidth-16,
                                      child: Text(
                                        value.course.name!,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontFamily: 'Poppins-Medium',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                ),
                              ]),
                              Container(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset('assets/images/icon/icon-clock.png',color: Color(0xFFFBC815),height: 18,width: 18,),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          Helper.handleTranslationsDuration(value.course.duration!),
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                            color: Color(0xFF939393),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        value.course.count_students > 0
                                            ? Row(children: [
                                          Image.asset('assets/images/icon/icon-student.png',color: Color(0xFFFBC815),height: 16,width: 16,),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  value.course.count_students
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 12,
                                                    color: Color(0xFF939393),
                                                  ),
                                                ),
                                              ])
                                            : const SizedBox(),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        if (value.course.on_sale == true)
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (value.course
                                                      .sale_price_rendered !=
                                                  null)
                                                Text(
                                                    value.course
                                                        .sale_price_rendered!,
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ))
                                              else
                                                Text(
                                                    '\$${value.course.sale_price}',
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              if (value.course
                                                      .origin_price_rendered !=
                                                  null)
                                                Text(
                                                  value.course
                                                      .origin_price_rendered!,
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                    color: Colors.black45,
                                                    fontWeight: FontWeight.w500,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                )
                                              else
                                                Text(
                                                  '\$${value.course.origin_price}',
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                    color: Colors.black45,
                                                    fontWeight: FontWeight.w500,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                ),
                                            ],
                                          )
                                        else if (value.course.price != null &&
                                            value.course.price! > 0)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (value
                                                      .course.price_rendered !=
                                                  null)
                                                Text(
                                                  value.course.price_rendered!,
                                                  // style: styles.price,
                                                )
                                              else
                                                Text(
                                                  '\$${value.course.price}',
                                                  // style: styles.price,
                                                ),
                                            ],
                                          )
                                        else
                                          Text(
                                            tr(LocaleKeys.free),
                                            style:
                                                TextStyle(fontFamily: "medium"),
                                            // style: styles.price,
                                          ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              value.course.content != null
                                  ? (Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding:
                                              const EdgeInsets.only(left: 16),
                                          child: Text(
                                            tr(LocaleKeys.singleCourse_overview),
                                            style: const TextStyle(
                                              fontFamily: 'medium',
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsets.fromLTRB(16,10,16,0),
                                          child: HtmlWidget(
                                            value.course.content.toString(),
                                            factoryBuilder: () =>
                                                MyWidgetFactory(),
                                            textStyle: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        )
                                      ],
                                    ))
                                  : const SizedBox(),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 16, 0, 0),
                                child: Text(
                                  tr(LocaleKeys.singleCourse_curriculum),
                                  style: const TextStyle(
                                    fontFamily: 'Poppins-Medium',
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              value.course.sections != null
                                  ? Container(
                                      width: screenWidth,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 8),
                                      child: AccordionLesson(
                                          data: value.course.sections!,
                                          indexLesson:
                                              value.handleGetIndexLesson(),
                                          onNavigate: (item) => {
                                                value.onNavigateLearning(
                                                    item, 0),
                                                _scaffoldKey.currentState
                                                    ?.closeDrawer()
                                              }),
                                    )
                                  : const SizedBox(),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(
                                height: 20,
                                thickness: 0.7,
                                indent: 15,
                                endIndent: 15,
                                color: Colors.grey.shade400,
                              ),
                              Column(children: [
                                Container(
                                  width: screenWidth - 32,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 8),
                                  child: Text(
                                    tr(LocaleKeys.singleCourse_instructor),
                                    style: const TextStyle(
                                      fontFamily: 'Poppins-Medium',
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () => onNaviInstructor(value.course.instructor),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        value.course.instructor != null &&
                                                value.course
                                                        .instructor["avatar"] !=
                                                    null &&
                                                value.course
                                                        .instructor["avatar"] !=
                                                    "" &&
                                                value.course
                                                        .instructor["avatar"] !=
                                                    false
                                            ? Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(value
                                                              .course
                                                              .instructor[
                                                          "avatar"]),
                                                    )))
                                            : const CircleAvatar(
                                                radius: 25,
                                                backgroundImage: AssetImage(
                                                  'assets/images/default-avatar.png',
                                                ),
                                              ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          value.course.instructor["name"]??'',
                                          style: const TextStyle(
                                              fontFamily: 'medium',
                                             fontSize: 15,
                                            fontWeight: FontWeight.w700
                                          ),
                                            textAlign:TextAlign.center
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                                child: Icon(
                                                  FeatherIcons.facebook,
                                                  size: 16,
                                                  color: Colors.grey.shade400,
                                                ),
                                                onTap: () => {
                                                      if (value.course.instructor[
                                                                  "social"] !=
                                                              null &&
                                                          value.course.instructor[
                                                                      "social"][
                                                                  "facebook"] !=
                                                              null)
                                                        _launchUrl(value.course
                                                                    .instructor[
                                                                "social"]
                                                            ["facebook"]),
                                                    }),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            GestureDetector(
                                                child: Icon(
                                                  FeatherIcons.twitter,
                                                  size: 16,
                                                  color: Colors.grey.shade400,
                                                ),
                                                onTap: () => {
                                                      if (value.course.instructor[
                                                                  "social"] !=
                                                              null &&
                                                          value.course.instructor[
                                                                      "social"]
                                                                  ["twitter"] !=
                                                              null)
                                                        _launchUrl(value.course
                                                                    .instructor[
                                                                "social"]
                                                            ["twitter"]),
                                                    }),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            GestureDetector(
                                                child: Icon(
                                                  FeatherIcons.youtube,
                                                  size: 16,
                                                  color: Colors.grey.shade400,
                                                ),
                                                onTap: () => {
                                                      if (value.course.instructor[
                                                                  "social"] !=
                                                              null &&
                                                          value.course.instructor[
                                                                      "social"]
                                                                  ["youtube"] !=
                                                              null)
                                                        _launchUrl(value.course
                                                                    .instructor[
                                                                "social"]
                                                            ["youtube"]),
                                                    }),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        if (value.course
                                                .instructor["description"] !=
                                            null)
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(25, 10, 15, 0),
                                            alignment: Alignment.center,
                                            child: Text(
                                              value.course
                                                  .instructor["description"],
                                              style: TextStyle(
                                                  color: Colors.grey.shade500),
                                            ),
                                          ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ]),
                                ),
                              ]),
                              if (value.review != null)
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tr(LocaleKeys.singleCourse_review),
                                        style: const TextStyle(
                                          fontFamily: 'Poppins-Medium',
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Container(
                                        width: screenWidth,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                value.review["rated"]
                                                    .toStringAsFixed(1),
                                                style: const TextStyle(
                                                    color: Color(0xFFFBC815),
                                                    fontSize: 36,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              RatingBar.builder(
                                                ignoreGestures: true,
                                                initialRating: double.parse(
                                                    value.review["rated"]
                                                        .toString()),
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 20,
                                                itemBuilder: (context, _) =>
                                                    const Icon(
                                                  Icons.star,
                                                  color: Color(0xFFFBC815),
                                                ),
                                                onRatingUpdate: (rating) {
                                                  print(rating);
                                                },
                                              ),
                                              Text(
                                                value.review["total"].toString() + " " +
                                                    tr(LocaleKeys.singleCourse_rating),
                                                style: TextStyle(
                                                    color:
                                                        Colors.grey.shade500),
                                              ),
                                              SizedBox(height: 20),
                                              Text(
                                                value.reviewMessage,
                                                style: TextStyle(
                                                  color: Colors.grey.shade700,
                                                  fontSize: 12,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ]),
                                      ),
                                      SizedBox(height: 20),
                                      renderItemRating(value),
                                      renderComment(value),
                                      SizedBox(
                                        height: 40,
                                      )
                                    ],
                                  ),
                                )
                            ])),
                      ),
                    ),
                  )
                ],
              ),
              Indexed(
                index: 1,
                child: Positioned(
                  right: 0,
                  bottom: 0,
                  left: 0,
                  child: Container(
                    color: Colors.grey.shade100,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (value.course.course_data?.status == 'enrolled')
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${tr(LocaleKeys.singleCourse_average)} ${value.course.course_data?.result?.result}%',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 24), // foreground color
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: value.start,
                                      child: Row(
                                        children: [
                                          Text(tr(LocaleKeys.singleCourse_btnContinue),
                                            style: TextStyle(fontFamily: 'medium'),
                                          ),
                                          SizedBox(width: 10,),
                                          Icon(Icons.arrow_forward_outlined)
                                        ],
                                      ),
                                  ),
                                ],
                              ),
                            )
                          else if (value.course.course_data?.status ==
                              'purchased')
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.grey[800],
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 12), // foreground color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: (){

                                  if(!value.course.sections!.isEmpty){
                                    value.onEnroll();
                                  }else{
                                    DialogHelper.showErrorDialog(title: "Error", description: "The section is empty");
                                  }

                                },
                                child: Text(tr(LocaleKeys.singleCourse_btnStartNow)),
                              ),
                            )
                          else if (value.course.price != null &&
                              value.course.price! > 0 &&
                              value.course.course_data?.status == "")
                            Expanded(
                                child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.grey[800],
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 32),
                                      // foreground color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () => paymentController.handleRestoreCourse(),
                                    child: Text(tr(LocaleKeys.singleCourse_btnRestore)),
                                  ),
                                  SizedBox(width: 16),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.grey[800],
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 30),
                                      // foreground color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: (){
                                      paymentController.buyProduct(
                                          ProductDetails(id: value.course.id.toString(), title: '', description: '', price: '', rawPrice: 0, currencyCode: '')
                                      );
                                    },
                                    // addToCart(data.id.toString()),
                                    child: Text(tr(LocaleKeys.singleCourse_btnAddToCart)),
                                  ),
                                ],
                              ),
                            ))
                          else if (value.course.price == 0 &&
                              value.course.course_data?.status != 'finished')
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.grey[800],
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 12), // foreground color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: (){

                                  if(!value.course.sections!.isEmpty){
                                    value.onEnroll();
                                  }else{
                                    DialogHelper.showErrorDialog(title: "Error", description: "The section is empty");
                                  }

                                },
                                child: Text(tr(LocaleKeys.singleCourse_btnStartNow)),
                              ),
                            ),
                          if (value.course.course_data?.status == 'finished' &&
                              value.course.course_data?.graduation != null)
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    value.course.course_data?.graduation ==
                                            'passed'
                                        ? const Icon(Icons.check,
                                            color: Color(0xff25C717), size: 14)
                                        : const Icon(Icons.close,
                                            color: Color(0xff25C717), size: 14),
                                    const SizedBox(width: 8),
                                    Text(
                                      value.course.course_data?.graduation ==
                                              'passed'
                                          ? tr(LocaleKeys.singleCourse_passed)
                                          : tr(LocaleKeys.singleCourse_failed),
                                      style: const TextStyle(
                                        fontFamily: 'Poppins-Medium',
                                        fontSize: 14,
                                        color: Color(0xff25C717),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (value.course.course_data?.status == 'finished' &&
                              value.course.can_retake == true)
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.grey[800],
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 12), // foreground color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: value.onRetake,
                                child: Text(tr(LocaleKeys.singleCourse_btnRetake)),
                              ),
                            ),
                          if (value.course.course_data?.status == 'finished' &&
                              value.course.can_retake == false)
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  tr(LocaleKeys.singleCourse_finished),
                                  style: const TextStyle(
                                    fontFamily: 'medium',
                                    color: Colors.black
                                    // fontSize:
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}

class MyWidgetFactory extends WidgetFactory with WebViewFactory,JustAudioFactory {
  @override
  bool get webViewMediaPlaybackAlwaysAllow => true;
}

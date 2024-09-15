import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/controller/instructor_detail_controller.dart';
import 'package:flutter_app/app/view/components/item-course.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/get.dart';
import 'package:indexed/indexed.dart';
import 'package:url_launcher/url_launcher.dart';

class InstructorDetailScreen extends StatefulWidget {
  const InstructorDetailScreen({Key? key}) : super(key: key);

  @override
  State<InstructorDetailScreen> createState() => _InstructorDetailScreenState();
}

class _InstructorDetailScreenState extends State<InstructorDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);
  var screenHeight =
      (window.physicalSize.longestSide / window.devicePixelRatio);

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InstructorDetailController>(builder: (value) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
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
                            Get.back();
                          },
                          icon: const Icon(Icons.arrow_back),
                          color: Colors.grey[900],
                          iconSize: 24,
                        ),
                      ),
                      Text(
                        tr(LocaleKeys.instructorScreen_title),
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
                Container(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            value.instructor?.avatar_url != 'null' &&
                                    value.instructor?.avatar_url != ""
                                ? Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              value.instructor!.avatar_url!),
                                        )))
                                : const CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage(
                                      'assets/images/default-avatar.png',
                                    ),
                                  ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(value.instructor!.name!,
                                        style: const TextStyle(
                                          fontFamily: 'Medium',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        )),
                                    if (value.instructor!.description != null)
                                      Text(value.instructor!.description!,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                            color: Colors.grey,
                                          )),
                                  ],
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                                child: Icon(
                                  FeatherIcons.facebook,
                                  size: 16,
                                  color: Colors.grey.shade800,
                                ),
                                onTap: () => {
                                      if (value.instructor!.social != null &&
                                          value.instructor!
                                                  .social["facebook"] !=
                                              null)
                                        _launchUrl(value
                                            .instructor!.social["facebook"]),
                                    }),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                                child: Icon(
                                  FeatherIcons.twitter,
                                  size: 16,
                                  color: Colors.grey.shade800,
                                ),
                                onTap: () => {
                                      if (value.instructor!.social != null &&
                                          value.instructor!.social["twitter"] !=
                                              null)
                                        _launchUrl(value
                                            .instructor!.social["twitter"]),
                                    }),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                                child: Icon(
                                  FeatherIcons.youtube,
                                  size: 16,
                                  color: Colors.grey.shade800,
                                ),
                                onTap: () => {
                                      if (value.instructor!.social != null &&
                                          value.instructor!.social["youtube"] !=
                                              null)
                                        _launchUrl(value
                                            .instructor!.social["youtube"]),
                                    }),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        if (value.instructor?.instructor_data != null &&
                            value.instructor!
                                    .instructor_data["total_courses"] !=
                                null)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  value.instructor!
                                          .instructor_data["total_courses"]
                                          .toString() +
                                      " " +
                                      tr(LocaleKeys.home_countCourse),
                                  style: TextStyle(
                                    fontFamily: 'medium',
                                    fontSize: 15,
                                    color: Colors.black,
                                  )),
                              Text(
                                  value.instructor!
                                          .instructor_data["total_users"]
                                          .toString() +
                                      " " +
                                      tr(LocaleKeys.home_countStudent),
                                  style: TextStyle(
                                    fontFamily: 'medium',
                                    fontSize: 15,
                                    color: Colors.black,
                                  )),
                            ],
                          ),
                      ]),
                ),
                SizedBox(height: 15,),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => value.refreshData(),
                    child: ListView.builder(
                        controller: value.scrollController,
                        itemCount: value.coursesList.length +
                            (value.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == value.coursesList.length) {
                            return const Center(
                                child: SizedBox(
                              width: 20.0,
                              height: 20.0,
                                  child: CircularProgressIndicator(),
                            ));
                          } else if (index < value.coursesList.length) {
                            return Container(
                              margin: EdgeInsetsDirectional.only(bottom: 20),
                              child: ItemCourse(
                                item: value.coursesList[index],
                                courseDetailParser: Get.find(),
                                onToggleWishlist: () => value
                                    .onToggleWishlist(value.coursesList[index]),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

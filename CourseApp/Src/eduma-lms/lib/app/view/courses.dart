import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/controller/courses_controller.dart';
import 'package:flutter_app/app/controller/home_controller.dart';
import 'package:flutter_app/app/view/components/categories_course.dart';
import 'package:flutter_app/app/view/components/item-course.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/get.dart';
import 'package:indexed/indexed.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);
  var screenHeight =
      (window.physicalSize.longestSide / window.devicePixelRatio);
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    double top = MediaQuery.of(context).viewPadding.top;
    return GetBuilder<CoursesController>(builder: (value) {
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
                  padding: EdgeInsets.fromLTRB(16, top-10, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(width: 40),
                      Text(
                        tr(LocaleKeys.courses_title),
                        style: const TextStyle(
                          fontFamily: 'Poppins-Medium',
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                        ),
                      ),
                      GestureDetector(
                          onTap: () => {value.onSearch()},
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: const Offset(
                                        0, 1), // Thay đổi hướng đổ bóng
                                  ),
                                ],
                              ),
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.search)))
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (value.search != "")
                      Container(
                        padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(tr(LocaleKeys.courses_searching) +
                                " " +
                                value.search),
                            GestureDetector(
                              onTap: () => value.setKeywordSearch(""),
                              child: Icon(
                                Icons.close_outlined,
                                size: 20,
                              ),
                            )
                          ],
                        ),
                      ),
                    SizedBox(),
                    DropdownButton<String>(
                      hint: Container(),
                      value: value.dropdownValue,
                      iconSize: 0.0,
                      underline: Container(
                        height: 0,
                        color: Colors.deepPurpleAccent,
                      ),
                      // icon: const Icon(Icons.arrow_drop_down),
                      icon: null,
                      onChanged: (String? v) {
                        value.onFilterValue(v!);
                      },
                      items: value.list
                          .map<DropdownMenuItem<String>>((dynamic value) {
                        return DropdownMenuItem<String>(
                          value: value['key'].toString(),
                          child: Text(
                            value['label'],
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }).toList(),
                      alignment: Alignment.centerRight,
                      selectedItemBuilder: (BuildContext context) {
                        return value.list.map<Widget>((dynamic item) {
                          return Container(
                            height: 20,
                            padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                            margin: const EdgeInsets.fromLTRB(0, 16, 16, 0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Text(
                                  item['label'],
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 12),
                                ),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ],
                ),
                CategoriesCourse(categoriesList: value.cateList),
                SizedBox(
                  height: 20,
                ),
                if (value.coursesList.length > 0)
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
                                  onToggleWishlist: () async => {
                                    await value.onToggleWishlist(
                                        value.coursesList[index]),
                                    homeController.refreshScreen(),
                                  },
                                  courseDetailParser: Get.find(),
                                ),
                              );
                            } else {
                              return Container(
                                margin: EdgeInsets.only(top: 40),
                                child: Text(
                                  tr(LocaleKeys.dataNotFound),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500),
                                ),
                              );
                            }
                          }),
                    ),
                  ),
                if (value.coursesList.length < 1)
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Text(
                      tr(LocaleKeys.dataNotFound),
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  )
              ],
            ),
          ],
        ),
      );
    });
  }
}

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/controller/my_courses_controller.dart';
import 'package:flutter_app/app/helper/router.dart';
import 'package:flutter_app/app/view/components/item-my-course.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/get.dart';
import 'package:indexed/indexed.dart';
import 'dart:io' show Platform;

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({Key? key}) : super(key: key);

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void onLogin() {
    Future.delayed(Duration.zero, () {
      Get.toNamed(AppRouter.getLoginRoute());
    });
  }

  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);
  var screenHeight =
      (window.physicalSize.longestSide / window.devicePixelRatio);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyCoursesController>(builder: (value) {
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
                if(value.isSearch)
                SizedBox(height: 20,),
                Container(
                  height: 80.0,
                  width: screenWidth,
                  // color: Colors.blue,
                  padding: EdgeInsets.fromLTRB(
                      16, (Platform.isAndroid)?45:MediaQuery.of(context).viewPadding.top-10, 16, 0),
                  child: value.isSearch
                      ? Container(
                          // height: 100,
                          padding: EdgeInsets.symmetric(horizontal: 4),
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
                          child: Container(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () => value.toggleSearch(false),
                                    child: Icon(
                                      Icons.arrow_back,
                                      size: 20,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: TextField(
                                        autofocus: true,
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          color: Colors.black,
                                          // height: 1,
                                        ),
                                        textAlignVertical:
                                            TextAlignVertical.top,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: tr(LocaleKeys.searchScreen_placeholder),
                                          isDense: true,
                                          contentPadding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        ),
                                        controller: value.keywordController,
                                        onSubmitted: (_) => value.onSearch(),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => value.onSearch(),
                                    child: Icon(
                                      Icons.search_outlined,
                                      size: 20,
                                    ),
                                  )
                                ]),
                          ))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(width: 40),
                            Text(
                              tr(LocaleKeys.myCourse_title),
                              style: const TextStyle(
                                fontFamily: 'Poppins-Medium',
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                              ),
                            ),
                            value.parser.getToken() != ''
                                ? GestureDetector(
                                    onTap: () => {value.toggleSearch(true)},
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              offset: const Offset(0,
                                                  1), // Thay đổi hướng đổ bóng
                                            ),
                                          ],
                                        ),
                                        width: 40,
                                        height: 40,
                                        child: const Icon(Icons.search,size: 20,)))
                                : Container(width: 40),
                          ],
                        ),
                ),
                value.parser.getToken() == ''
                    ? Container(
                        width: screenWidth,
                        height: screenHeight * 0.7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              tr(LocaleKeys.needLogin),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: onLogin,
                              child: Text(
                                tr(LocaleKeys.login),
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                          ],
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
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
                                // This is called when the user selects an item.
                                value.onFilterValue(v!);
                              },
                              items: value.list.map<DropdownMenuItem<String>>(
                                  (value) {
                                return DropdownMenuItem<String>(
                                  value: value['key'],
                                  child: Text(
                                    value['label'],
                                    style: const TextStyle(fontSize: 10,fontFamily: 'poppins'),
                                  ).tr(),
                                );
                              }).toList(),
                              alignment: Alignment.centerRight,
                              selectedItemBuilder: (BuildContext context) {
                                return value.list.map<Widget>((item) {
                                  return Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 16, 16, 0),
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
                                              color: Colors.black,
                                              fontSize: 10,
                                              fontFamily: 'poppins'
                                              ),
                                        ),
                                        const Icon(Icons.arrow_drop_down),
                                      ],
                                    ),
                                  );
                                }).toList();
                              }),
                        ],
                      ),
                (value.parser.getToken() != '')
                    ? (value.coursesList.isNotEmpty)
                        ? Expanded(
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
                                    } else if (index <
                                        value.coursesList.length) {
                                      return ItemMyCourse(
                                        item: value.coursesList[index],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(top: 50),
                            child: Text(
                              tr(LocaleKeys.dataNotFound),
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade500),
                            ),
                          )
                    : Text(''),
              ],
            ),
          ],
        ),
      );
    });
  }
}

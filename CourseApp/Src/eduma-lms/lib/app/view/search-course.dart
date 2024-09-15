import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/controller/search_course_controller.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/get.dart';

class SearchCourseScreen extends StatefulWidget {
  SearchCourseScreen({Key? key}) : super(key: key);

  @override
  State<SearchCourseScreen> createState() => _SearchCourseScreenState();
}

class _SearchCourseScreenState extends State<SearchCourseScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);
  var screenHeight =
      (window.physicalSize.longestSide / window.devicePixelRatio);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchCourseController>(builder: (value) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Column(children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFBC815),
              ),
              padding: EdgeInsets.fromLTRB(
                  16, MediaQuery.of(context).viewPadding.top, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => value.onBack(),
                    child: const Icon(
                      Icons.close_outlined,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: Flexible(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(children: [
                          const Icon(Icons.search_outlined),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Colors.black,
                                // height: 1,
                              ),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  hintText: tr(LocaleKeys.searchScreen_placeholder),
                                  ),
                              controller: value.keywordController,
                              onSubmitted: (_) => value.onSearch(null),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              width: screenWidth - 32,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if(value.listRecentSearch.length > 0)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      tr(LocaleKeys.searchScreen_title),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  for (var item in value.listRecentSearch)
                    GestureDetector(
                      onTap: () => {value.onSearch(item)},
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          item,
                          maxLines: 1,
                          // style: styles.textRecent,
                        ),
                      ),
                    ),
                ],
              ),
            )
          ]));
    });
  }
}

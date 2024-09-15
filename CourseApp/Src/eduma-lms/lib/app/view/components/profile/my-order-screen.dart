import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/session_store.dart';
import 'package:flutter_app/app/helper/function_helper.dart';
import 'package:flutter_app/app/helper/router.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/get.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:indexed/indexed.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

typedef OnNavigateCallback = void Function(int page);

class MyOrderScreen extends StatelessWidget with GetItMixin {
  final PageController pageController;
  final OnNavigateCallback goBack;

  MyOrderScreen(
      {super.key, required this.pageController, required this.goBack});

  void onLogin() {
    Future.delayed(Duration.zero, () {
      Get.toNamed(AppRouter.getLoginRoute());
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);
  var screenHeight =
      (window.physicalSize.longestSide / window.devicePixelRatio);

  Widget renderHeader(BuildContext context) {
    return Container(
      height: 30,
      color: Colors.green,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                border: Border.symmetric(
                  vertical: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                tr(LocaleKeys.myOrders_order),
                style: TextStyle(
                  fontFamily: 'Poppins-Medium',
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                border: Border.symmetric(
                  vertical: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                tr(LocaleKeys.myOrders_date),
                style: TextStyle(
                  fontFamily: 'Poppins-Medium',
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                border: Border.symmetric(
                  vertical: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                tr(LocaleKeys.myOrders_status),
                style: TextStyle(
                  fontFamily: 'Poppins-Medium',
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                border: Border.symmetric(
                  vertical: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                tr(LocaleKeys.myOrders_total),
                style: TextStyle(
                  fontFamily: 'Poppins-Medium',
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget renderItem(BuildContext context, dynamic item, int index) {
    final backgroundColor = index % 2 == 0 ? Color(0xFFF3F3F3) : Colors.white;
    DateTime dateTime = DateTime.parse(item['Date']);
    String formattedDate = DateFormat('HH:mm dd/MM/yyyy').format(dateTime);
    return Container(
      height: 36,
      // color: backgroundColor,
      decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.grey.shade200),
          )),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                border: Border.symmetric(
                  vertical: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                item['Id'].toString(),
                style: TextStyle(
                  fontFamily: 'Poppins-Medium',
                  fontSize: 10,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                border: Border.merge(
                    Border(
                        right:
                            BorderSide(color: Colors.grey.shade200, width: 1)),
                    Border(
                        left:
                            BorderSide(color: Colors.grey.shade200, width: 0))),
              ),
              alignment: Alignment.center,
              child: Text(
                formattedDate,
                style: TextStyle(
                  fontFamily: 'Poppins-Medium',
                  fontSize: 10,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                border: Border.merge(
                    Border(
                        right:
                            BorderSide(color: Colors.grey.shade200, width: 0)),
                    Border(
                        left:
                            BorderSide(color: Colors.grey.shade200, width: 0))),
              ),
              alignment: Alignment.center,
              child: Text(
                item['Status'].toString().toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Poppins-Medium',
                  fontSize: 10,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                border: Border.symmetric(
                  vertical: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '\$${item['Total']}',
                style: TextStyle(
                  fontFamily: 'Poppins-Medium',
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessionStore = Provider.of<SessionStore>(context);
    List<Map<String, dynamic>> getData() {
      final data = sessionStore.userInfo?.tabs["orders"]["content"];
      final List<Map<String, dynamic>> result = [];

      if (!data?.isEmpty) {
        data.forEach((key, order) {
          result.add({
            'Id': order['order_key'] ?? 0,
            'Date': DateFormat('yyyy/MM/dd').format(DateTime.parse(order['date'])),
            'Status': order['status'],
            'Total': order['total'],
          });
        });
      }

      return result;
    }

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawerEnableOpenDragGesture: false,
        body: Stack(children: <Widget>[
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
                  padding: EdgeInsets.fromLTRB(
                      0, MediaQuery.of(context).viewPadding.top - 10, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        // width: 40,
                        child: IconButton(
                          onPressed: () {
                            goBack(0);
                          },
                          icon: const Icon(Icons.arrow_back),
                          color: Colors.grey[900],
                          iconSize: 24,
                        ),
                      ),
                      Expanded(
                          child: Align(
                        child: Text(
                          tr(LocaleKeys.myOrders_title),
                          style: const TextStyle(
                            fontFamily: 'medium',
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                          ),
                        ),
                      )),
                      SizedBox(
                        width: 40,
                      )
                    ],
                  ),
                ),
                getData().isEmpty
                    ? Container(
                        margin: EdgeInsets.only(top: 50),
                        alignment: Alignment.center,
                        child: Text(
                          tr(LocaleKeys.dataNotFound),
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade500),
                        ),
                      )
                    : renderItemOrders(getData())
              ]),
        ]));
  }

  Widget renderItemOrders(value) {
    return Expanded(
        child: SingleChildScrollView(
          child: ListView.builder(
          controller: ScrollController(),
          itemCount: value.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (index == value.length) {
              return const Center(
                  child: SizedBox(
                width: 20.0,
                height: 20.0,
                    child: CircularProgressIndicator(),
              ));
            } else if (index < value.length) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsetsDirectional.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tr(LocaleKeys.myOrders_order),
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  color: Color(0xFF666666)),
                            ),
                            Text(value[index]['Id'],
                                style: TextStyle(
                                    fontFamily: 'medium', fontSize: 15))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(tr(LocaleKeys.myOrders_date),
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 15,
                                    color: Color(0xFF666666))),
                            Text(value[index]['Date'],
                                style: TextStyle(
                                    fontFamily: 'medium', fontSize: 15))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(tr(LocaleKeys.myOrders_status),
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 15,
                                    color: Color(0xFF666666))),
                            Text(
                                Helper.handleTranslationsStatusOrder(
                                    value[index]['Status']).toString(),
                                style: TextStyle(
                                    fontFamily: 'medium', fontSize: 15))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(tr(LocaleKeys.myOrders_total),
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 15,
                                    color: Color(0xFF666666))),
                            Text(
                              value[index]['Total'],
                              style:
                                  TextStyle(fontFamily: 'medium', fontSize: 15),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  )
                ],
              );
            } else {
              return Container();
            }
          }),
    ));
  }

  Future<void> refreshData() async {}

  Widget renderTable(data) {
    return Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        // Disable bounces
        itemCount: data.length + 1,
        // Add 1 for the header
        itemBuilder: (context, index) {
          if (index == 0) {
            return renderHeader(context);
          } else {
            return renderItem(context, data[index - 1],
                index - 1); // Subtract 1 for the header
          }
        },
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        // To enable vertical scroll inside SingleChildScrollView
        scrollDirection: Axis.vertical,
        itemExtent: null,
        // Remove itemExtent to allow variable item heights
        addAutomaticKeepAlives:
            false, // Equivalent to removeClippedSubviews=false
      ),
    ));
  }
}

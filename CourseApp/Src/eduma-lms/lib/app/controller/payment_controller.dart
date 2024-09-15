import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:flutter_app/app/helper/dialog_helper.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rate_limiter/rate_limiter.dart';


import '../backend/parse/payment_parse.dart';
import '../helper/router.dart';

class PaymentController extends GetxController implements GetxService {
  final PaymentParser parser;
  late StreamSubscription<dynamic> _subscription;
  final InAppPurchase _connection = InAppPurchase.instance;
  String receiptData = "";
  String _productId = "";

  PaymentController({required this.parser});

  void initState() {
    Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    var context = Get.context as BuildContext;
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        DialogHelper.showLoading();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          Alert(context: context, desc: "Please check config product in Apple Store or CH Play ").show();
        } else if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored)
        {
          DialogHelper.hideLoading();

          bool valid = await verifyPurchase(purchaseDetails);

          if (valid) {
            final throttledFunction = handleCheckVerifyReceipt.throttled(
              const Duration(seconds: 5),
            );
            throttledFunction();
          }
        }
        if(purchaseDetails.status==PurchaseStatus.canceled){
          DialogHelper.hideLoading();
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  Future<void> handleCheckVerifyReceipt() async {
    try {
      final response = await parser.checkCourse(receiptData, Platform.isIOS, _productId);
      if (response.statusCode == 200 && response.body['status'] == "success") {
        //refreshData
        Get.toNamed(AppRouter.getCourseDetailRoute(),
            arguments: [_productId.toString(), "reloadPage"],
            preventDuplicates: false);
      } else {
        // throw Exception('Failed to load courses');
      }
    } catch (e) {
      print(e);
    } finally {
      refresh();
      update();
    }
  }

  Future<bool> verifyPurchase(PurchaseDetails purchaseDetails) async {
    if (Platform.isAndroid) {
      final localDataVerification =
          json.decode(purchaseDetails.verificationData.localVerificationData)
              as Map<String, dynamic>;
      final productId = localDataVerification['productId'] as String;
      receiptData = purchaseDetails.verificationData.localVerificationData;
      _productId = productId;
    } else if (Platform.isIOS) {
      final appStorePurchaseDetails =
          purchaseDetails as AppStorePurchaseDetails;
      final paymentToken =
          appStorePurchaseDetails.verificationData.localVerificationData;

      final productId = purchaseDetails.productID;
      receiptData = paymentToken;
      _productId = productId;
    }

    return Future<bool>.value(true);
  }

  @override
  void dispose() {
    // Always cancel on Dispose
    _subscription.cancel();
    super.dispose();
  }

  handleRestoreCourse() {
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

      InAppPurchase.instance.restorePurchases();
     Alert(
       context: context,
       title:  tr( LocaleKeys.alert_restorePurchases),
       desc: tr(LocaleKeys.alert_restorePurchasesError),
       buttons: [
         DialogButton(
           child: Text(
             tr(LocaleKeys.alert_cancel),
             style: TextStyle(
               color: Colors.white,
             ),
           ),
           onPressed: () => {Navigator.pop(context)},
         ),
       ]
     ).show();
    }
  }

  Future<void> buyProduct(ProductDetails prod) async {
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
      final bool isAvailable = await InAppPurchase.instance.isAvailable();
      final Set<String> ids = {prod.id.toString()};
      final ProductDetailsResponse response =
          await InAppPurchase.instance.queryProductDetails(ids);
      initState();
      if (response.notFoundIDs.isNotEmpty) {
        var context = Get.context as BuildContext;
        Alert(context: context, desc: "Please check config product in Apple Store or CH Play ").show();
      } else {
        final bool isAvailable = await _connection.isAvailable();

        if (isAvailable) {
          if (Platform.isIOS) {
            final PurchaseParam purchaseParam =
                PurchaseParam(productDetails: prod);
            await _connection.buyConsumable(purchaseParam: purchaseParam);
          } else {
            final PurchaseParam purchaseParam =
                PurchaseParam(productDetails: prod);
            await InAppPurchase.instance.buyConsumable(
                purchaseParam: purchaseParam, autoConsume: false);
          }
        }
      }
    }
  }
}

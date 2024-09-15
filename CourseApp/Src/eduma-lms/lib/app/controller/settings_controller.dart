import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/session_store.dart';
import 'package:flutter_app/app/backend/parse/settings_parse.dart';
import 'package:flutter_app/app/controller/profile_controller.dart';
import 'package:flutter_app/app/helper/function_helper.dart';
import 'package:flutter_app/app/view/tabs.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../backend/models/user_info_model.dart';
import '../helper/dialog_helper.dart';
import '../helper/router.dart';

class SettingsController extends GetxController {
  final SessionStore sessionStore;
  final SettingsParser parser;
  String st = "{}";

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController deletePasswordController = TextEditingController();

  TextEditingController nicknameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  XFile? selectedImage;
  int currentPage = 0;

  SettingsController({required this.parser, required this.sessionStore});

  @override
  void onInit() async {
    handleGetUserData();
    super.onInit();
  }

  handleGetUserData() {
    var userData = getUser();
    nicknameController.text = userData.nickname ?? "";
    bioController.text = userData.description ?? "";
    firstNameController.text = userData.last_name ?? "";
    lastNameController.text = userData.first_name ?? "";
    if (userData.avatar_url.isNotEmpty) {
      selectedImage = XFile(userData.avatar_url);
    }
    update();
  }

  void activePage(int value) {
    currentPage = value;
    update();
  }

  UserInfoModel getUser() {
    return parser.getUserInfo();
  }

  Future<void> submitPassword() async {
    var context = Get.context as BuildContext;
    final value = ProfileController(sessionStore: sessionStore,myProfileParser: Get.find());
    if (currentPasswordController.text.trim() == "") {
      Alert(
              context: context,
              title: tr(LocaleKeys.error),
              desc: tr(LocaleKeys.settings_currentPasswordIsRequired))
          .show();
      return;
    }
    if (newPasswordController.text.trim() == "") {
      Alert(
              context: context,
          title: tr(LocaleKeys.error),
          desc: tr(LocaleKeys.settings_newPasswordIsRequired))
          .show();
      return;
    }

    if (newPasswordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      Alert(
              context: context,
              title: tr(LocaleKeys.error),
              desc: tr(LocaleKeys.settings_passwordNotMatch))
          .show();
      return;
    }

    if (newPasswordController.text.trim() ==
        currentPasswordController.text.trim()) {
      Alert(
              context: context,
              title: tr(LocaleKeys.error),
              desc: tr(LocaleKeys.settings_passwordAlreadyExists))
          .show();
      return;
    }
    var param = {
      "old_password": currentPasswordController.text,
      "new_password": newPasswordController.text,
    };
    DialogHelper.showLoading();
    Response response = await parser.changePassword(param);
    DialogHelper.hideLoading();

    await Future.delayed(Duration(seconds: 1), () {
      if (response.statusCode == 200) {
        if (response.body["code"] == "success") {
          Alert(
                  context: context,
                  title: "Success",
                  desc: tr(st,args: [response.body["message"]])
          )
              .show();
          Future.delayed(Duration(seconds: 3), () {
            value.logout();
            currentPasswordController.text = "";
            newPasswordController.text = "";
            confirmPasswordController.text = "";
            Get.toNamed(AppRouter.home);
            update();
          });

        } else {
          Alert(
                  context: context,
              title: tr(LocaleKeys.error),
                  desc: tr('{}',args: [response.body["message"]]).toString()
          )
              .show();
        }
      }else{
        Alert(
            context: context,
            title: tr(LocaleKeys.error),
            desc:
            tr("{}",args: [response.body["message"]]).toString()
        )
            .show();
      }
    });
  }

  Future<void> deleteAccount() async {
    var context = Get.context as BuildContext;
    final value = ProfileController(sessionStore: sessionStore,myProfileParser: Get.find());
    var userInfo = getUser();
    if (deletePasswordController.text.trim() == "") {
      Alert(
              context: context,
          title: tr(LocaleKeys.error),
              desc: tr(LocaleKeys.settings_currentPasswordIsRequired))
          .show();
      return;
    }

    var param = {
      "id": userInfo.id,
      "password": deletePasswordController.text,
    };
    context.loaderOverlay.show();
    Response response = await parser.deleteAccount(param);
    context.loaderOverlay.hide();
    await Future.delayed(Duration(seconds: 1), () {
      if (response.statusCode == 200) {
        if (response.body["code"] == "success") {
          Alert(
                  context: context,
                  title: "Success",
                  desc: Text("{}").tr(args: [response.body["message"]]).toString()
          )
              .show();
          Future.delayed(Duration(seconds: 2),(){
            value.logout();
            Get.offAll(TabScreen());
            deletePasswordController.text = "";
            update();
          });

        } else {
          Alert(
                  context: context,
                  title: "Error",
                  desc:
                  Text("{}").tr(args: [response.body["message"]]).toString()
          )
              .show();
        }
      }
      else{
        Alert(
            context: context,
            title: "Error",
            desc:
            Text("{}").tr(args: [response.body["message"]]).toString()
        )
            .show();
      }
    });
  }

  void selectFromGallery(String kind) async {
    try {
      var file = await ImagePicker().pickImage(
        maxWidth: 1080,
        maxHeight: 1080,
        source: kind == 'gallery' ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 25,
      );
      if (file != null) {
        final croppedFile = await ImageCropper().cropImage(
            sourcePath: file.path,
            maxWidth: 250,
            maxHeight: 250,
            aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
            compressQuality: 100,
            uiSettings: [
              AndroidUiSettings(
                  toolbarTitle: 'Cropper',
                  toolbarColor: Colors.deepOrange,
                  toolbarWidgetColor: Colors.white,
                  lockAspectRatio: false),
              IOSUiSettings(title: 'Cropper',
                  aspectRatioLockEnabled: true,
                  resetAspectRatioEnabled:true,
                  rotateButtonsHidden: true,
                  rectWidth: 400,
                  rectHeight: 400
              ),
            ]);
        if (croppedFile != null) selectedImage = XFile(croppedFile.path);
      }
      update();
    } catch (e) {}
  }

  void saveGeneral() async {
    var context = Get.context as BuildContext;
    try {
      DialogHelper.showLoading();
      var map = Map<String, dynamic>();
      map['first_name'] = firstNameController.text;
      map['last_name'] = lastNameController.text;
      map['nickname'] = nicknameController.text;
      map['description'] = bioController.text;
      if (selectedImage != null && !Helper.checkHttpOrHttps(selectedImage!.path)) {
        map['lp_avatar_file'] = File(selectedImage!.path);
      }
      Response response = await parser.submitGeneral(map);
      await Future.delayed(Duration(seconds: 1), () {
        if (response.status.isOk) {
          DialogHelper.hideLoading();
          if (response.body["code"] != null) {
            Alert(
                context: context,
                title: response.body['message'],
                buttons: [
                  DialogButton(
                    child: Text(
                      tr(LocaleKeys.alert_cancel),
                      style: TextStyle(color: Colors.white, fontFamily: 'medium'),
                    ),
                    onPressed: () => {Navigator.pop(context)},
                  ),
                ],
            ).show();
          } else {

            parser.updateUserDataSharedPreferencesManager();
            refresh();
            update();
            Alert(
                context: context,
                title: tr(LocaleKeys.settings_save),
                buttons: [
                  DialogButton(
                    child: Text(
                      tr(LocaleKeys.alert_cancel),
                      style: TextStyle(color: Colors.white, fontFamily: 'medium'),
                    ),
                    onPressed: () => {Navigator.pop(context)},
                  ),
                ],
            ).show();
          }
        } else {
          DialogHelper.hideLoading();
          Alert(
              context: context,
              title: response.body['message'],
              buttons: [
              DialogButton(
                child: Text(
                  tr(LocaleKeys.alert_cancel),
                  style: TextStyle(color: Colors.white, fontFamily: 'medium'),
                ),
                onPressed: () => {Navigator.pop(context)},
              ),
            ],
          ).show();
        }

      });
    } catch (e) {
      print(e);
    } finally {
      DialogHelper.hideLoading();
    }
  }
}

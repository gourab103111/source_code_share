import 'dart:io';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/controller/settings_controller.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/get.dart';
import 'package:indexed/indexed.dart';

class GeneralAccount extends StatefulWidget {
  @override
  State<GeneralAccount> createState() => _GeneralAccountState();

  GeneralAccount({super.key});
}

class _GeneralAccountState extends State<GeneralAccount> {
  @override
  void initState() {
    settingController.handleGetUserData();
    super.initState();
  }

  final SettingsController settingController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    var screenWidth =
        (window.physicalSize.shortestSide / window.devicePixelRatio);
    var screenHeight =
        (window.physicalSize.longestSide / window.devicePixelRatio);

    return GetBuilder<SettingsController>(builder: (value) {
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
            Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: screenWidth,
                      // color: Colors.blue,
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            // width: 40,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back),
                              color: Colors.grey[900],
                              iconSize: 26,
                            ),
                          ),
                          Expanded(
                              child: Text(
                                tr(LocaleKeys.settings_general),
                                style: const TextStyle(
                                  fontFamily: 'medium',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24,
                                ),
                                textAlign: TextAlign.center,
                              )
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                               horizontal: 10),
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: value.selectedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: (value.selectedImage!.path
                                            .contains("https")
                                        ? Image.network(
                                            value.selectedImage!.path)
                                        : Image.file(File(value.selectedImage!
                                            .path)))) // Convert XFile to File
                                : Text('No image selected'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showCupertinoModalPopup<void>(
                                context: context,
                                builder: (BuildContext context) =>
                                    CupertinoActionSheet(
                                  title: Text(tr(LocaleKeys.settings_chooseFrom)),
                                  actions: <CupertinoActionSheetAction>[
                                    CupertinoActionSheetAction(
                                      isDefaultAction: true,
                                      onPressed: () {
                                        Navigator.pop(context);
                                        settingController
                                            .selectFromGallery('camera');
                                      },
                                      child: Text(tr(LocaleKeys.settings_camera)),
                                    ),
                                    CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        settingController
                                            .selectFromGallery('gallery');
                                      },
                                      child: Text(tr(LocaleKeys.settings_general)),
                                    ),
                                    CupertinoActionSheetAction(
                                      isDestructiveAction: true,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(tr(LocaleKeys.settings_cancel)),
                                    )
                                  ],
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFBC815),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              tr(LocaleKeys.settings_upload),
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tr(LocaleKeys.settings_bio),
                                style: TextStyle(
                                    fontFamily: 'medium',
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                              Icon(
                                FeatherIcons.edit2,
                                color: Color(0xFFD2D2D2),
                                size: 17,
                              ),
                            ],
                          ),
                          SizedBox(height: 14),
                          Container(
                            height: 100,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFEBEBEB)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: value.bioController,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                              maxLines: null,
                            ),
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tr(LocaleKeys.settings_firstName),
                                style: TextStyle(
                                    fontFamily: 'medium',
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                              Icon(
                                FeatherIcons.edit2,
                                color: Color(0xFFD2D2D2),
                                size: 17,
                              ),
                            ],
                          ),
                          SizedBox(height: 14),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFEBEBEB)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: value.firstNameController,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                contentPadding: new EdgeInsets.fromLTRB(
                                    10.0, 10.0, 100.0, 10.0),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                              maxLines: null,
                            ),
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tr(LocaleKeys.settings_lastName),
                                style: TextStyle(
                                    fontFamily: 'medium',
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                              Icon(
                                FeatherIcons.edit2,
                                color: Color(0xFFD2D2D2),
                                size: 17,
                              ),
                            ],
                          ),
                          SizedBox(height: 14),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFEBEBEB)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: value.lastNameController,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                contentPadding: new EdgeInsets.fromLTRB(
                                    10.0, 10.0, 100.0, 10.0),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                              maxLines: null,
                            ),
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tr(LocaleKeys.settings_nickName),
                                style: TextStyle(
                                    fontFamily: 'medium',
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                              Icon(
                                FeatherIcons.edit2,
                                color: Color(0xFFD2D2D2),
                                size: 17,
                              ),
                            ],
                          ),
                          SizedBox(height: 14),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFEBEBEB)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: value.nicknameController,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                contentPadding: new EdgeInsets.fromLTRB(
                                    10.0, 10.0, 100.0, 10.0),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                              maxLines: null,
                            ),
                          ),
                          SizedBox(height: 32),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                onPressed: () => {value.saveGeneral()},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFBC815),
                                  minimumSize: Size(double.infinity, 46),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  tr(LocaleKeys.settings_save),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ))
                  ],
                ))
          ]));
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/session_store.dart';
import 'package:flutter_app/app/backend/mobx-store/wishlist_store.dart';
import 'package:flutter_app/app/backend/parse/register_parse.dart';
import 'package:flutter_app/app/controller/home_controller.dart';
import 'package:flutter_app/app/controller/my_courses_controller.dart';
import 'package:flutter_app/app/util/toast.dart';
import 'package:flutter_app/app/view/tabs.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController implements GetxService {
  final RegisterParser parser;

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool agreedToTerms = false;
  final WishlistStore wishlistStore = Get.find<WishlistStore>();
  final SessionStore sessionStore = Get.find<SessionStore>();
  final HomeController homeController = Get.find<HomeController>();
  final MyCoursesController myCourseController = Get.find<MyCoursesController>();
  RegisterController({required this.parser});
  bool apiCalled = false;

  Future<void> register() async {
    var context = Get.context as BuildContext;
    if (usernameController.text == "") {
      showToast("Username is required", isError: true);
      return;
    }
    if (emailController.text == "") {
      showToast("Email is required", isError: true);
      return;
    }
    if (passwordController.text == "") {
      showToast("Password is required", isError: true);
      return;
    }
    if (confirmPasswordController.text == "") {
      showToast("Confirm is required", isError: true);
      return;
    }

    if (confirmPasswordController.text != passwordController.text) {
      showToast("Confirmation password incorrect!", isError: true);
      return;
    }

    if (confirmPasswordController.text != passwordController.text) {
      showToast("Confirmation password incorrect!", isError: true);
      return;
    }

    if (!agreedToTerms) {
      showToast("You must agree to the terms and conditions", isError: true);
      return;
    }

    var param = {
      "email": emailController.text,
      "username": usernameController.text,
      "password": passwordController.text,
      "confirm_password": confirmPasswordController.text
    };
    Response response = await parser.register(param);
    apiCalled = true;

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      parser.saveToken(myMap['token']);
      await parser.getUser();
      // sessionStore.setToken(myMap['token']);
      wishlistStore.getWishlist();
      myCourseController.refreshData();
      parser.saveUser(myMap['user_id'], myMap['user_login'],
          myMap['user_email'], myMap['user_display_name']);
      homeController.refreshScreen();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TabScreen()),
      );
    } else {
      showToast(response.body["message"], isError: true);
    }
  }
}

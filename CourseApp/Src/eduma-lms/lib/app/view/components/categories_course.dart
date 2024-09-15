import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/models/cate-model.dart';
import 'package:flutter_app/app/controller/courses_controller.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../helper/dialog_helper.dart';

class CategoriesCourse extends StatelessWidget {
  final List<CategoryModel> categoriesList;

  const CategoriesCourse({super.key, required this.categoriesList});

  void onNavigate() {
    // Future.delayed(Duration.zero, () {
    //   Get.toNamed(AppRouter.getLoginRoute());
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CoursesController>(builder: (value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 16, 0, 2),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Wrap(
                      direction: Axis.horizontal,
                      children: List.generate(
                          categoriesList.length,
                          (index) => InkWell(
                                highlightColor: Colors.white,
                                onTap: ()
                                    {
                                      DialogHelper.showLoading();
                                      Future.delayed(const Duration(milliseconds: 200),(){
                                        DialogHelper.hideLoading();
                                        print('data: ${categoriesList[index].toString()}');
                                        value.onFilter(categoriesList[index].id!);
                                      });

                                    },
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1.0,
                                          style: BorderStyle.solid,
                                        ),
                                        color: value.cateIds.isNotEmpty &&
                                                value.cateIds.contains(
                                                    categoriesList[index].id!)
                                            ? Colors.black
                                            : Colors.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(16))),
                                    margin:
                                        const EdgeInsets.fromLTRB(16, 0, 0, 0),
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 4, 16, 4),
                                    child: Text(
                                      categoriesList[index].name!,
                                      style: TextStyle(
                                        color: value.cateIds.isNotEmpty &&
                                                value.cateIds.contains(
                                                    categoriesList[index].id)
                                            ? Colors.white
                                            : Color(0xFF858585),
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    )),
                              ))),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}

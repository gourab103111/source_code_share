import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/models/course_model.dart';
import 'package:flutter_app/app/helper/function_helper.dart';
import 'package:flutter_app/app/helper/router.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/route_manager.dart';

class ItemMyCourse extends StatelessWidget {
  final CourseModel item;

  ItemMyCourse({super.key, required this.item});

  void onNavigate() {}
  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);

  @override
  Widget build(BuildContext context) {
    // String target = item.meta_data.lp_passing_condition;
    double target = 0;
    if (item.course_data != null &&
        item.meta_data?.lp_passing_condition != null) {
      target =
          item.meta_data!.lp_passing_condition! / 100 * (screenWidth - 132);
    }
    double progress = 0;
    if (item.course_data != null &&
        item.course_data?.result != null &&
        item.course_data?.result?.result != null) {
      progress = item.course_data!.result!.result! / 100 * (screenWidth - 132);
    }
    return GestureDetector(
        onTap: () => {
              Get.toNamed(AppRouter.getCourseDetailRoute(),
                  arguments: [item.id])
            },
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: !item.image!.contains('placeholder')?NetworkImage(
                        item.image!):Image.asset("assets/images/placeholder-500x300.png").image,
                    ), // Widget con của
                  ),
                ),
                Container(
                  width: screenWidth - 100 - 32,
                  height: 100,
                  padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.categories != null &&
                          item.categories!.isNotEmpty)
                        SizedBox(
                          width: screenWidth - 100 - 32,
                          child: Text(
                            item.categories!.map((e) => e.name).join(','),
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 10,
                                color: Colors.grey.shade600),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child:  Text(
                          item.name!,
                          maxLines: 1,
                          style: const TextStyle(
                            fontFamily: "medium",
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        width: screenWidth - 100 - 32,
                        height: 3,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3F3F3),
                        ),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Stack(
                          children: [
                            Positioned(
                              left: target,
                              child: Container(
                                height: 7,
                                width: 1,
                                color: const Color(0xFF000000),
                              ),
                            ),
                            Container(
                              width: progress,
                              decoration: BoxDecoration(
                                color: item.course_data?.graduation == 'failed'
                                    ? const Color(0xFFFF6161)
                                    : item.course_data?.graduation == 'passed'
                                        ? const Color(0xFF56C943)
                                        : const Color(0xFF58C3FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (item.course_data?.graduation == 'passed')
                                Text(
                                  tr(LocaleKeys.myCourse_filters_passed),
                                  style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12,
                                      color: Color(0xFF56C943)),
                                ),
                              if (item.course_data?.graduation == 'failed')
                                Text(
                                  tr(LocaleKeys.myCourse_filters_failed),
                                  style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12,
                                      color: Color(0xFFFF6161)),
                                ),
                              if (item.course_data?.graduation == 'in-progress')
                                Text(
                                  tr( LocaleKeys.myCourse_filters_inProgress),
                                  style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12,
                                      color: Color(0xFF58C3FF)),
                                ),
                              Text(
                                Helper.handleTranslationsDuration(item.duration.toString()),
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xFF939393)),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}

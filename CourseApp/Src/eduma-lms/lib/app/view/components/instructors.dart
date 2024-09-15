import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/models/instructor-model.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/get.dart';

import '../../helper/router.dart';

class Instructors extends StatelessWidget {
  final List<UserInstructorModel> instructorList;

  Instructors({super.key, required this.instructorList});

  void onNavigate(UserInstructorModel item) {
    Get.toNamed(AppRouter.getIntructorDetailRoute(), arguments: [item]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25),
        Container(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            tr(LocaleKeys.instructor),
            style: const TextStyle(
              fontFamily: "semibold",
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 25),
        Container(
          // height: 200,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Wrap(
                    direction: Axis.horizontal,
                    children: List.generate(
                      instructorList.length,
                      (index) => Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16))),
                          margin: const EdgeInsets.fromLTRB(16, 2, 0, 16),
                          // padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: GestureDetector(
                            onTap: () => onNavigate(instructorList[index]),
                            child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
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
                                child: Row(
                                  children: [
                                    instructorList[index].avatar_url != null &&
                                            instructorList[index].avatar_url !=
                                                ""
                                        ? Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      instructorList[index]
                                                          .avatar_url!),
                                                )))
                                        : CircleAvatar(
                                            radius: 25,
                                            backgroundImage: Image.asset(
                                              'assets/images/default-avatar.png',
                                            ).image,
                                          ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Container(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(instructorList[index].name!,
                                            style: const TextStyle(
                                                fontFamily: 'medium',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                        Row(
                                          children: [
                                            Text(LocaleKeys.instructorScreen_countCourse,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 9,
                                                  color: Colors.grey.shade600,
                                                  fontWeight: FontWeight.w300,
                                                )).tr(namedArgs: {
                                              'count': instructorList[index]
                                                  .instructor_data[
                                                      "total_courses"]
                                                  .toString()
                                            }),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Text(
                                                LocaleKeys
                                                    .instructorScreen_countStudent,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 9,
                                                  color: Colors.grey.shade600,
                                                  fontWeight: FontWeight.w300,
                                                )).tr(namedArgs: {
                                              'count': instructorList[index]
                                                  .instructor_data[
                                                      "total_users"]
                                                  .toString()
                                            }),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              FeatherIcons.send,
                                              size: 12,
                                              color: Colors.grey.shade500,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Icon(
                                              FeatherIcons.phoneCall,
                                              size: 12,
                                              color: Colors.grey.shade500,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Icon(
                                              FeatherIcons.instagram,
                                              size: 12,
                                              color: Colors.grey.shade500,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Icon(
                                              FeatherIcons.twitter,
                                              size: 12,
                                              color: Colors.grey.shade500,
                                            ),
                                          ],
                                        )
                                      ],
                                    ))
                                  ],
                                )),
                          )),
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

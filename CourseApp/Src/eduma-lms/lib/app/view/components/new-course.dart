import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/wishlist_store.dart';
import 'package:flutter_app/app/backend/models/course_model.dart';
import 'package:flutter_app/app/controller/home_controller.dart';
import 'package:flutter_app/app/helper/router.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/get.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class NewCourse extends StatelessWidget with GetItMixin {
  final List<CourseModel> newCoursesList;

  NewCourse({super.key, required this.newCoursesList});

  final WishlistStore wishlistStore = Get.find<WishlistStore>();

  void onNavigate() {}

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.only(
              left: 16,
            ),
            child: Text(
              tr(LocaleKeys.home_new),
              style: const TextStyle(
                fontFamily: "semibold",
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 25),
          Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Wrap(
                      // spacing: 8,
                      direction: Axis.horizontal,
                      children: List.generate(
                        newCoursesList.length,
                        (index) => Container(
                          width: 220,
                          padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                          child: GestureDetector(
                              onTap: () => {
                                    Get.toNamed(
                                        AppRouter.getCourseDetailRoute(),
                                        arguments: [newCoursesList[index].id])
                                  },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        width: 220,
                                        height: 134,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: !newCoursesList[index]
                                                    .image!
                                                    .contains('placeholder')
                                                ? NetworkImage(
                                                    newCoursesList[index]
                                                        .image!)
                                                : Image.asset(
                                                        "assets/images/placeholder-500x300.png")
                                                    .image,
                                          ),
                                        ),
                                      ),
                                      newCoursesList[index].on_sale == true
                                          ? Positioned(
                                              top: 10,
                                              left: 15,
                                              child: Container(
                                                width: 49,
                                                height: 21,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFFBC815),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    tr(LocaleKeys.sale),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Poppins',
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      Positioned(
                                        top: 10,
                                        right: 15,
                                        child: wishlistStore.data.any(
                                                    (element) =>
                                                        element.id ==
                                                        newCoursesList[index]
                                                            .id) ==
                                                true
                                            ? GestureDetector(
                                                onTap: () => {
                                                      value.onToggleWishlist(
                                                          newCoursesList[index])
                                                    },
                                                child: const Icon(
                                                  Icons.favorite,
                                                  color: Colors.amber,
                                                  size: 22,
                                                ))
                                            : GestureDetector(
                                                onTap: () => {
                                                      value.onToggleWishlist(
                                                          newCoursesList[index])
                                                    },
                                                child: const Icon(
                                                  Icons.favorite_border,
                                                  color: Colors.white,
                                                  size: 22,
                                                )),
                                      ),
                                      Positioned(
                                        left: 0,
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          width: 220,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              if (newCoursesList[index]
                                                      .on_sale ==
                                                  true)
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    color: Colors.white,
                                                  ),
                                                  child: Wrap(
                                                    direction: Axis.horizontal,
                                                    children: [
                                                      Text(
                                                        newCoursesList[index]
                                                                .sale_price_rendered ??
                                                            "\$${newCoursesList[index].sale_price}",
                                                        style: const TextStyle(
                                                          fontFamily: 'medium',
                                                          fontSize: 10,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        newCoursesList[index]
                                                                    .origin_price_rendered !=
                                                                ""
                                                            ? "${newCoursesList[index].origin_price_rendered}"
                                                            : "\$${newCoursesList[index].origin_price}",
                                                        style: const TextStyle(
                                                          fontFamily: 'medium',
                                                          fontSize: 10,
                                                          color: Colors.black45,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              else if (newCoursesList[index]
                                                      .price! >
                                                  0)
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    color: Colors.white,
                                                  ),
                                                  child: Text(
                                                    newCoursesList[index]
                                                            .price_rendered ??
                                                        "\$${newCoursesList[index].price}",
                                                    // style: styles.price,
                                                  ),
                                                )
                                              else
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    color: Colors.white,
                                                  ),
                                                  child: Text(
                                                    tr(LocaleKeys.free),
                                                    style: const TextStyle(
                                                      fontFamily: 'medium',
                                                      fontSize: 10,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              if (newCoursesList[index]
                                                          .rating !=
                                                      null &&
                                                  newCoursesList[index]
                                                          .rating! >
                                                      0)
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                      size: 15,
                                                    ),
                                                    Text(
                                                      newCoursesList[index]
                                                          .rating
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontFamily: 'medium',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    newCoursesList[index].name ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontFamily: 'semibold',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              )),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/wishlist_store.dart';
import 'package:flutter_app/app/backend/models/course_model.dart';
import 'package:flutter_app/app/controller/courses_controller.dart';
import 'package:flutter_app/app/controller/home_controller.dart';
import 'package:flutter_app/app/helper/router.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/get.dart';
// import 'package:get_it_mixin/get_it_mixin.dart';

class TopCourse extends StatelessWidget {
  final List<CourseModel> topCoursesList;

  TopCourse({super.key, required this.topCoursesList});

  void onNavigate() {}
  final HomeController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final CoursesController courseController = Get.find<CoursesController>();
    final WishlistStore wishlistStore = Get.find<WishlistStore>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25),
        Container(
          padding: const EdgeInsets.only(
            left: 16,
          ),
          child: Text(
            tr(LocaleKeys.home_popular),
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
                      topCoursesList.length,
                      (index) => Container(
                        width: 220,
                        padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                        child: GestureDetector(
                            onTap: () => {
                                  Get.toNamed(AppRouter.getCourseDetailRoute(),
                                      arguments: [topCoursesList[index].id])
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
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FadeInImage(
                                            image: NetworkImage(
                                                topCoursesList[index].image!),
                                            imageErrorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                  "assets/images/placeholder-500x300.png");
                                            },
                                            placeholder: Image.asset(
                                                    "assets/images/placeholder-500x300.png")
                                                .image,
                                          ).image,
                                        ),
                                      ),
                                    ),
                                    topCoursesList[index].on_sale == true
                                        ? Positioned(
                                            top: 10,
                                            left: 15,
                                            child: Container(
                                              width: 49,
                                              height: 21,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFBC815),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  tr(LocaleKeys.sale),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                    Positioned(
                                      top: 10,
                                      right: 15,
                                      child: wishlistStore.data.any((element) =>
                                                  element.id ==
                                                  topCoursesList[index].id) ==
                                              true
                                          ? GestureDetector(
                                              onTap: () async => {
                                                    await _controller
                                                        .onToggleWishlist(
                                                            topCoursesList[
                                                                index]),
                                                    courseController
                                                        .refreshScreen(),
                                                  },
                                              child: const Icon(
                                                Icons.favorite,
                                                color: Colors.amber,
                                                size: 22,
                                              ))
                                          : GestureDetector(
                                              onTap: () async => {
                                                    await _controller
                                                        .onToggleWishlist(
                                                            topCoursesList[
                                                                index]),
                                                    courseController
                                                        .refreshScreen(),
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
                                            if (topCoursesList[index].on_sale ==
                                                true)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: Colors.white,
                                                ),
                                                child: Wrap(
                                                  direction: Axis.horizontal,
                                                  children: [
                                                    Text(
                                                      topCoursesList[index]
                                                              .sale_price_rendered ??
                                                          "\$${topCoursesList[index].sale_price}",
                                                      style: const TextStyle(
                                                        fontFamily: 'semibold',
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
                                                      topCoursesList[index]
                                                                  .origin_price_rendered !=
                                                              ""
                                                          ? "${topCoursesList[index].origin_price_rendered}"
                                                          : "\$${topCoursesList[index].origin_price}",
                                                      style: const TextStyle(
                                                        fontFamily: 'semibold',
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
                                            else if (topCoursesList[index]
                                                    .price! >
                                                0)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: Colors.white,
                                                ),
                                                child: Text(
                                                  topCoursesList[index]
                                                          .price_rendered ??
                                                      "\$${topCoursesList[index].price}",
                                                  style: TextStyle(
                                                      fontFamily: 'semibold'),
                                                ),
                                              )
                                            else
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: Colors.white,
                                                ),
                                                child: Text(
                                                  tr(LocaleKeys.free),
                                                  style: const TextStyle(
                                                    fontFamily: 'semibold',
                                                    fontSize: 10,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            if (topCoursesList[index].rating! >
                                                0)
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                    size: 15,
                                                  ),
                                                  Text(
                                                    topCoursesList[index]
                                                        .rating
                                                        .toString(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontFamily: 'semibold',
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
                                  topCoursesList[index].name ?? "",
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
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/mobx-store/wishlist_store.dart';
import 'package:flutter_app/app/backend/models/course_model.dart';
import 'package:flutter_app/app/helper/function_helper.dart';
import 'package:flutter_app/app/helper/router.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/get.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import '../../backend/parse/course_detail_parse.dart';
import '../course_detail.dart';

typedef OnToggleWishlistCallback = void Function();

class ItemCourse extends StatelessWidget with GetItMixin {
  final CourseModel item;
  bool hideCategory = false;
  final CourseDetailParser courseDetailParser;

  final OnToggleWishlistCallback onToggleWishlist;

  ItemCourse(
      {super.key,
      required this.item,
      required this.onToggleWishlist,
      required this.courseDetailParser,
      hideCategory
      });

  void onNavigate() {
    Get.toNamed(AppRouter.getCourseDetailRoute(),
        arguments: [item.id], preventDuplicates: false);
  }

  final WishlistStore wishlistStore = Get.find<WishlistStore>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onNavigate(),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Stack(children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      // width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: !item.image!.contains('placeholder')
                              ? NetworkImage(item.image!)
                              : Image.asset(
                                      "assets/images/placeholder-500x300.png")
                                  .image,
                        ), // Widget con của
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 15,
                    child: wishlistStore.data
                                .any((element) => element.id == item.id) ==
                            true
                        ? GestureDetector(
                            onTap: () => {onToggleWishlist()},
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.amber,
                              ),
                              child: Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                                size: 22,
                              ),
                            )
                    )
                        : GestureDetector(
                            onTap: () => {onToggleWishlist()},
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.black.withOpacity(0.2),
                              ),
                              child: Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                                size: 22,
                              ),
                            )
                    ),
                  ),
                  item.on_sale == true
                      ? Positioned(
                          top: 10,
                          left: 15,
                          child: Container(
                            width: 49,
                            height: 21,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBC815),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text(
                                tr(LocaleKeys.sale),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'medium'),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (item.on_sale == true)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white,
                              ),
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: [
                                  Text(
                                    item.sale_price_rendered ??
                                        "\$${item.sale_price}",
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    item.origin_price_rendered != ""
                                        ? "${item.origin_price_rendered}"
                                        : "\$${item.origin_price}",
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else if (item.price! > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white,
                              ),
                              child: Text(
                                item.price_rendered ?? "\$${item.price}",
                                style: TextStyle(
                                  fontFamily: 'medium',
                                  fontSize: 14
                                ),
                                // style: styles.price,
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white,
                              ),
                              child: Text(
                                tr(LocaleKeys.free),
                                style: const TextStyle(
                                  fontFamily: 'medium',
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          if (item.rating! > 0)
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  item.rating.toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'medium',
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ]),
                if (item.categories != null && item.categories!.isNotEmpty && !hideCategory)
                  Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      width: double.infinity,
                      child: Text(
                        item.categories!.map((e) => e.name).join(','),
                        style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'poppins',
                            color: Color(0xFF939393)),
                      )),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name!,
                          maxLines: 2,
                          style: const TextStyle(
                            fontFamily: "medium",
                            fontSize: 16,
                          ),
                        )
                      ]),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/icon/icon-clock.png',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        tr(LocaleKeys.durations),
                        style: const TextStyle(
                          fontFamily: 'medium',
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        Helper.handleTranslationsDuration(item.duration.toString()),
                        style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'poppins',
                            color: Color(0xFF939393)),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}

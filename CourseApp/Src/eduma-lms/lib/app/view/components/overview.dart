import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/helper/router.dart';
import 'package:flutter_app/l10n/locale_keys.g.dart';
import 'package:get/route_manager.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Overview extends StatelessWidget {
  final dynamic overview;
  const Overview({super.key, required this.overview});

  void onNavigate() {

  }

  @override
  Widget build(BuildContext context) {

    double lessonRate = double.parse(overview["course_data"]["result"]["items"].isNotEmpty?overview["course_data"]["result"]["items"]
                ['lesson']['completed']
            .toString():'0') /
        double.parse(overview["course_data"]["result"]["items"].isNotEmpty?overview["course_data"]["result"]["items"]["lesson"]
                ['total']
            .toString():'0');
    double quizRate = double.parse(overview["course_data"]["result"]["items"].isNotEmpty?overview["course_data"]["result"]["items"]
                ['quiz']['completed']
            .toString():'0') /
        double.parse(overview["course_data"]["result"]["items"].isNotEmpty?overview["course_data"]["result"]["items"]["quiz"]['total']
            .toString():'0');
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child:
                  Text(tr(LocaleKeys.home_overview_title)),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                child: CircularPercentIndicator(
                  radius: 40,
                  percent:
                      (overview["course_data"]["result"]["result"].round() /
                          100),
                  lineWidth: 8,
                  backgroundColor: Colors.grey.shade100,
                  progressColor: const Color(0xFF958CFF),
                  center: Text(
                    "${overview["course_data"]["result"]["result"].round()}%",
                    style: const TextStyle(
                        fontSize: 16, fontFamily: "semibold"),
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 22),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.book_outlined,
                          size: 20,
                          color: Color(0xFFFFD336),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                          tr(LocaleKeys.lesson),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: (150 / 375) *
                                  MediaQuery.of(context).size.width,
                              height: 6,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor:
                                    lessonRate.isNaN ? 0.0 : lessonRate,
                                child: Container(
                                  height: 4,
                                  color: const Color(0xFFFFD336),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 22),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30,child: Icon(
                          Icons.help_outline,
                          size: 20,
                          color: Color(0xFF41DBD2),
                        )),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                            tr(LocaleKeys.quiz),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: (150 / 375) *
                                  MediaQuery.of(context).size.width,
                              height: 6,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: quizRate.isNaN ? 0.0 : quizRate,
                                child: Container(
                                  height: 4,
                                  color: const Color(0xFF41DBD2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (overview["course_data"]["result"]["items"].isNotEmpty&&overview["course_data"]["result"]["items"]
                              ["assignment"] !=
                          null &&
                      overview["course_data"]["result"]["items"]["assignment"]
                              ['total'] !=
                          null &&
                      double.parse(overview["course_data"]["result"]["items"]
                                  ["assignment"]['total']
                              .toString()) >
                          0)
                    Container(
                      margin: const EdgeInsets.only(bottom: 22),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 30,child:  Icon(
                            Icons.hourglass_empty,
                            size: 20,
                            color: Color(0xFF958CFF),
                          )),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                tr(LocaleKeys.assignment),
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: (150 / 375) *
                                    MediaQuery.of(context).size.width,
                                height: 6,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: (double.parse(
                                              overview["course_data"]
                                                      ["result"]["items"]
                                                  ['assignment']['completed'].toString()) /
                                          double.parse(overview["course_data"]
                                                      ["result"]["items"]
                                                  ["assignment"]['total']
                                              .toString()) ??
                                      0.0),
                                  child: Container(
                                    height: 4,
                                    color: const Color(0xFF958CFF),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              )
            ]),
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRouter.getCourseDetailRoute(),
                    arguments: [overview["id"]]);
              },
              child: Container(
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(overview["name"] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        )),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      '${overview["sections"].length} ${overview?["sections"].length > 1 ? tr(LocaleKeys.home_overview_sections).toUpperCase() : tr(LocaleKeys.home_overview_section).toUpperCase()}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'poppins-extraLight',
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
    );
  }
}

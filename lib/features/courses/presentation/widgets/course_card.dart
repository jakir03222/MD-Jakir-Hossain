import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../data/models/course_model.dart';
import 'cached_banner_image.dart';
import 'course_stats_row.dart';
import 'discount_countdown.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 1.5,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Get.toNamed(
            AppRoutes.courseDetails,
            arguments: course.id,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'course-banner-${course.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedBannerImage(imageUrl: course.banner),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                      height: 1.3,
                    ),
                  ),
                  if (course.subTitle.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      course.subTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                        height: 1.35,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  CoursePriceText(course: course),
                  const SizedBox(height: 8),
                  DiscountCountdown(course: course),
                  const SizedBox(height: 10),
                  CourseStatsRow(
                    durationInMonth: course.durationInMonth,
                    totalClass: course.totalClass,
                    totalExam: course.totalExam,
                    totalLive: course.totalLive,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

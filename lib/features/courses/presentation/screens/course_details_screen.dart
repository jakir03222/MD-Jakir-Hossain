import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/discount/i_discount_evaluator.dart';
import '../../logic/course_controller.dart';
import '../widgets/cached_banner_image.dart';
import '../widgets/course_stats_row.dart';
import '../widgets/discount_countdown.dart';

class CourseDetailsScreen extends GetView<CourseController> {
  const CourseDetailsScreen({super.key});

  static final _currency = NumberFormat.currency(
    locale: 'en_BD',
    symbol: '৳',
    decimalDigits: 0,
  );

  IDiscountEvaluator get _evaluator => Get.find<IDiscountEvaluator>();

  @override
  Widget build(BuildContext context) {
    final arg = Get.arguments;
    final id = arg is int ? arg : int.tryParse(arg?.toString() ?? '') ?? 0;
    final course = controller.findById(id);

    if (course == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Course Details'),
          backgroundColor: const Color(0xFF0F766E),
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text('Course not found')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: const Color(0xFF0F766E),
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                course.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              background: Hero(
                tag: 'course-banner-${course.id}',
                child: CachedBannerImage(
                  imageUrl: course.banner,
                  iconSize: 40,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      height: 1.3,
                    ),
                  ),
                  if (course.subTitle.trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      course.subTitle,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF64748B),
                        height: 1.45,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  CoursePriceText(course: course),
                  const SizedBox(height: 10),
                  DiscountCountdown(course: course),
                  const SizedBox(height: 20),
                  const Text(
                    'Course overview',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CourseStatsRow(
                    durationInMonth: course.durationInMonth,
                    totalClass: course.totalClass,
                    totalExam: course.totalExam,
                    totalLive: course.totalLive,
                  ),
                  const SizedBox(height: 24),
                  _InfoRow(
                    label: 'Course ID',
                    value: course.id.toString(),
                  ),
                  _InfoRow(
                    label: 'Original price',
                    value: _currency.format(course.price),
                  ),
                  Obx(() {
                    final active =
                        _evaluator.isActive(course, controller.now.value);
                    return _InfoRow(
                      label: 'Discount',
                      value: active
                          ? 'Active (${_currency.format(course.discountAmount)} off)'
                          : 'Not active',
                    );
                  }),
                  _InfoRow(
                    label: 'Enrollment',
                    value: course.orderStatus == 'true' ? 'Enrolled' : 'Open',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}

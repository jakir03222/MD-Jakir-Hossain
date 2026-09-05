import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/discount/i_discount_evaluator.dart';
import '../../data/models/course_model.dart';
import '../../logic/course_controller.dart';

/// Isolated Obx so only this countdown rebuilds every second — not the list.
class DiscountCountdown extends GetView<CourseController> {
  const DiscountCountdown({super.key, required this.course});

  final CourseModel course;

  IDiscountEvaluator get _evaluator => Get.find<IDiscountEvaluator>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final current = controller.now.value;
      final remaining = _evaluator.remaining(course, current);
      if (remaining == null) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1E8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.timer_outlined,
              size: 16,
              color: Color(0xFFE85D04),
            ),
            const SizedBox(width: 6),
            Text(
              'Offer ends in ${_format(remaining)}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE85D04),
              ),
            ),
          ],
        ),
      );
    });
  }

  String _format(Duration remaining) {
    final days = remaining.inDays;
    final hours = remaining.inHours.remainder(24);
    final minutes = remaining.inMinutes.remainder(60);
    final seconds = remaining.inSeconds.remainder(60);

    if (days > 0) {
      return '${days}d ${hours.toString().padLeft(2, '0')}h '
          '${minutes.toString().padLeft(2, '0')}m';
    }
    return '${hours.toString().padLeft(2, '0')}h '
        '${minutes.toString().padLeft(2, '0')}m '
        '${seconds.toString().padLeft(2, '0')}s';
  }
}

class CoursePriceText extends GetView<CourseController> {
  const CoursePriceText({super.key, required this.course});

  final CourseModel course;

  IDiscountEvaluator get _evaluator => Get.find<IDiscountEvaluator>();

  static final _currency = NumberFormat.currency(
    locale: 'en_BD',
    symbol: '৳',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final current = controller.now.value;
      final active = _evaluator.isActive(course, current);

      if (!active) {
        return Text(
          _currency.format(course.price),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F766E),
          ),
        );
      }

      return Row(
        children: [
          Text(
            _currency.format(_evaluator.discountedPrice(course)),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F766E),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _currency.format(course.price),
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF94A3B8),
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      );
    });
  }
}

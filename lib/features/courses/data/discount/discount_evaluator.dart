import '../models/course_model.dart';
import 'i_discount_evaluator.dart';
import 'i_discount_strategy_factory.dart';

class DiscountEvaluator implements IDiscountEvaluator {
  DiscountEvaluator({required this.strategyFactory});

  final IDiscountStrategyFactory strategyFactory;

  @override
  bool isActive(CourseModel course, DateTime now) {
    if (course.discountAmount <= 0) return false;
    if (course.discountStartDate == null || course.discountEndDate == null) {
      return false;
    }
    return !now.isBefore(course.discountStartDate!) &&
        !now.isAfter(course.discountEndDate!);
  }

  @override
  num discountedPrice(CourseModel course) {
    final strategy = strategyFactory.create(course.discountType);
    return strategy.calculate(
      price: course.price,
      discountAmount: course.discountAmount,
    );
  }

  @override
  num displayPrice(CourseModel course, DateTime now) {
    return isActive(course, now) ? discountedPrice(course) : course.price;
  }

  @override
  Duration? remaining(CourseModel course, DateTime now) {
    if (!isActive(course, now) || course.discountEndDate == null) return null;
    final diff = course.discountEndDate!.difference(now);
    if (diff.isNegative || diff.inSeconds <= 0) return null;
    return diff;
  }
}

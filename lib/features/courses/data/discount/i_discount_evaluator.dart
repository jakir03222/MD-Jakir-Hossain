import '../models/course_model.dart';

/// Evaluates discount window + price (Single Responsibility).
abstract class IDiscountEvaluator {
  bool isActive(CourseModel course, DateTime now);

  num discountedPrice(CourseModel course);

  num displayPrice(CourseModel course, DateTime now);

  Duration? remaining(CourseModel course, DateTime now);
}

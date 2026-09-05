import 'package:get/get.dart';

import '../../features/courses/binding/course_binding.dart';
import '../../features/courses/presentation/screens/course_details_screen.dart';
import '../../features/courses/presentation/screens/home_screen.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: CourseBinding(),
    ),
    GetPage(
      name: AppRoutes.courseDetails,
      page: () => const CourseDetailsScreen(),
      // Reuses CourseBinding deps already registered from Home.
      transition: Transition.cupertino,
    ),
  ];
}

import '../models/course_model.dart';

/// Repository contract used by presentation/logic layers.
abstract class ICourseRepository {
  Future<List<CourseModel>> fetchHomeCourses();

  List<CourseModel> readCachedCourses();

  Future<void> cacheCourses(List<CourseModel> courses);
}

import '../models/course_model.dart';

abstract class ICourseLocalDataSource {
  List<CourseModel> readCachedCourses();

  Future<void> cacheCourses(List<CourseModel> courses);
}

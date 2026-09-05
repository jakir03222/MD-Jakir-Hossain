import '../models/course_model.dart';

abstract class ICourseRemoteDataSource {
  Future<List<CourseModel>> fetchHomeCourses();
}

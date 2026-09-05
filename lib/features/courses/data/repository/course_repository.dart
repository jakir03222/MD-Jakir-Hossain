import '../datasources/i_course_local_data_source.dart';
import '../datasources/i_course_remote_data_source.dart';
import '../models/course_model.dart';
import 'i_course_repository.dart';

class CourseRepository implements ICourseRepository {
  CourseRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final ICourseRemoteDataSource remoteDataSource;
  final ICourseLocalDataSource localDataSource;

  @override
  Future<List<CourseModel>> fetchHomeCourses() {
    return remoteDataSource.fetchHomeCourses();
  }

  @override
  List<CourseModel> readCachedCourses() {
    return localDataSource.readCachedCourses();
  }

  @override
  Future<void> cacheCourses(List<CourseModel> courses) {
    return localDataSource.cacheCourses(courses);
  }
}

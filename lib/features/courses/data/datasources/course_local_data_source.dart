import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/i_local_storage.dart';
import '../banner/i_banner_url_resolver.dart';
import '../models/course_model.dart';
import 'i_course_local_data_source.dart';

class CourseLocalDataSource implements ICourseLocalDataSource {
  CourseLocalDataSource({
    required this.storage,
    required this.bannerUrlResolver,
  });

  final ILocalStorage storage;
  final IBannerUrlResolver bannerUrlResolver;

  @override
  List<CourseModel> readCachedCourses() {
    final cached = storage.read(ApiConstants.coursesCacheKey);
    if (cached is! List) return const [];

    return cached.whereType<Map>().map((item) {
      final json = Map<String, dynamic>.from(item);
      final banner = (json['banner'] ?? '').toString();
      json['banner'] = bannerUrlResolver.resolve(banner);
      return CourseModel.fromJson(json);
    }).toList();
  }

  @override
  Future<void> cacheCourses(List<CourseModel> courses) {
    return storage.write(
      ApiConstants.coursesCacheKey,
      courses.map((course) => course.toJson()).toList(),
    );
  }
}

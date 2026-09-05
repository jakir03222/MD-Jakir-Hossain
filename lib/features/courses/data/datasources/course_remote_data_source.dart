import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/i_api_client.dart';
import '../banner/i_banner_url_resolver.dart';
import '../models/course_model.dart';
import 'i_course_remote_data_source.dart';

class CourseRemoteDataSource implements ICourseRemoteDataSource {
  CourseRemoteDataSource({
    required this.apiClient,
    required this.bannerUrlResolver,
  });

  final IApiClient apiClient;
  final IBannerUrlResolver bannerUrlResolver;

  @override
  Future<List<CourseModel>> fetchHomeCourses() async {
    final response = await apiClient.get(ApiConstants.homeCourses);
    final data = response.data;

    final List<dynamic> list;
    if (data is Map<String, dynamic>) {
      list = (data['courses'] as List<dynamic>?) ?? const [];
    } else if (data is List) {
      list = data;
    } else {
      list = const [];
    }

    return list.whereType<Map>().map((item) {
      final json = Map<String, dynamic>.from(item);
      final banner = (json['banner'] ?? '').toString();
      json['banner'] = bannerUrlResolver.resolve(banner);
      return CourseModel.fromJson(json);
    }).toList();
  }
}

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/connectivity_plus_service.dart';
import '../../../core/network/i_api_client.dart';
import '../../../core/network/i_connectivity_service.dart';
import '../../../core/storage/get_storage_local_storage.dart';
import '../../../core/storage/i_local_storage.dart';
import '../../../core/time/i_clock.dart';
import '../data/banner/i_banner_url_resolver.dart';
import '../data/datasources/course_local_data_source.dart';
import '../data/datasources/course_remote_data_source.dart';
import '../data/datasources/i_course_local_data_source.dart';
import '../data/datasources/i_course_remote_data_source.dart';
import '../data/discount/discount_evaluator.dart';
import '../data/discount/i_discount_evaluator.dart';
import '../data/discount/i_discount_strategy_factory.dart';
import '../data/repository/course_repository.dart';
import '../data/repository/i_course_repository.dart';
import '../logic/course_controller.dart';

/// Wires abstractions → concrete implementations (Dependency Inversion).
class CourseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IClock>(() => SystemClock());
    Get.lazyPut<ILocalStorage>(() => GetStorageLocalStorage());
    Get.lazyPut<IConnectivityService>(() => ConnectivityPlusService());
    Get.lazyPut<IBannerUrlResolver>(() => BiddabariBannerUrlResolver());

    Get.lazyPut<IApiClient>(
      () => DioApiClient(
        dio: Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 20),
          ),
        ),
      ),
    );

    Get.lazyPut<IDiscountStrategyFactory>(() => DiscountStrategyFactory());
    Get.lazyPut<IDiscountEvaluator>(
      () => DiscountEvaluator(strategyFactory: Get.find()),
    );

    Get.lazyPut<ICourseRemoteDataSource>(
      () => CourseRemoteDataSource(
        apiClient: Get.find(),
        bannerUrlResolver: Get.find(),
      ),
    );
    Get.lazyPut<ICourseLocalDataSource>(
      () => CourseLocalDataSource(
        storage: Get.find(),
        bannerUrlResolver: Get.find(),
      ),
    );
    Get.lazyPut<ICourseRepository>(
      () => CourseRepository(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
      ),
    );

    Get.lazyPut<CourseController>(
      () => CourseController(
        repository: Get.find(),
        connectivityService: Get.find(),
        clock: Get.find(),
      ),
      fenix: true,
    );
  }
}

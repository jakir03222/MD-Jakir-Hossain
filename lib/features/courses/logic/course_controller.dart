import 'dart:async';

import 'package:get/get.dart';

import '../../../core/network/i_connectivity_service.dart';
import '../../../core/time/i_clock.dart';
import '../data/models/course_model.dart';
import '../data/repository/i_course_repository.dart';

class CourseController extends GetxController {
  CourseController({
    required this.repository,
    required this.connectivityService,
    required this.clock,
  });

  final ICourseRepository repository;
  final IConnectivityService connectivityService;
  final IClock clock;

  final courses = <CourseModel>[].obs;
  final isOffline = false.obs;
  final now = DateTime.now().obs;

  /// Reactive status for Loading / Success / Empty / Error
  final Rx<RxStatus> status = RxStatus.loading().obs;

  StreamSubscription<bool>? _connectivitySub;
  Timer? _ticker;
  bool _fetchInFlight = false;

  @override
  void onInit() {
    super.onInit();
    now.value = clock.now();
    _startTicker();
    _listenConnectivity();
    _bootstrap();
  }

  @override
  void onClose() {
    _ticker?.cancel();
    _connectivitySub?.cancel();
    super.onClose();
  }

  void _startTicker() {
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      now.value = clock.now();
    });
  }

  Future<void> _bootstrap() async {
    final cached = repository.readCachedCourses();
    if (cached.isNotEmpty) {
      courses.assignAll(cached);
      status.value = RxStatus.success();
    } else {
      status.value = RxStatus.loading();
    }

    await _refreshConnectivity();
    await fetchCourses(showLoading: cached.isEmpty);
  }

  Future<void> _listenConnectivity() async {
    await _refreshConnectivity();
    _connectivitySub = connectivityService.onStatusChanged.listen((online) {
      final wasOffline = isOffline.value;
      isOffline.value = !online;

      if (wasOffline && online) {
        fetchCourses(showLoading: courses.isEmpty);
      }
    });
  }

  Future<void> _refreshConnectivity() async {
    isOffline.value = !(await connectivityService.isOnline);
  }

  Future<void> fetchCourses({bool showLoading = true}) async {
    if (_fetchInFlight) return;
    _fetchInFlight = true;

    if (showLoading && courses.isEmpty) {
      status.value = RxStatus.loading();
    }

    try {
      final remote = await repository.fetchHomeCourses();
      courses.assignAll(remote);
      await repository.cacheCourses(remote);

      if (remote.isEmpty) {
        status.value = RxStatus.empty();
      } else {
        status.value = RxStatus.success();
      }
    } catch (e) {
      if (courses.isEmpty) {
        status.value = RxStatus.error(e.toString());
      } else {
        Get.snackbar(
          'Sync failed',
          'Showing cached courses. Pull to retry.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } finally {
      _fetchInFlight = false;
    }
  }

  Future<void> onRefresh() => fetchCourses(showLoading: false);

  CourseModel? findById(int id) {
    try {
      return courses.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}

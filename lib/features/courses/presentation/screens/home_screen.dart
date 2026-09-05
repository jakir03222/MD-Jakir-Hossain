import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../logic/course_controller.dart';
import '../widgets/course_card.dart';

/// Home tab — course discovery list (assignment API + Q1/Q2 features).
class HomeScreen extends GetView<CourseController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Biddabari',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.2),
        ),
        backgroundColor: const Color(0xFF0F766E),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Obx(() {
            if (!controller.isOffline.value) return const SizedBox.shrink();
            return const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.wifi_off_rounded, size: 20),
            );
          }),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            if (!controller.isOffline.value) return const SizedBox.shrink();
            return const Material(
              color: Color(0xFFFEF3C7),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      size: 18,
                      color: Color(0xFFB45309),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You are offline. Showing cached courses when available.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF92400E),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              'Home',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              'Discover live batches and offers',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
          ),
          Expanded(
            child: Obx(() {
              final rxStatus = controller.status.value;

              if (rxStatus.isLoading && controller.courses.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF0F766E)),
                );
              }

              if (rxStatus.isError && controller.courses.isEmpty) {
                return _MessageState(
                  icon: Icons.error_outline,
                  title: 'Something went wrong',
                  subtitle: rxStatus.errorMessage ?? 'Failed to load courses',
                  actionLabel: 'Retry',
                  onAction: () => controller.fetchCourses(),
                );
              }

              if (rxStatus.isEmpty ||
                  (rxStatus.isSuccess && controller.courses.isEmpty)) {
                return _MessageState(
                  icon: Icons.school_outlined,
                  title: 'No courses found',
                  subtitle: 'Pull down to refresh or try again later.',
                  actionLabel: 'Refresh',
                  onAction: () => controller.fetchCourses(),
                );
              }

              return RefreshIndicator(
                color: const Color(0xFF0F766E),
                onRefresh: controller.onRefresh,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: controller.courses.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    return CourseCard(course: controller.courses[index]);
                  },
                ),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        indicatorColor: const Color(0xFFCCFBF1),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onDestinationSelected: (index) {
          if (index == 1) {
            Get.snackbar(
              'Profile',
              'Out of scope for this technical test.',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
            );
          }
        },
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: const Color(0xFF94A3B8)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onAction,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0F766E),
              ),
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}

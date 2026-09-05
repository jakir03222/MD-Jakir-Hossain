import 'package:flutter/material.dart';

class CourseStatsRow extends StatelessWidget {
  const CourseStatsRow({
    super.key,
    required this.durationInMonth,
    required this.totalClass,
    required this.totalExam,
    required this.totalLive,
  });

  final String durationInMonth;
  final String totalClass;
  final int totalExam;
  final int totalLive;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _StatChip(icon: Icons.calendar_month_outlined, label: '$durationInMonth mo'),
        _StatChip(icon: Icons.menu_book_outlined, label: '$totalClass class'),
        _StatChip(icon: Icons.quiz_outlined, label: '$totalExam exam'),
        _StatChip(icon: Icons.videocam_outlined, label: '$totalLive live'),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF475569)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }
}

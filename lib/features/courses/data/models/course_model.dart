/// Pure data model — JSON only (Single Responsibility).
class CourseModel {
  const CourseModel({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.price,
    required this.banner,
    required this.discountType,
    required this.discountAmount,
    required this.discountStartDate,
    required this.discountEndDate,
    required this.durationInMonth,
    required this.totalClass,
    required this.totalExam,
    required this.totalLive,
    required this.orderStatus,
  });

  final int id;
  final String title;
  final String subTitle;
  final num price;
  final String banner;
  final int discountType;
  final num discountAmount;
  final DateTime? discountStartDate;
  final DateTime? discountEndDate;
  final String durationInMonth;
  final String totalClass;
  final int totalExam;
  final int totalLive;
  final String orderStatus;

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: _asInt(json['id']),
      title: (json['title'] ?? '').toString(),
      subTitle: (json['sub_title'] ?? '').toString(),
      price: _asNum(json['price']),
      banner: (json['banner'] ?? '').toString(),
      discountType: _asInt(json['discount_type']),
      discountAmount: _asNum(json['discount_amount']),
      discountStartDate: _parseDate(json['discount_start_date']),
      discountEndDate: _parseDate(json['discount_end_date']),
      durationInMonth: (json['duration_in_month'] ?? '').toString(),
      totalClass: (json['total_class'] ?? '').toString(),
      totalExam: _asInt(json['total_exam']),
      totalLive: _asInt(json['total_live']),
      orderStatus: (json['order_status'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'sub_title': subTitle,
      'price': price,
      'banner': banner,
      'discount_type': discountType,
      'discount_amount': discountAmount,
      'discount_start_date': _formatDate(discountStartDate),
      'discount_end_date': _formatDate(discountEndDate),
      'duration_in_month': durationInMonth,
      'total_class': totalClass,
      'total_exam': totalExam,
      'total_live': totalLive,
      'order_status': orderStatus,
    };
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static num _asNum(dynamic value) {
    if (value is num) return value;
    return num.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    final raw = value.toString().trim();
    if (raw.isEmpty) return null;
    return DateTime.tryParse(raw.replaceFirst(' ', 'T'));
  }

  static String? _formatDate(DateTime? value) {
    if (value == null) return null;
    final y = value.year.toString().padLeft(4, '0');
    final m = value.month.toString().padLeft(2, '0');
    final d = value.day.toString().padLeft(2, '0');
    final h = value.hour.toString().padLeft(2, '0');
    final min = value.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $h:$min';
  }
}

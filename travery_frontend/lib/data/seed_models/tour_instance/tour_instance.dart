/// Tour Instance model - represents a specific scheduled tour departure
///
/// API Response format:
/// {
///   "id": "uuid",
///   "startDate": "2026-05-25",
///   "endDate": "2026-05-27",
///   "status": "PLANNING",
///   "availableSlots": 20
/// }
class TourInstance {
  const TourInstance({
    this.id,
    required this.startDate,
    required this.endDate,
    this.status = TourInstanceStatus.PLANNING,
    this.availableSlots = 0,
  });

  final String? id;

  /// Date as string in "yyyy-MM-dd" format (e.g. "2026-05-25")
  final String startDate;

  /// Date as string in "yyyy-MM-dd" format (e.g. "2026-05-27")
  final String endDate;

  final TourInstanceStatus status;
  final int availableSlots;

  factory TourInstance.fromJson(Map<String, dynamic> json) {
    // Handle startDate - can be DateTime ISO string or plain date string
    String parseDate(dynamic value) {
      if (value == null) return '';
      if (value is String) return value.split('T').first;
      if (value is DateTime) {
        return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
      }
      return '';
    }

    final startDateStr = parseDate(json['startDate']);
    final endDateStr = parseDate(json['endDate']);

    return TourInstance(
      id: json['id'] as String?,
      startDate: startDateStr.isEmpty ? '1970-01-01' : startDateStr,
      endDate: endDateStr.isEmpty ? '1970-01-01' : endDateStr,
      status: _parseStatus(json['status']),
      availableSlots: (json['availableSlots'] as num?)?.toInt() ?? 0,
    );
  }

  static TourInstanceStatus _parseStatus(dynamic value) {
    if (value == null) return TourInstanceStatus.PLANNING;
    final str = value.toString().toUpperCase();
    return TourInstanceStatus.values.firstWhere(
      (e) => e.name == str,
      orElse: () => TourInstanceStatus.PLANNING,
    );
  }
}

enum TourInstanceStatus {
  PLANNING,
  OPEN,
  FULL,
  IN_PROGRESS,
  COMPLETED,
  CANCELLED,
  POSTPONED,
}

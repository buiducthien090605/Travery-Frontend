class CancelBookingData {
  final String bookingId;
  final double refundAmount;
  final String refundMethod;
  final String refundStatus;
  final String processedAt;

  CancelBookingData({
    required this.bookingId,
    this.refundAmount = 0,
    this.refundMethod = '',
    this.refundStatus = '',
    this.processedAt = '',
  });

  factory CancelBookingData.fromJson(Map<String, dynamic> json) {
    return CancelBookingData(
      bookingId: json['bookingId'] ?? '',
      refundAmount: (json['refundAmount'] ?? 0).toDouble(),
      refundMethod: json['refundMethod'] ?? '',
      refundStatus: json['refundStatus'] ?? '',
      processedAt: json['processedAt'] ?? '',
    );
  }
}

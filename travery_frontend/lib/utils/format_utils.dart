import 'package:intl/intl.dart';

class FormatUtils {
  FormatUtils._();

  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDateString(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return dateString;
    }
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }
}

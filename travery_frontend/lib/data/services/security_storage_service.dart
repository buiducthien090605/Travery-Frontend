import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurityStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _accessToken = 'access_token';
  static const String _refreshToken = 'refresh_token';
  static const String _pendingPayment = 'pending_payment';

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessToken, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessToken);
  }

  Future<void> deleteAccessToken() async {
    await _storage.delete(key: _accessToken);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshToken);
  }

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _refreshToken);
  }

  Future<void> deleteAllTokens() async {
    await _storage.delete(key: _accessToken);
    await _storage.delete(key: _refreshToken);
  }

  /// Lưu thông tin payment đang chờ xử lý (để khôi phục khi app quay lại từ deep link)
  Future<void> savePendingPayment({
    required String bookingId,
    required String txnRef,
    required double amount,
  }) async {
    final data = jsonEncode({
      'bookingId': bookingId,
      'txnRef': txnRef,
      'amount': amount,
      'timestamp': DateTime.now().toIso8601String(),
    });
    await _storage.write(key: _pendingPayment, value: data);
  }

  /// Đọc thông tin payment đang chờ
  Future<Map<String, dynamic>?> getPendingPayment() async {
    final data = await _storage.read(key: _pendingPayment);
    if (data == null) return null;
    return jsonDecode(data) as Map<String, dynamic>;
  }

  /// Xóa thông tin payment đã xử lý
  Future<void> clearPendingPayment() async {
    await _storage.delete(key: _pendingPayment);
  }
}

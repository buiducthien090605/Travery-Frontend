import 'dart:io';

import 'package:travery_frontend/config/app_config.dart';
import 'package:travery_frontend/data/services/api/model/authentication/forgot_password_request/forgot_password_request.dart';
import 'dart:convert';

import 'package:travery_frontend/data/services/api/model/authentication/login_request/login_request.dart';
import 'package:travery_frontend/data/services/api/model/authentication/login_response/login_response.dart';
import 'package:travery_frontend/data/services/api/model/authentication/logout_request/logout_request.dart';
import 'package:travery_frontend/data/services/api/model/authentication/refresh_request/refresh_request.dart';
import 'package:travery_frontend/data/services/api/model/authentication/refresh_response/refresh_reponse.dart';
import 'package:travery_frontend/data/services/api/model/authentication/resend_otp_request/resend_otp_request.dart';
import 'package:travery_frontend/data/services/api/model/authentication/reset_password_request/reset_password_request.dart';
import 'package:travery_frontend/data/services/api/model/authentication/signup_request/signup_request.dart';
import 'package:travery_frontend/data/services/api/model/authentication/verify_otp_request/verify_otp_request.dart';
import 'package:travery_frontend/utils/core_result.dart';

class AuthService {
  AuthService({String? host, HttpClient Function()? clientFactory})
    : _host = host ?? AppConfig.host,
      _clientFactory = clientFactory ?? HttpClient.new;

  final String _host;
  final HttpClient Function() _clientFactory;

  Uri _buildUri(String path) => Uri.parse('$_host$path');

  Future<String> _extractErrorMessage(
    HttpClientResponse response,
    String defaultMessage,
  ) async {
    try {
      final stringData = await response.transform(utf8.decoder).join();
      final jsonMap = jsonDecode(stringData) as Map<String, dynamic>;
      return jsonMap['message'] as String? ?? defaultMessage;
    } catch (_) {
      return defaultMessage;
    }
  }

  Future<Result<LoginResponse>> loginViaEmail(LoginRequest loginRequest) async {
    final client = _clientFactory();
    client.connectionTimeout = const Duration(milliseconds: AppConfig.timeout);

    try {
      final request = await client.postUrl(_buildUri('/api/v1/auth/login'));
      // set header Content-Type: application/json
      // Báo cho sever biết file sắp gửi là json
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        ContentType.json.value,
      );
      request.write(jsonEncode(loginRequest));
      final response = await request.close();

      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonMap = jsonDecode(stringData) as Map<String, dynamic>;
        final data = jsonMap['data'] as Map<String, dynamic>;
        return Result.ok(LoginResponse.fromJson(data));
      } else {
        final errorMsg = await _extractErrorMessage(response, "Login Error");
        return Result.error(HttpException(errorMsg));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> signup(SignupRequest signupRequest) async {
    final client = _clientFactory();
    client.connectionTimeout = const Duration(milliseconds: AppConfig.timeout);

    try {
      final request = await client.postUrl(_buildUri('/api/v1/auth/signup'));
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        ContentType.json.value,
      );
      request.write(jsonEncode(signupRequest));
      final response = await request.close();

      if (response.statusCode == 200) {
        return const Result.ok(null);
      } else {
        final errorMsg = await _extractErrorMessage(response, "Signup Error");
        return Result.error(HttpException(errorMsg));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> forgotPassword(
    ForgotPasswordRequest forgotPasswordRequest,
  ) async {
    final client = _clientFactory();
    client.connectionTimeout = const Duration(milliseconds: AppConfig.timeout);

    try {
      final request = await client.postUrl(
        _buildUri('/api/v1/auth/forgot-password'),
      );
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        ContentType.json.value,
      );
      request.write(jsonEncode(forgotPasswordRequest));
      final response = await request.close();

      if (response.statusCode == 200) {
        return const Result.ok(null);
      } else {
        final errorMsg = await _extractErrorMessage(
          response,
          "Forgot Password Error",
        );
        return Result.error(HttpException(errorMsg));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> verifyOtp(VerifyOtpRequest verifyOtpRequest) async {
    final client = _clientFactory();
    client.connectionTimeout = const Duration(milliseconds: AppConfig.timeout);

    try {
      final request = await client.postUrl(
        _buildUri('/api/v1/auth/verify-otp'),
      );
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        ContentType.json.value,
      );
      request.write(jsonEncode(verifyOtpRequest));
      final response = await request.close();

      if (response.statusCode == 200) {
        return const Result.ok(null);
      } else {
        final errorMsg = await _extractErrorMessage(
          response,
          "Verify OTP Error",
        );
        return Result.error(HttpException(errorMsg));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> resendOtp(ResendOtpRequest resendOtpRequest) async {
    final client = _clientFactory();
    client.connectionTimeout = const Duration(milliseconds: AppConfig.timeout);

    try {
      final request = await client.postUrl(
        _buildUri('/api/v1/auth/resend-otp'),
      );
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        ContentType.json.value,
      );
      request.write(jsonEncode(resendOtpRequest));
      final response = await request.close();

      if (response.statusCode == 200) {
        return const Result.ok(null);
      } else {
        final errorMsg = await _extractErrorMessage(
          response,
          "Resend OTP Error",
        );
        return Result.error(HttpException(errorMsg));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> resetPassword(
    ResetPasswordRequest resetPasswordRequest,
  ) async {
    final client = _clientFactory();
    client.connectionTimeout = const Duration(milliseconds: AppConfig.timeout);

    try {
      final request = await client.postUrl(
        _buildUri('/api/v1/auth/reset-password'),
      );
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        ContentType.json.value,
      );
      request.write(jsonEncode(resetPasswordRequest));
      final response = await request.close();

      if (response.statusCode == 200) {
        return const Result.ok(null);
      } else {
        final errorMsg = await _extractErrorMessage(
          response,
          "Reset Password Error",
        );
        return Result.error(HttpException(errorMsg));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> logout(LogoutRequest logoutRequest) async {
    final client = _clientFactory();
    client.connectionTimeout = const Duration(milliseconds: AppConfig.timeout);

    try {
      final request = await client.postUrl(_buildUri('/api/v1/auth/logout'));
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        ContentType.json.value,
      );
      request.write(jsonEncode(logoutRequest));
      final response = await request.close();

      if (response.statusCode == 200) {
        return const Result.ok(null);
      } else {
        final errorMsg = await _extractErrorMessage(response, "Logout Error");
        return Result.error(HttpException(errorMsg));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<RefreshResponse>> refresh(RefreshRequest refreshRequest) async {
    final client = _clientFactory();
    client.connectionTimeout = const Duration(milliseconds: AppConfig.timeout);

    try {
      final request = await client.postUrl(_buildUri('/api/v1/auth/refresh'));
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        ContentType.json.value,
      );
      request.write(jsonEncode(refreshRequest));
      final response = await request.close();

      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonMap = jsonDecode(stringData) as Map<String, dynamic>;
        final data = jsonMap['data'] as Map<String, dynamic>;
        return Result.ok(RefreshResponse.fromJson(data));
      } else {
        final errorMsg = await _extractErrorMessage(response, "Refresh Error");
        return Result.error(HttpException(errorMsg));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }
}

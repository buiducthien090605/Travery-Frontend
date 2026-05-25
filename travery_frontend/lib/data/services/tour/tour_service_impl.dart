import 'dart:convert';
import 'dart:io';

import 'package:travery_frontend/config/app_config.dart';
import 'package:travery_frontend/data/models/tour/tour_detail_page_data.dart';
import 'package:travery_frontend/data/models/tour/tour_featured_response.dart';
import 'package:travery_frontend/data/models/tour/tour_search_response.dart';
import 'package:travery_frontend/data/seed_models/tour_instance/tour_instance.dart';
import 'package:travery_frontend/data/services/api/model/booking/booking_detail_response/booking_detail_response.dart';
import 'package:travery_frontend/data/services/api/model/booking/booking_list_response/booking_list_response.dart';
import 'package:travery_frontend/data/services/api/model/booking/cancel_booking_response/cancel_booking_response.dart';
import 'package:travery_frontend/data/services/api/model/booking/create_tour_booking_request/create_tour_booking_request.dart';
import 'package:travery_frontend/data/services/api/model/booking/create_tour_booking_response/create_tour_booking_response.dart';
import 'package:travery_frontend/data/services/api/model/booking/create_payment_response/create_payment_response.dart';
import 'package:travery_frontend/data/services/security_storage_service.dart';
import 'package:travery_frontend/data/services/tour/tour_service.dart';
import 'package:travery_frontend/utils/core_result.dart';

class TourServiceImpl implements TourService {
  TourServiceImpl({required SecurityStorageService securityStorageService})
    : _securityStorageService = securityStorageService;

  final SecurityStorageService _securityStorageService;

  Future<void> _setBearerAuth(HttpClientRequest request) async {
    final token = await _securityStorageService.getAccessToken();
    if (token != null) {
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
    }
  }

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

  @override
  Future<Result<TourSearchPageData>> searchTours({
    String? keyword,
    double? minPrice,
    double? maxPrice,
    int? minRating,
    DateTime? startDate,
    String? destinationId,
    int page = 0,
    int size = 20,
  }) async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(milliseconds: AppConfig.timeout);

    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'size': size.toString(),
      };
      if (keyword != null && keyword.isNotEmpty)
        queryParams['keyword'] = keyword;
      if (minPrice != null) queryParams['minPrice'] = minPrice.toString();
      if (maxPrice != null) queryParams['maxPrice'] = maxPrice.toString();
      if (minRating != null) queryParams['minRating'] = minRating.toString();
      if (startDate != null)
        queryParams['startDate'] = startDate.toIso8601String().split('T').first;
      if (destinationId != null && destinationId.isNotEmpty) {
        queryParams['destinationId'] = destinationId;
      }

      final request = await client.getUrl(
        Uri.parse(
          '${AppConfig.host}:${AppConfig.port}/api/v1/tours',
        ).replace(queryParameters: queryParams),
      );
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        ContentType.json.value,
      );
      await _setBearerAuth(request);

      final response = await request.close();

      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonMap = jsonDecode(stringData) as Map<String, dynamic>;
        return Result.ok(TourSearchResponse.fromJson(jsonMap).data);
      } else {
        final errorMsg = await _extractErrorMessage(
          response,
          'Search tours failed',
        );
        return Result.error(HttpException(errorMsg));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  @override
  Future<Result<List<TourFeaturedItem>>> getFeaturedTours() async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(milliseconds: AppConfig.timeout);

    try {
      final request = await client.getUrl(
        Uri.parse('${AppConfig.host}:${AppConfig.port}/api/v1/tours/featured'),
      );
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        ContentType.json.value,
      );
      await _setBearerAuth(request);

      final response = await request.close();

      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonMap = jsonDecode(stringData) as Map<String, dynamic>;
        return Result.ok(TourFeaturedResponse.fromJson(jsonMap).data);
      } else {
        final errorMsg = await _extractErrorMessage(
          response,
          'Get featured tours failed',
        );
        return Result.error(HttpException(errorMsg));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  @override
  Future<Result<TourDetailPageData?>> getTourById(String tourId) async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(milliseconds: AppConfig.timeout);

    try {
      final request = await client.getUrl(
        Uri.parse('${AppConfig.host}:${AppConfig.port}/api/v1/tours/$tourId'),
      );
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        ContentType.json.value,
      );
      await _setBearerAuth(request);

      final response = await request.close();

      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonMap = jsonDecode(stringData) as Map<String, dynamic>;
        final data = jsonMap['data'] as Map<String, dynamic>?;
        if (data == null) return Result.ok(null);
        final tour = TourDetailPageData.fromJson(data);
        return Result.ok(tour);
      } else if (response.statusCode == 404) {
        return Result.ok(null);
      } else {
        final errorMsg = await _extractErrorMessage(
          response,
          'Get tour failed',
        );
        return Result.error(HttpException(errorMsg));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  @override
  Future<Result<List<TourInstance>>> getTourInstances(String tourId) async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(milliseconds: AppConfig.timeout);

    try {
      final request = await client.getUrl(
        Uri.parse(
          '${AppConfig.host}:${AppConfig.port}/api/v1/tours/$tourId/instances',
        ),
      );
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        ContentType.json.value,
      );
      await _setBearerAuth(request);

      final response = await request.close();

      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonMap = jsonDecode(stringData) as Map<String, dynamic>;
        final data = jsonMap['data'] as List<dynamic>;
        final instances = data
            .map((e) => TourInstance.fromJson(e as Map<String, dynamic>))
            .toList();
        return Result.ok(instances);
      } else {
        final errorMsg = await _extractErrorMessage(
          response,
          'Get tour instances failed',
        );
        return Result.error(HttpException(errorMsg));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  @override
  Future<Result<TourBookingData>> createTourBooking({
    required String instanceId,
    required CreateTourBookingRequest request,
  }) async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(milliseconds: AppConfig.timeout);

    try {
      final requestObj = await client.postUrl(
        Uri.parse(
          '${AppConfig.host}:${AppConfig.port}/api/v1/tour-instances/$instanceId/bookings',
        ),
      );
      requestObj.headers.set(
        HttpHeaders.contentTypeHeader,
        ContentType.json.value,
      );
      await _setBearerAuth(requestObj);
      requestObj.write(jsonEncode(request));

      final response = await requestObj.close();

      // Backend trả về 200 hoặc 201 đều là thành công
      if (response.statusCode == 200 || response.statusCode == 201) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonMap = jsonDecode(stringData) as Map<String, dynamic>;
        final bookingData = CreateTourBookingResponse.fromJson(jsonMap).data;
        return Result.ok(bookingData);
      } else {
        final errorMsg = await _extractErrorMessage(
          response,
          'Tạo booking thất bại',
        );
        return Result.error(HttpException(errorMsg));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  @override
  Future<Result<TourBookingData>> getBookingDetail(String bookingId) async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(milliseconds: AppConfig.timeout);

    try {
      final request = await client.getUrl(
        Uri.parse(
          '${AppConfig.host}:${AppConfig.port}/api/v1/bookings/$bookingId',
        ),
      );
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        ContentType.json.value,
      );
      await _setBearerAuth(request);

      final response = await request.close();

      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonMap = jsonDecode(stringData) as Map<String, dynamic>;
        final data = BookingDetailResponse.fromJson(jsonMap).data;
        return Result.ok(data);
      } else {
        final errorMsg = await _extractErrorMessage(
          response,
          'Lấy chi tiết booking thất bại',
        );
        return Result.error(HttpException(errorMsg));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  @override
  Future<Result<PaymentResponseData>> createPayment(String bookingId) async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(milliseconds: AppConfig.timeout);

    try {
      final requestObj = await client.postUrl(
        Uri.parse(
          '${AppConfig.host}:${AppConfig.port}/api/v1/bookings/$bookingId/payments',
        ),
      );
      requestObj.headers.set(
        HttpHeaders.contentTypeHeader,
        ContentType.json.value,
      );
      await _setBearerAuth(requestObj);

      final response = await requestObj.close();

      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonMap = jsonDecode(stringData) as Map<String, dynamic>;
        final data = CreatePaymentResponse.fromJson(jsonMap).data;
        return Result.ok(data);
      } else {
        final errorMsg = await _extractErrorMessage(
          response,
          'Tạo thanh toán thất bại',
        );
        return Result.error(HttpException(errorMsg));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  @override
  Future<Result<BookingListPageData>> getMyBookings({
    String? status,
    int page = 0,
    int size = 20,
  }) async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(milliseconds: AppConfig.timeout);

    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'size': size.toString(),
      };
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      final request = await client.getUrl(
        Uri.parse(
          '${AppConfig.host}:${AppConfig.port}/api/v1/bookings/me',
        ).replace(queryParameters: queryParams),
      );
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        ContentType.json.value,
      );
      await _setBearerAuth(request);

      final response = await request.close();

      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonMap = jsonDecode(stringData) as Map<String, dynamic>;
        return Result.ok(
          BookingListPageData.fromJson(jsonMap['data'] as Map<String, dynamic>),
        );
      } else {
        final errorMsg = await _extractErrorMessage(
          response,
          'Lấy danh sách booking thất bại',
        );
        return Result.error(HttpException(errorMsg));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  @override
  Future<Result<CancelBookingData>> cancelBooking(String bookingId) async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(milliseconds: AppConfig.timeout);

    try {
      final requestObj = await client.postUrl(
        Uri.parse(
          '${AppConfig.host}:${AppConfig.port}/api/v1/bookings/$bookingId/cancel',
        ),
      );
      requestObj.headers.set(
        HttpHeaders.contentTypeHeader,
        ContentType.json.value,
      );
      await _setBearerAuth(requestObj);

      final response = await requestObj.close();

      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonMap = jsonDecode(stringData) as Map<String, dynamic>;
        return Result.ok(
          CancelBookingData.fromJson(jsonMap['data'] as Map<String, dynamic>),
        );
      } else {
        final errorMsg = await _extractErrorMessage(
          response,
          'Hủy booking thất bại',
        );
        return Result.error(HttpException(errorMsg));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }
}

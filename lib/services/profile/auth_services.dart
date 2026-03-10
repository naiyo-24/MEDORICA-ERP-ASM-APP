import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/asm.dart';
import '../api_url.dart';

class AuthServices {
  AuthServices({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiUrl.baseUrl,
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
              sendTimeout: const Duration(seconds: 15),
              headers: const {'Content-Type': 'application/json'},
            ),
          ) {
    if (!_dio.interceptors.any(
      (interceptor) => interceptor is PrettyDioLogger,
    )) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          compact: true,
          enabled: kDebugMode,
        ),
      );
    }
  }

  final Dio _dio;

  Future<ASM> login({required String phone, required String password}) async {
    try {
      final response = await _dio.post(
        ApiUrl.asmLogin,
        data: {'phone_no': phone.trim(), 'password': password},
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid login response received from server.');
      }

      return ASM.fromLoginJson(data);
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (error) {
      throw Exception('Unable to sign in right now. Please try again.');
    }
  }

  String _extractErrorMessage(DioException error) {
    final responseData = error.response?.data;
    if (responseData is Map<String, dynamic>) {
      final detail = responseData['detail'];
      if (detail is String && detail.trim().isNotEmpty) {
        return detail.trim();
      }
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return 'Request timed out. Please check your connection and try again.';
    }

    if (error.type == DioExceptionType.connectionError) {
      return 'Unable to reach the server. Please check your connection.';
    }

    return 'Unable to sign in right now. Please try again.';
  }
}

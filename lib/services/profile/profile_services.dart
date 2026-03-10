import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/asm.dart';
import '../api_url.dart';

class ProfileServices {
  ProfileServices({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiUrl.baseUrl,
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
              sendTimeout: const Duration(seconds: 30),
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
  final DateFormat _apiDateFormatter = DateFormat('yyyy-MM-dd');

  Future<ASM> fetchProfile(String asmId) async {
    try {
      final response = await _dio.get(ApiUrl.asmGetById(asmId));
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid profile response received from server.');
      }

      return _normalizeProfileImage(ASM.fromJson(data));
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (error) {
      throw Exception('Unable to load your profile right now.');
    }
  }

  Future<ASM> updateProfile({
    required String asmId,
    required ASM profile,
    String? profileImagePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'full_name': profile.name.trim(),
        'phone_no': profile.phone.trim(),
        'password': (profile.password ?? '').trim(),
        'alt_phone_no': (profile.altPhone ?? '').trim(),
        'email': profile.email.trim(),
        'address': (profile.address ?? '').trim(),
        'joining_date': profile.joiningDate == null
            ? ''
            : _apiDateFormatter.format(profile.joiningDate!),
        'bank_name': (profile.bankName ?? '').trim(),
        'bank_account_no': (profile.bankAccountNo ?? '').trim(),
        'ifsc_code': (profile.ifscCode ?? '').trim(),
        'branch_name': (profile.branchName ?? '').trim(),
      });

      final imageFile = await _buildImageFile(profileImagePath);
      if (imageFile != null) {
        formData.files.add(MapEntry('profile_photo', imageFile));
      }

      final response = await _dio.put(
        ApiUrl.asmUpdateById(asmId),
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception(
          'Invalid profile update response received from server.',
        );
      }

      return _normalizeProfileImage(ASM.fromJson(data));
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (error) {
      throw Exception('Unable to update your profile right now.');
    }
  }

  Future<MultipartFile?> _buildImageFile(String? profileImagePath) async {
    if (profileImagePath == null || profileImagePath.trim().isEmpty) {
      return null;
    }

    final trimmedPath = profileImagePath.trim();
    if (trimmedPath.startsWith('http://') ||
        trimmedPath.startsWith('https://') ||
        trimmedPath.startsWith('assets/')) {
      return null;
    }

    final file = File(trimmedPath);
    if (!await file.exists()) {
      return null;
    }

    final fileName = trimmedPath.split(Platform.pathSeparator).last;
    return MultipartFile.fromFile(trimmedPath, filename: fileName);
  }

  ASM _normalizeProfileImage(ASM profile) {
    final imagePath = profile.profileImage;
    if (imagePath == null || imagePath.isEmpty) {
      return profile;
    }

    if (imagePath.startsWith('http://') ||
        imagePath.startsWith('https://') ||
        imagePath.startsWith('assets/') ||
        imagePath.startsWith('/Users/') ||
        imagePath.startsWith('/var/')) {
      return profile;
    }

    final normalizedPath = imagePath.startsWith('/')
        ? ApiUrl.getFullUrl(imagePath)
        : ApiUrl.getFullUrl('/$imagePath');

    return profile.copyWith(profileImage: normalizedPath);
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

    return 'Something went wrong while talking to the server.';
  }
}

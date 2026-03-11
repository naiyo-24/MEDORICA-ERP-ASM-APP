import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/chemist_shop.dart';
import '../api_url.dart';

class ChemistShopServices {
  ChemistShopServices({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiUrl.baseUrl,
              connectTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 20),
              sendTimeout: const Duration(seconds: 30),
            ),
          ) {
    if (!_dio.interceptors.any((it) => it is PrettyDioLogger)) {
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

  // Fetch all chemist shops belonging to a specific ASM.
  Future<List<ChemistShop>> fetchShopsByAsmId(String asmId) async {
    try {
      final response = await _dio.get(ApiUrl.chemistShopGetByAsmId(asmId));
      final data = response.data;
      if (data is! List) {
        throw Exception('Invalid shop list response received from server.');
      }
      return data
          .whereType<Map<String, dynamic>>()
          .map(ChemistShop.fromJson)
          .toList();
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to load chemist shops right now.');
    }
  }

  // Fetch a specific chemist shop by ASM ID + shop ID.
  Future<ChemistShop> fetchShopByAsmAndShopId({
    required String asmId,
    required String shopId,
  }) async {
    try {
      final response = await _dio.get(
        ApiUrl.chemistShopGetByAsmAndShopId(asmId, shopId),
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid shop response received from server.');
      }
      return ChemistShop.fromJson(data);
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to load chemist shop details right now.');
    }
  }

  // Create a new chemist shop for an ASM.
  Future<ChemistShop> createShop({
    required String asmId,
    required ChemistShop shop,
    String? photoPath,
    String? bankPassbookPhotoPath,
  }) async {
    try {
      final formData = await _buildShopFormData(
        asmId: asmId,
        shop: shop,
        includeRequired: true,
        photoPath: photoPath,
        bankPassbookPhotoPath: bankPassbookPhotoPath,
      );
      final response = await _dio.post(
        ApiUrl.chemistShopPost,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid shop create response from server.');
      }
      return ChemistShop.fromJson(data);
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to create chemist shop right now.');
    }
  }

  // Update a chemist shop by ASM ID + shop ID.
  Future<ChemistShop> updateShop({
    required String asmId,
    required String shopId,
    required ChemistShop shop,
    String? photoPath,
    String? bankPassbookPhotoPath,
  }) async {
    try {
      final formData = await _buildShopFormData(
        asmId: null,
        shop: shop,
        includeRequired: false,
        photoPath: photoPath,
        bankPassbookPhotoPath: bankPassbookPhotoPath,
      );
      final response = await _dio.put(
        ApiUrl.chemistShopUpdateByAsmAndShopId(asmId, shopId),
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid shop update response from server.');
      }
      return ChemistShop.fromJson(data);
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to update chemist shop right now.');
    }
  }

  // Delete a chemist shop by ASM ID + shop ID.
  Future<void> deleteShop({
    required String asmId,
    required String shopId,
  }) async {
    try {
      await _dio.delete(ApiUrl.chemistShopDeleteByAsmAndShopId(asmId, shopId));
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to delete chemist shop right now.');
    }
  }

  Future<FormData> _buildShopFormData({
    required String? asmId,
    required ChemistShop shop,
    required bool includeRequired,
    String? photoPath,
    String? bankPassbookPhotoPath,
  }) async {
    final fields = <MapEntry<String, dynamic>>[];

    if (includeRequired && asmId != null) {
      fields.add(MapEntry('asm_id', asmId));
      fields.add(MapEntry('shop_name', shop.name));
      fields.add(MapEntry('phone_no', shop.phoneNo));
    } else {
      if (shop.name.isNotEmpty) {
        fields.add(MapEntry('shop_name', shop.name));
      }
      if (shop.phoneNo.isNotEmpty) {
        fields.add(MapEntry('phone_no', shop.phoneNo));
      }
    }

    if (shop.address != null && shop.address!.isNotEmpty) {
      fields.add(MapEntry('address', shop.address!));
    }
    if (shop.email != null && shop.email!.isNotEmpty) {
      fields.add(MapEntry('email', shop.email!));
    }
    if (shop.description != null && shop.description!.isNotEmpty) {
      fields.add(MapEntry('description', shop.description!));
    }

    final formData = FormData.fromMap(Map.fromEntries(fields));

    if (photoPath != null && photoPath.isNotEmpty) {
      final file = File(photoPath);
      if (await file.exists()) {
        formData.files.add(
          MapEntry(
            'photo',
            await MultipartFile.fromFile(
              photoPath,
              filename: photoPath.split('/').last,
            ),
          ),
        );
      }
    }

    if (bankPassbookPhotoPath != null && bankPassbookPhotoPath.isNotEmpty) {
      final file = File(bankPassbookPhotoPath);
      if (await file.exists()) {
        formData.files.add(
          MapEntry(
            'bank_passbook_photo',
            await MultipartFile.fromFile(
              bankPassbookPhotoPath,
              filename: bankPassbookPhotoPath.split('/').last,
            ),
          ),
        );
      }
    }

    return formData;
  }

  String _extractErrorMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic> && data['detail'] != null) {
      return data['detail'].toString();
    }
    return error.message ?? 'An unexpected error occurred.';
  }
}

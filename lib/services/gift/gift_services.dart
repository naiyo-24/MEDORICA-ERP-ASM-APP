import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../models/gift.dart';
import '../api_url.dart';

class GiftServices {
	final Dio _dio;

	GiftServices({Dio? dio}) : _dio = dio ?? Dio() {
		_dio.options.baseUrl = ApiUrl.baseUrl;
		_dio.interceptors.add(PrettyDioLogger(
			requestHeader: true,
			requestBody: true,
			responseHeader: true,
			responseBody: true,
			error: true,
			compact: true,
		));
	}

	// Fetch all gifts (inventory)
	Future<List<Gift>> fetchAllGifts() async {
		final response = await _dio.get(ApiUrl.giftInventoryGetAll);
		final data = response.data as List;
		return data.map((e) => Gift.fromJson(e)).toList();
	}

	// Fetch all gift applications for an ASM
	Future<List<GiftApplication>> fetchGiftApplicationsByAsmId(String asmId) async {
		final response = await _dio.get(ApiUrl.asmGiftApplicationGetByAsmId(asmId));
		final data = response.data as List;
		return data.map((e) => GiftApplication.fromJson(e)).toList();
	}

	// Create a new gift application
	Future<GiftApplication> createGiftApplication({
		required String asmId,
		required String doctorId,
		required int giftId,
		String? occassion,
		String? message,
		DateTime? giftDate,
		String? remarks,
	}) async {
		final formData = FormData.fromMap({
			'asm_id': asmId,
			'doctor_id': doctorId,
			'gift_id': giftId,
			'occassion': ?occassion,
			'message': ?message,
			if (giftDate != null) 'gift_date': giftDate.toIso8601String(),
			'remarks': ?remarks,
		});
		final response = await _dio.post(ApiUrl.asmGiftApplicationPost, data: formData);
		return GiftApplication.fromJson(response.data);
	}

	// Update a gift application
	Future<GiftApplication> updateGiftApplication({
		required String asmId,
		required int requestId,
		String? doctorId,
		String? occassion,
		String? message,
		DateTime? giftDate,
		String? remarks,
		String? status,
	}) async {
		final formData = FormData.fromMap({
			'doctor_id': ?doctorId,
			'occassion': ?occassion,
			'message': ?message,
			if (giftDate != null) 'gift_date': giftDate.toIso8601String(),
			'remarks': ?remarks,
			'status': ?status,
		});
		final response = await _dio.put(ApiUrl.asmGiftApplicationUpdateByAsmAndRequestId(asmId, requestId), data: formData);
		return GiftApplication.fromJson(response.data);
	}

	// Delete a gift application
	Future<void> deleteGiftApplication(int requestId) async {
		await _dio.delete(ApiUrl.asmGiftApplicationDeleteByRequestId(requestId));
	}
}

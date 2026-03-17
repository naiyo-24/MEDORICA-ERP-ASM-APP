import 'package:flutter_riverpod/legacy.dart';
import '../models/gift.dart';
import '../services/gift/gift_services.dart';

class GiftState {
	final List<Gift> gifts;
	final List<GiftApplication> applications;
	final bool isLoading;
	final String? error;

	const GiftState({
		this.gifts = const [],
		this.applications = const [],
		this.isLoading = false,
		this.error,
	});

	GiftState copyWith({
		List<Gift>? gifts,
		List<GiftApplication>? applications,
		bool? isLoading,
		String? error,
	}) {
		return GiftState(
			gifts: gifts ?? this.gifts,
			applications: applications ?? this.applications,
			isLoading: isLoading ?? this.isLoading,
			error: error,
		);
	}
}

class GiftNotifier extends StateNotifier<GiftState> {
	final GiftServices _giftServices;
	String? _asmId;

	GiftNotifier(this._giftServices) : super(const GiftState());

	void setAsmId(String? asmId) {
		_asmId = asmId;
		if (_asmId != null && _asmId!.isNotEmpty) {
			fetchAll();
		} else {
			state = const GiftState();
		}
	}

	Future<void> fetchAll() async {
		if (_asmId == null) return;
		state = state.copyWith(isLoading: true, error: null);
		try {
			final gifts = await _giftServices.fetchAllGifts();
			final applications = await _giftServices.fetchGiftApplicationsByAsmId(_asmId!);
			state = state.copyWith(gifts: gifts, applications: applications, isLoading: false);
		} catch (e) {
			state = state.copyWith(isLoading: false, error: e.toString());
		}
	}

	Future<void> createGiftApplication({
		required String doctorId,
		required int giftId,
		String? occassion,
		String? message,
		DateTime? giftDate,
		String? remarks,
	}) async {
		if (_asmId == null) return;
		state = state.copyWith(isLoading: true, error: null);
		try {
			await _giftServices.createGiftApplication(
				asmId: _asmId!,
				doctorId: doctorId,
				giftId: giftId,
				occassion: occassion,
				message: message,
				giftDate: giftDate,
				remarks: remarks,
			);
			await fetchAll();
		} catch (e) {
			state = state.copyWith(isLoading: false, error: e.toString());
		}
	}

	Future<void> updateGiftApplication({
		required int requestId,
		String? doctorId,
		String? occassion,
		String? message,
		DateTime? giftDate,
		String? remarks,
		String? status,
	}) async {
		if (_asmId == null) return;
		state = state.copyWith(isLoading: true, error: null);
		try {
			await _giftServices.updateGiftApplication(
				asmId: _asmId!,
				requestId: requestId,
				doctorId: doctorId,
				occassion: occassion,
				message: message,
				giftDate: giftDate,
				remarks: remarks,
				status: status,
			);
			await fetchAll();
		} catch (e) {
			state = state.copyWith(isLoading: false, error: e.toString());
		}
	}

	Future<void> deleteGiftApplication(int requestId) async {
		state = state.copyWith(isLoading: true, error: null);
		try {
			await _giftServices.deleteGiftApplication(requestId);
			await fetchAll();
		} catch (e) {
			state = state.copyWith(isLoading: false, error: e.toString());
		}
	}

	void clearError() {
		state = state.copyWith(error: null);
	}
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/gift_notifier.dart';
import '../services/gift/gift_services.dart';
import 'auth_provider.dart';

final giftServicesProvider = Provider<GiftServices>((ref) {
	return GiftServices();
});

final giftNotifierProvider = StateNotifierProvider<GiftNotifier, GiftState>((ref) {
	final notifier = GiftNotifier(ref.read(giftServicesProvider));
	ref.listen(authNotifierProvider, (previous, next) {
		notifier.setAsmId(next.asmId);
	}, fireImmediately: true);
	return notifier;
});

final giftsProvider = Provider((ref) => ref.watch(giftNotifierProvider).gifts);
final giftApplicationsProvider = Provider((ref) => ref.watch(giftNotifierProvider).applications);
final isGiftLoadingProvider = Provider((ref) => ref.watch(giftNotifierProvider).isLoading);
final giftErrorProvider = Provider((ref) => ref.watch(giftNotifierProvider).error);

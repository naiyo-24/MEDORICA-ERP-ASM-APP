import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/distributor_notifier.dart';
import '../models/distributor.dart';

final distributorNotifierProvider =
    StateNotifierProvider<DistributorNotifier, List<Distributor>>(
  (ref) => DistributorNotifier(),
);

final filteredDistributorsProvider =
    StateProvider<List<Distributor>>((ref) {
  return ref.watch(distributorNotifierProvider);
});

final distributorByIdProvider =
    Provider.family<Distributor?, String>((ref, id) {
  final distributors = ref.watch(distributorNotifierProvider);
  try {
    return distributors.firstWhere((d) => d.id == id);
  } catch (e) {
    return null;
  }
});

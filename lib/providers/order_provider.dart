import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/order_notifier.dart';
import '../models/order.dart';

final orderNotifierProvider =
    StateNotifierProvider<OrderNotifier, List<Order>>(
  (ref) => OrderNotifier(),
);

final filteredOrdersProvider =
    StateProvider<List<Order>>((ref) {
  return ref.watch(orderNotifierProvider);
});

final orderByIdProvider =
    Provider.family<Order?, String>((ref, id) {
  final orders = ref.watch(orderNotifierProvider);
  try {
    return orders.firstWhere((order) => order.id == id);
  } catch (e) {
    return null;
  }
});

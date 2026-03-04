import 'package:flutter_riverpod/legacy.dart';
import '../models/order.dart';

class OrderNotifier extends StateNotifier<List<Order>> {
  OrderNotifier() : super([]);

  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    state = [
      for (final order in state)
        if (order.id == orderId) order.copyWith(status: newStatus) else order,
    ];
  }

  void addOrder(Order order) {
    state = [...state, order];
  }

  void deleteOrder(String id) {
    state = state.where((order) => order.id != id).toList();
  }

  void searchOrders(String query) {
    if (query.isEmpty) {
      state = state;
    } else {
      state = state
          .where((order) =>
              order.id.toLowerCase().contains(query.toLowerCase()) ||
              order.chemistShopName
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              order.distributorName
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    }
  }
}

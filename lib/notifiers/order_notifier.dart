import 'package:flutter_riverpod/legacy.dart';
import '../models/order.dart';

class OrderNotifier extends StateNotifier<List<Order>> {
  OrderNotifier()
      : super([
          Order(
            id: 'ORD-001',
            mrName: 'Rajesh Kumar',
            mrPhoneNo: '+91 98765 54321',
            chemistShopName: 'Prime Pharma Care',
            chemistShopPhoneNo: '+91 98765 54321',
            chemistShopAddress: '42 Mount Road, Connaught Place, Delhi',
            chemistShopId: '1',
            doctorName: 'Dr. Arun Singh',
            distributorName: 'Metro Pharma Distributors',
            distributorPhoneNo: '+91 98765 43210',
            distributorAddress: '123 Medical Lane, Delhi',
            distributorDeliveryTime: '24-48 hours',
            distributorId: '1',
            medicines: [
              Medicine(id: 'm1', name: 'Aspirin 500mg', quantity: 100, pack: 'Blister', totalAmount: 250.0),
              Medicine(id: 'm2', name: 'Amoxicillin 250mg', quantity: 50, pack: 'Bottle', totalAmount: 315.0),
              Medicine(id: 'm3', name: 'Paracetamol 650mg', quantity: 200, pack: 'Blister', totalAmount: 480.0),
            ],
            status: OrderStatus.approved,
            createdAt: DateTime.now().subtract(const Duration(days: 2)),
          ),
          Order(
            id: 'ORD-002',
            mrName: 'Amit Desai',
            mrPhoneNo: '+91 87654 54321',
            chemistShopName: 'HealthFirst Chemists',
            chemistShopPhoneNo: '+91 87654 54321',
            chemistShopAddress: '156 Linking Road, Bandra, Mumbai',
            chemistShopId: '2',
            doctorName: 'Dr. Vikram Patel',
            distributorName: 'Apollo Healthcare Solutions',
            distributorPhoneNo: '+91 87654 32109',
            distributorAddress: '456 Pharmacy Road, Mumbai',
            distributorDeliveryTime: '24 hours',
            distributorId: '2',
            medicines: [
              Medicine(id: 'm4', name: 'Metformin 500mg', quantity: 150, pack: 'Tablet', totalAmount: 420.0),
              Medicine(id: 'm5', name: 'Atorvastatin 20mg', quantity: 75, pack: 'Blister', totalAmount: 1050.0),
            ],
            status: OrderStatus.pending,
            createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          ),
          Order(
            id: 'ORD-003',
            mrName: 'Sandeep Reddy',
            mrPhoneNo: '+91 76543 54321',
            chemistShopName: 'Wellness Hub Pharmacy',
            chemistShopPhoneNo: '+91 76543 54321',
            chemistShopAddress: '789 Tech Park, Whitefield, Bangalore',
            chemistShopId: '3',
            doctorName: 'Dr. Rajesh Iyer',
            distributorName: 'Wellness Hub Distribution',
            distributorPhoneNo: '+91 76543 21098',
            distributorAddress: '789 Health Street, Bangalore',
            distributorDeliveryTime: '48 hours',
            distributorId: '3',
            medicines: [
              Medicine(id: 'm6', name: 'Omeprazole 20mg', quantity: 60, pack: 'Capsule', totalAmount: 540.0),
              Medicine(id: 'm7', name: 'Levothyroxine 75mcg', quantity: 90, pack: 'Tablet', totalAmount: 270.0),
              Medicine(id: 'm8', name: 'Cetirizine 10mg', quantity: 120, pack: 'Blister', totalAmount: 360.0),
              Medicine(id: 'm9', name: 'Vitamin B12 1000mcg', quantity: 30, pack: 'Injection', totalAmount: 900.0),
            ],
            status: OrderStatus.delivered,
            createdAt: DateTime.now().subtract(const Duration(days: 5)),
          ),
          Order(
            id: 'ORD-004',
            mrName: 'Vikram Sharma',
            mrPhoneNo: '+91 65432 54321',
            chemistShopName: 'MediCare Plus',
            chemistShopPhoneNo: '+91 65432 54321',
            chemistShopAddress: '321 Cyber Heights, Hytech City, Hyderabad',
            chemistShopId: '4',
            doctorName: 'Dr. Suresh Reddy',
            distributorName: 'HealthFirst Distributors',
            distributorPhoneNo: '+91 65432 10987',
            distributorAddress: '321 Medical Hub, Hyderabad',
            distributorDeliveryTime: '36 hours',
            distributorId: '4',
            medicines: [
              Medicine(id: 'm10', name: 'Doxycycline 100mg', quantity: 80, pack: 'Capsule', totalAmount: 640.0),
            ],
            status: OrderStatus.rejected,
            createdAt: DateTime.now().subtract(const Duration(days: 3)),
          ),
          Order(
            id: 'ORD-005',
            mrName: 'Nikhil Joshi',
            mrPhoneNo: '+91 54321 54321',
            chemistShopName: 'Care Pharmacy Network',
            chemistShopPhoneNo: '+91 54321 54321',
            chemistShopAddress: '654 Business District, Camp, Pune',
            chemistShopId: '5',
            doctorName: 'Dr. Ashok Kumar',
            distributorName: 'Care Logistics Pharma',
            distributorPhoneNo: '+91 54321 09876',
            distributorAddress: '654 Pharma Lane, Pune',
            distributorDeliveryTime: '48 hours',
            distributorId: '5',
            medicines: [
              Medicine(id: 'm11', name: 'Azithromycin 250mg', quantity: 100, pack: 'Tablet', totalAmount: 375.0),
              Medicine(id: 'm12', name: 'Ciprofloxacin 500mg', quantity: 50, pack: 'Blister', totalAmount: 280.0),
              Medicine(id: 'm13', name: 'Ibuprofen 400mg', quantity: 200, pack: 'Blister', totalAmount: 200.0),
            ],
            status: OrderStatus.received,
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
          Order(
            id: 'ORD-006',
            mrName: 'Rajesh Kumar',
            mrPhoneNo: '+91 98765 54321',
            chemistShopName: 'Prime Pharma Care',
            chemistShopPhoneNo: '+91 98765 54321',
            chemistShopAddress: '42 Mount Road, Connaught Place, Delhi',
            chemistShopId: '1',
            doctorName: 'Dr. Priya Sharma',
            distributorName: 'Metro Pharma Distributors',
            distributorPhoneNo: '+91 98765 43210',
            distributorAddress: '123 Medical Lane, Delhi',
            distributorDeliveryTime: '24-48 hours',
            distributorId: '1',
            medicines: [
              Medicine(id: 'm14', name: 'Clotrimazole 1%', quantity: 40, pack: 'Cream', totalAmount: 320.0),
              Medicine(id: 'm15', name: 'Hydrocortisone 1%', quantity: 30, pack: 'Cream', totalAmount: 240.0),
            ],
            status: OrderStatus.cancelled,
            createdAt: DateTime.now().subtract(const Duration(days: 4)),
          ),
        ]);

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
              order.mrName.toLowerCase().contains(query.toLowerCase()) ||
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

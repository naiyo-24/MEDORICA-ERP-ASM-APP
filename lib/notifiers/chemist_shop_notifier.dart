import 'package:flutter_riverpod/legacy.dart';
import '../models/chemist_shop.dart';

class ChemistShopNotifier extends StateNotifier<List<ChemistShop>> {
  ChemistShopNotifier()
      : super([
          ChemistShop(
            id: '1',
            name: 'Prime Pharma Care',
            location: 'Connaught Place, Delhi',
            photoUrl: null,
            mrName: 'Rajesh Kumar',
            email: 'contact@primepharma.com',
            address: '42 Mount Road, Connaught Place, Delhi',
            phoneNo: '+91 98765 54321',
            description:
                'A premium chemist shop in the heart of Delhi serving over 5000+ customers daily. Specializes in branded and generic medicines with expert consultation.',
            doctors: [
              Doctor(
                id: 'd1',
                name: 'Dr. Arun Singh',
                specialization: 'General Practitioner',
                phoneNo: '+91 98765 11111',
              ),
              Doctor(
                id: 'd2',
                name: 'Dr. Priya Sharma',
                specialization: 'Cardiologist',
                phoneNo: '+91 98765 22222',
              ),
            ],
          ),
          ChemistShop(
            id: '2',
            name: 'HealthFirst Chemists',
            location: 'Bandra, Mumbai',
            photoUrl: null,
            mrName: 'Amit Desai',
            email: 'info@healthfirst.com',
            address: '156 Linking Road, Bandra, Mumbai',
            phoneNo: '+91 87654 54321',
            description:
                'Modern pharmacy with state-of-the-art facilities and home delivery service. Known for customer service excellence across Western India.',
            doctors: [
              Doctor(
                id: 'd3',
                name: 'Dr. Vikram Patel',
                specialization: 'Orthopedic Surgeon',
                phoneNo: '+91 87654 33333',
              ),
              Doctor(
                id: 'd4',
                name: 'Dr. Neha Iyer',
                specialization: 'Dermatologist',
                phoneNo: '+91 87654 44444',
              ),
              Doctor(
                id: 'd5',
                name: 'Dr. Manish Gupta',
                specialization: 'Pediatrician',
                phoneNo: '+91 87654 55555',
              ),
            ],
          ),
          ChemistShop(
            id: '3',
            name: 'Wellness Hub Pharmacy',
            location: 'Whitefield, Bangalore',
            photoUrl: null,
            mrName: 'Sandeep Reddy',
            email: 'sales@wellnesshub.in',
            address: '789 Tech Park, Whitefield, Bangalore',
            phoneNo: '+91 76543 54321',
            description:
                'Premium pharmacy chain focused on preventive healthcare. Offers consultation services and home healthcare products across South India.',
            doctors: [
              Doctor(
                id: 'd6',
                name: 'Dr. Rajesh Iyer',
                specialization: 'Ayurvedic Physician',
                phoneNo: '+91 76543 66666',
              ),
              Doctor(
                id: 'd7',
                name: 'Dr. Anjali Sharma',
                specialization: 'Gynecologist',
                phoneNo: '+91 76543 77777',
              ),
            ],
          ),
          ChemistShop(
            id: '4',
            name: 'MediCare Plus',
            location: 'Hitech City, Hyderabad',
            photoUrl: null,
            mrName: 'Vikram Sharma',
            email: 'business@medicareplus.com',
            address: '321 Cyber Heights, Hytech City, Hyderabad',
            phoneNo: '+91 65432 54321',
            description:
                'Leading pharmacy chain with focus on authentic medicines. Expert pharmacists on duty 24/7 with home delivery across Hyderabad.',
            doctors: [
              Doctor(
                id: 'd8',
                name: 'Dr. Suresh Reddy',
                specialization: 'Internal Medicine',
                phoneNo: '+91 65432 88888',
              ),
            ],
          ),
          ChemistShop(
            id: '5',
            name: 'Care Pharmacy Network',
            location: 'Camp, Pune',
            photoUrl: null,
            mrName: 'Nikhil Joshi',
            email: 'info@carepharmacy.in',
            address: '654 Business District, Camp, Pune',
            phoneNo: '+91 54321 54321',
            description:
                'Trusted pharmacist chain with focus on affordable medications and generic alternatives. Specialized in chronic disease management.',
            doctors: [
              Doctor(
                id: 'd9',
                name: 'Dr. Ashok Kumar',
                specialization: 'ENT Specialist',
                phoneNo: '+91 54321 99999',
              ),
              Doctor(
                id: 'd10',
                name: 'Dr. Pooja Singh',
                specialization: 'Ophthalmologist',
                phoneNo: '+91 54321 10101',
              ),
            ],
          ),
        ]);

  void addShop(ChemistShop shop) {
    state = [...state, shop];
  }

  void updateShop(ChemistShop shop) {
    state = [
      for (final s in state)
        if (s.id == shop.id) shop else s,
    ];
  }

  void deleteShop(String id) {
    state = state.where((s) => s.id != id).toList();
  }

  void searchShops(String query) {
    if (query.isEmpty) {
      state = state;
    } else {
      state = state
          .where((s) =>
              s.name.toLowerCase().contains(query.toLowerCase()) ||
              s.location.toLowerCase().contains(query.toLowerCase()) ||
              s.mrName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}

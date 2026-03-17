
import 'package:flutter/material.dart';
import '../../models/gift.dart';

class GiftCard extends StatelessWidget {
  final GiftApplication application;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  const GiftCard({super.key, required this.application, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.card_giftcard),
        title: Text('Request #${application.requestId} - ${application.giftName ?? ''}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Doctor: ${application.doctorName ?? application.doctorId}'),
            Text('Date: ${application.giftDate?.toLocal().toString().split(' ').first ?? '-'}'),
            Text('Occasion: ${application.occassion ?? '-'}'),
            Text('Remarks: ${application.remarks ?? '-'}'),
            Text('Status: ${application.status}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

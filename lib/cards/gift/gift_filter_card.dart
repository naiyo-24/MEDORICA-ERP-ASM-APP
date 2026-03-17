
import 'package:flutter/material.dart';
import '../../models/doctor.dart';

class GiftFilterCard extends StatefulWidget {
	final List<Doctor> doctors;
	final String? selectedDoctorId;
	final String? selectedStatus;
	final ValueChanged<String?> onDoctorChanged;
	final ValueChanged<String?> onStatusChanged;

	const GiftFilterCard({
		super.key,
		required this.doctors,
		required this.selectedDoctorId,
		required this.selectedStatus,
		required this.onDoctorChanged,
		required this.onStatusChanged,
	});

	@override
	State<GiftFilterCard> createState() => _GiftFilterCardState();
}

class _GiftFilterCardState extends State<GiftFilterCard> {
	late String? _doctorId;
	late String? _status;

	@override
	void initState() {
		super.initState();
		_doctorId = widget.selectedDoctorId;
		_status = widget.selectedStatus;
	}

	@override
	void didUpdateWidget(covariant GiftFilterCard oldWidget) {
		super.didUpdateWidget(oldWidget);
		if (widget.selectedDoctorId != _doctorId) {
			_doctorId = widget.selectedDoctorId;
		}
		if (widget.selectedStatus != _status) {
			_status = widget.selectedStatus;
		}
	}

	@override
	Widget build(BuildContext context) {
		return Card(
			margin: const EdgeInsets.all(12),
			child: Padding(
				padding: const EdgeInsets.all(8.0),
				child: Row(
					children: [
						Expanded(
							child: DropdownButtonFormField<String>(
								decoration: const InputDecoration(labelText: 'Doctor'),
								value: _doctorId,
								items: [
									const DropdownMenuItem(value: null, child: Text('All Doctors')),
									...widget.doctors.map((d) => DropdownMenuItem(
												value: d.id,
												child: Text(d.name),
											))
								],
								onChanged: (value) {
									setState(() => _doctorId = value);
									widget.onDoctorChanged(value);
								},
							),
						),
						const SizedBox(width: 12),
						Expanded(
							child: DropdownButtonFormField<String>(
								decoration: const InputDecoration(labelText: 'Status'),
								value: _status ?? '',
								items: const [
									DropdownMenuItem(value: '', child: Text('All Statuses')),
									DropdownMenuItem(value: 'pending', child: Text('Pending')),
									DropdownMenuItem(value: 'approved', child: Text('Approved')),
									DropdownMenuItem(value: 'rejected', child: Text('Rejected')),
								],
								onChanged: (value) {
									setState(() => _status = value);
									widget.onStatusChanged(value);
								},
							),
						),
					],
				),
			),
		);
	}
}

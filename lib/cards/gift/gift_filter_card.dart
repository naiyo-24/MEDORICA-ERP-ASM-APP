import 'package:flutter/material.dart';

import '../../models/doctor.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';

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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: AppCardStyles.styleCard(
        backgroundColor: AppColors.surface,
        borderRadius: AppBorderRadius.lg,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          children: [
            // Doctor Dropdown
            Flexible(
              flex: 1,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Doctor',
                  prefixIcon: const Icon(
                    Iconsax.user,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 4,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  isDense: true,
                ),
                initialValue: _doctorId,
                style: AppTypography.body.copyWith(color: AppColors.primary),
                dropdownColor: AppColors.white,
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(
                      'All Doctors',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                  ...widget.doctors.map(
                    (d) => DropdownMenuItem(
                      value: d.id,
                      child: Text(
                        d.name,
                        style: const TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() => _doctorId = value);
                  widget.onDoctorChanged(value);
                },
              ),
            ),
            const SizedBox(width: 4),
            // Status Dropdown
            Flexible(
              flex: 1,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Status',
                  prefixIcon: const Icon(
                    Iconsax.status_up,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 4,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  isDense: true,
                ),
                initialValue: _status ?? '',
                style: AppTypography.body.copyWith(color: AppColors.primary),
                dropdownColor: AppColors.white,
                items: const [
                  DropdownMenuItem(
                    value: '',
                    child: Text(
                      'All Statuses',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'pending',
                    child: Text(
                      'Pending',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'approved',
                    child: Text(
                      'Approved',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'rejected',
                    child: Text(
                      'Rejected',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
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

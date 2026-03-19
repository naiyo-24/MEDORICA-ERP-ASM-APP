import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/attendance.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../cards/attendance/calendar_card.dart';
import '../../cards/attendance/attendance_details_card.dart';
import '../../providers/attendance_provider.dart';
import '../../widgets/loader.dart';

class MyAttendanceScreen extends ConsumerStatefulWidget {
  const MyAttendanceScreen({super.key});

  @override
  ConsumerState<MyAttendanceScreen> createState() => _MyAttendanceScreenState();
}

class _MyAttendanceScreenState extends ConsumerState<MyAttendanceScreen> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final month = _selectedDate != null
      ? DateTime(_selectedDate!.year, _selectedDate!.month)
      : DateTime.now();
    final monthAttendanceAsync = ref.watch(monthAttendanceProvider(month));

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: MRAppBar(
        showBack: true,
        showActions: false,
        titleText: 'My Attendance',
        subtitleText: 'View your daily records',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: CalendarCard(
              selectedDate: _selectedDate,
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
          ),
          if (_selectedDate != null)
            monthAttendanceAsync.when(
              data: (records) {
                final att = records.cast<Attendance?>().firstWhere(
                  (a) => a != null &&
                          a.date.year == _selectedDate!.year &&
                          a.date.month == _selectedDate!.month &&
                          a.date.day == _selectedDate!.day,
                  orElse: () => null,
                );
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: AttendanceDetailsCard(
                    date: _selectedDate!,
                    attendance: att,
                  ),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Center(
                  child: Loader(
                    text: 'Loading attendance...',
                    logoSize: 36.0,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              error: (err, _) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Center(child: Text('Error loading attendance')), 
              ),
            ),
        ],
      ),
    );
  }
}

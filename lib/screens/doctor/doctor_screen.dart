import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../theme/app_theme.dart';
import '../../cards/doctor/doctor_card.dart' show DoctorCard;
import '../../cards/doctor/doctor_search_bar_card.dart';
import '../../providers/auth_provider.dart';
import '../../providers/doctor_provider.dart';
import '../../routes/app_router.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/bottom_nav_bar.dart';

class MyDoctorScreen extends ConsumerStatefulWidget {
  const MyDoctorScreen({super.key});

  @override
  ConsumerState<MyDoctorScreen> createState() => _MyDoctorScreenState();
}

class _MyDoctorScreenState extends ConsumerState<MyDoctorScreen> {
  String _searchQuery = '';
  String _selectedSpecialization = '';

  @override
  Widget build(BuildContext context) {
    final allDoctors = ref.watch(doctorProvider);
    final isLoading = ref.watch(isDoctorsLoadingProvider);
    final error = ref.watch(doctorErrorProvider);
    final specializations = ref.watch(specializationsProvider);

    // Filter doctors based on search and specialization
    var filteredDoctors = allDoctors.where((doctor) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          doctor.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doctor.specialization.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );

      final matchesSpecialization =
          _selectedSpecialization.isEmpty ||
          doctor.specialization == _selectedSpecialization;

      return matchesSearch && matchesSpecialization;
    }).toList();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        context.go(AppRouter.home);
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: const MRAppBar(
          showBack: false,
          showActions: false,
          titleText: 'My Doctors',
          subtitleText: 'List of doctors you manage',
        ),
        floatingActionButton: GestureDetector(
          onTap: () => context.go('/asm/doctor/add'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Iconsax.add_square,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Add Doctor',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              // Search Bar
              DoctorSearchBarCard(
                onSearchChanged: (value) {
                  setState(() => _searchQuery = value);
                },
                onFilterChanged: (value) {
                  setState(() => _selectedSpecialization = value);
                },
                specializations: specializations,
                selectedSpecialization: _selectedSpecialization.isEmpty
                    ? null
                    : _selectedSpecialization,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Doctor List
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (error != null && error.isNotEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xxxl,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Iconsax.warning_2,
                          size: 56,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          error,
                          style: AppTypography.body.copyWith(
                            color: AppColors.quaternary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ElevatedButton(
                          onPressed: () {
                            final asmId = ref.read(authNotifierProvider).asmId;
                            if (asmId != null && asmId.trim().isNotEmpty) {
                              ref
                                  .read(doctorNotifierProvider.notifier)
                                  .loadDoctorsByAsmId(asmId);
                            }
                          },
                          style: AppButtonStyles.primaryButton(height: 44),
                          child: Text(
                            'Retry',
                            style: AppTypography.buttonMedium.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (filteredDoctors.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xxxl,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Iconsax.user_search,
                          size: 64,
                          color: AppColors.quaternary,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'No doctors found',
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.quaternary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Try adjusting your search or add a new doctor',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.tertiary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredDoctors.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    return DoctorCard(doctor: filteredDoctors[index]);
                  },
                ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
        bottomNavigationBar: const MRBottomNavBar(currentIndex: 5),
      ),
    );
  }
}

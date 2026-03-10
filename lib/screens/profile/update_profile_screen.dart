import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../models/asm.dart';
import '../../providers/profile_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  ConsumerState<UpdateProfileScreen> createState() =>
      _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  final _dateFormatter = DateFormat('dd MMM yyyy');

  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _altPhoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _joiningDateController;
  late TextEditingController _passwordController;
  late TextEditingController _bankNameController;
  late TextEditingController _bankAccountNoController;
  late TextEditingController _ifscCodeController;
  late TextEditingController _branchNameController;

  DateTime? _joiningDate;
  String? _selectedProfileImage;
  bool _isSaving = false;
  bool _obscurePassword = true;

  ASM? get _profile => ref.read(currentProfileProvider);

  @override
  void initState() {
    super.initState();
    final profile = _profile;

    _fullNameController = TextEditingController(text: profile?.name ?? '');
    _phoneController = TextEditingController(text: profile?.phone ?? '');
    _altPhoneController = TextEditingController(text: profile?.altPhone ?? '');
    _emailController = TextEditingController(text: profile?.email ?? '');
    _addressController = TextEditingController(text: profile?.address ?? '');
    _joiningDate = profile?.joiningDate;
    _joiningDateController = TextEditingController(
      text: profile?.joiningDate == null
          ? ''
          : _dateFormatter.format(profile!.joiningDate!),
    );
    _passwordController = TextEditingController(text: profile?.password ?? '');
    _bankNameController = TextEditingController(text: profile?.bankName ?? '');
    _bankAccountNoController = TextEditingController(
      text: profile?.bankAccountNo ?? '',
    );
    _ifscCodeController = TextEditingController(text: profile?.ifscCode ?? '');
    _branchNameController = TextEditingController(
      text: profile?.branchName ?? '',
    );
    _selectedProfileImage = profile?.profileImage;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _altPhoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _joiningDateController.dispose();
    _passwordController.dispose();
    _bankNameController.dispose();
    _bankAccountNoController.dispose();
    _ifscCodeController.dispose();
    _branchNameController.dispose();
    super.dispose();
  }

  String? _nullableText(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  Future<void> _pickProfileImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (!mounted || pickedFile == null) {
        return;
      }

      setState(() {
        _selectedProfileImage = pickedFile.path;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to pick image: $error')));
    }
  }

  Future<void> _pickJoiningDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _joiningDate ?? DateTime(now.year - 1),
      firstDate: DateTime(1990),
      lastDate: now,
    );

    if (!mounted || pickedDate == null) {
      return;
    }

    setState(() {
      _joiningDate = pickedDate;
      _joiningDateController.text = _dateFormatter.format(pickedDate);
    });
  }

  void _saveProfile() {
    final profile = _profile;

    if (profile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No profile data available to update')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final updatedProfile = profile.copyWith(
      name: _fullNameController.text.trim(),
      profileImage: _selectedProfileImage,
      phone: _phoneController.text.trim(),
      altPhone: _nullableText(_altPhoneController),
      email: _emailController.text.trim(),
      address: _nullableText(_addressController),
      joiningDate: _joiningDate,
      password: _nullableText(_passwordController),
      bankName: _nullableText(_bankNameController),
      bankAccountNo: _nullableText(_bankAccountNoController),
      ifscCode: _nullableText(_ifscCodeController),
      branchName: _nullableText(_branchNameController),
    );

    ref.read(profileNotifierProvider.notifier).updateProfile(updatedProfile);

    setState(() {
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
    context.pop();
  }

  Widget _buildImagePreview() {
    final imagePath = _selectedProfileImage;

    if (imagePath == null || imagePath.isEmpty) {
      return const Icon(Iconsax.user, size: 52, color: AppColors.primary);
    }

    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Iconsax.user, size: 52, color: AppColors.primary),
      );
    }

    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Iconsax.user, size: 52, color: AppColors.primary),
      );
    }

    return Image.file(
      File(imagePath),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          const Icon(Iconsax.user, size: 52, color: AppColors.primary),
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.tagline.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.quaternary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
    bool readOnly = false,
    bool obscureText = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
        readOnly: readOnly,
        obscureText: obscureText,
        onTap: onTap,
        style: AppTypography.body.copyWith(color: AppColors.black),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.primary),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: readOnly ? AppColors.surface200 : AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            borderSide: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: TextFormField(
        initialValue: value,
        enabled: false,
        style: AppTypography.body.copyWith(color: AppColors.black),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.quaternary),
          filled: true,
          fillColor: AppColors.surface200,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            borderSide: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
    );
  }

  String _formatAmount(double? value) {
    if (value == null) {
      return 'Not assigned';
    }

    final asWhole = value.truncateToDouble() == value;
    return asWhole
        ? 'Rs ${value.toStringAsFixed(0)}'
        : 'Rs ${value.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentProfileProvider);

    if (profile == null) {
      return Scaffold(
        appBar: const MRAppBar(
          showBack: true,
          showActions: false,
          titleText: 'Update Profile',
          subtitleText: 'Profile details unavailable',
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No profile data available'),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  style: AppButtonStyles.primaryButton(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final territories = profile.territoriesOfWork.isEmpty
        ? (profile.territory ?? 'Not assigned')
        : profile.territoriesOfWork.join(', ');

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const MRAppBar(
        showBack: true,
        showActions: false,
        titleText: 'Update Profile',
        subtitleText: 'Edit allowed profile details',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickProfileImage,
                      child: Container(
                        width: 112,
                        height: 112,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryLight,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(child: _buildImagePreview()),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Tap to change profile picture',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.quaternary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildSection(
                title: 'Personal Details',
                subtitle: 'These details can be updated by the ASM.',
                children: [
                  _buildTextField(
                    controller: _fullNameController,
                    label: 'Full Name',
                    icon: Iconsax.user,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Full name is required';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    icon: Iconsax.call,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Phone number is required';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _altPhoneController,
                    label: 'Alternative Phone Number',
                    icon: Iconsax.call_calling,
                    keyboardType: TextInputType.phone,
                  ),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Iconsax.sms,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }
                      if (!value.contains('@')) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _addressController,
                    label: 'Address',
                    icon: Iconsax.location,
                    maxLines: 3,
                  ),
                  _buildTextField(
                    controller: _joiningDateController,
                    label: 'Joining Date',
                    icon: Iconsax.calendar_1,
                    readOnly: true,
                    onTap: _pickJoiningDate,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Joining date is required';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _passwordController,
                    label: 'Password',
                    icon: Iconsax.password_check,
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword ? Iconsax.eye_slash : Iconsax.eye,
                        color: AppColors.quaternary,
                      ),
                    ),
                  ),
                ],
              ),
              _buildSection(
                title: 'Bank Details',
                subtitle: 'Keep payout details current.',
                children: [
                  _buildTextField(
                    controller: _bankNameController,
                    label: 'Bank Name',
                    icon: Iconsax.bank,
                  ),
                  _buildTextField(
                    controller: _bankAccountNoController,
                    label: 'Bank Account Number',
                    icon: Iconsax.card,
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextField(
                    controller: _ifscCodeController,
                    label: 'IFSC Code',
                    icon: Iconsax.code,
                  ),
                  _buildTextField(
                    controller: _branchNameController,
                    label: 'Branch Name',
                    icon: Iconsax.building,
                  ),
                ],
              ),
              _buildSection(
                title: 'Locked Work Details',
                subtitle:
                    'These fields are maintained by the organization and cannot be changed here.',
                children: [
                  _buildReadOnlyField(
                    label: 'MR ID',
                    value: profile.mrId ?? profile.id,
                    icon: Iconsax.profile_2user,
                  ),
                  _buildReadOnlyField(
                    label: 'Headquarter Assigned',
                    value: profile.headquarterAssigned ?? 'Not assigned',
                    icon: Iconsax.buildings,
                  ),
                  _buildReadOnlyField(
                    label: 'Territories of Work',
                    value: territories,
                    icon: Iconsax.map,
                  ),
                  _buildReadOnlyField(
                    label: 'Monthly Target',
                    value: _formatAmount(profile.monthlyTarget),
                    icon: Iconsax.chart_2,
                  ),
                ],
              ),
              _buildSection(
                title: 'Locked Salary Details',
                subtitle:
                    'These compensation values are displayed for reference only.',
                children: [
                  _buildReadOnlyField(
                    label: 'Basic Salary',
                    value: _formatAmount(profile.basicSalary),
                    icon: Iconsax.wallet_1,
                  ),
                  _buildReadOnlyField(
                    label: 'Daily Allowances',
                    value: _formatAmount(profile.dailyAllowances),
                    icon: Iconsax.wallet_1,
                  ),
                  _buildReadOnlyField(
                    label: 'HRA',
                    value: _formatAmount(profile.hra),
                    icon: Iconsax.wallet_1,
                  ),
                  _buildReadOnlyField(
                    label: "Children's Education Allowance",
                    value: _formatAmount(profile.childrenEducationAllowance),
                    icon: Iconsax.wallet_1,
                  ),
                  _buildReadOnlyField(
                    label: 'Special Allowance',
                    value: _formatAmount(profile.specialAllowance),
                    icon: Iconsax.wallet_1,
                  ),
                  _buildReadOnlyField(
                    label: 'Phone Allowance',
                    value: _formatAmount(profile.phoneAllowance),
                    icon: Iconsax.wallet_1,
                  ),
                  _buildReadOnlyField(
                    label: 'Medical Allowance',
                    value: _formatAmount(profile.medicalAllowance),
                    icon: Iconsax.wallet_1,
                  ),
                  _buildReadOnlyField(
                    label: 'ESIC',
                    value: _formatAmount(profile.esic),
                    icon: Iconsax.wallet_minus,
                  ),
                  _buildReadOnlyField(
                    label: 'Total Monthly Salary',
                    value: _formatAmount(profile.totalMonthlySalary),
                    icon: Iconsax.receipt_item,
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveProfile,
                style: AppButtonStyles.primaryButton(height: 52),
                child: Text(
                  _isSaving ? 'Saving...' : 'Save Profile',
                  style: AppTypography.buttonLarge.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

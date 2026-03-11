import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/chemist_shop.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chemist_shop_provider.dart';
import '../../theme/app_theme.dart';

class AddEditChemistShopScreen extends ConsumerStatefulWidget {
  final ChemistShop? shop;

  const AddEditChemistShopScreen({super.key, this.shop});

  @override
  ConsumerState<AddEditChemistShopScreen> createState() =>
      _AddEditChemistShopScreenState();
}

class _AddEditChemistShopScreenState
    extends ConsumerState<AddEditChemistShopScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _descriptionController;
  File? _selectedImage;
  File? _selectedBankPassbookImage;
  bool _isSubmitting = false;
  final ImagePicker _imagePicker = ImagePicker();

  bool get _isEditing => widget.shop != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.shop?.name);
    _phoneController = TextEditingController(text: widget.shop?.phoneNo);
    _emailController = TextEditingController(text: widget.shop?.email);
    _addressController = TextEditingController(text: widget.shop?.address);
    _descriptionController = TextEditingController(
      text: widget.shop?.description,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() => _selectedImage = File(pickedFile.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      }
    }
  }

  Future<void> _pickBankPassbookImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() => _selectedBankPassbookImage = File(pickedFile.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking passbook photo: $e')),
        );
      }
    }
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Shop name and phone number are required'),
        ),
      );
      return;
    }

    final asmId = ref.read(authNotifierProvider).asmId;
    if (asmId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not authenticated. Please log in again.'),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final shop = ChemistShop(
        id: widget.shop?.id ?? '',
        asmId: asmId,
        name: name,
        phoneNo: phone,
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        address: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        location: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );

      final photoPath = _selectedImage?.path;
      final bankPassbookPhotoPath = _selectedBankPassbookImage?.path;

      if (_isEditing) {
        await ref
            .read(chemistShopNotifierProvider.notifier)
            .updateShop(
              asmId: asmId,
              shopId: widget.shop!.id,
              shop: shop,
              photoPath: photoPath,
              bankPassbookPhotoPath: bankPassbookPhotoPath,
            );
      } else {
        await ref
            .read(chemistShopNotifierProvider.notifier)
            .addShop(
              asmId: asmId,
              shop: shop,
              photoPath: photoPath,
              bankPassbookPhotoPath: bankPassbookPhotoPath,
            );
      }

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine existing photo to show (network URL or local file)
    final existingPhotoUrl = widget.shop?.photoUrl;
    final showNetworkPhoto =
        _selectedImage == null &&
        existingPhotoUrl != null &&
        existingPhotoUrl.startsWith('http');
    final existingBankPassbookPhotoUrl = widget.shop?.bankPassbookPhotoUrl;
    final showNetworkBankPassbookPhoto =
        _selectedBankPassbookImage == null &&
        existingBankPassbookPhotoUrl != null &&
        existingBankPassbookPhotoUrl.startsWith('http');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_circle_left, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          _isEditing ? 'Edit Chemist Shop' : 'Add Chemist Shop',
          style: AppTypography.h3.copyWith(color: AppColors.primary),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Photo Upload Section
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryLight, width: 2),
                  color: AppColors.primaryLight.withAlpha(50),
                ),
                child: _selectedImage != null
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedImage = null),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(100),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Iconsax.close_circle,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : showNetworkPhoto
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          existingPhotoUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (_, _, _) =>
                              _buildPhotoPlaceholder(),
                        ),
                      )
                    : _buildPhotoPlaceholder(),
              ),
            ),
            const SizedBox(height: 24),
            // Bank Passbook Photo Upload Section
            GestureDetector(
              onTap: _pickBankPassbookImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryLight, width: 2),
                  color: AppColors.primaryLight.withAlpha(50),
                ),
                child: _selectedBankPassbookImage != null
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.file(
                              _selectedBankPassbookImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => setState(
                                () => _selectedBankPassbookImage = null,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(100),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Iconsax.close_circle,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : showNetworkBankPassbookPhoto
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          existingBankPassbookPhotoUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (_, _, _) =>
                              _buildBankPassbookPhotoPlaceholder(),
                        ),
                      )
                    : _buildBankPassbookPhotoPlaceholder(),
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _nameController,
              label: 'Shop Name',
              hint: 'Enter shop name',
              icon: Iconsax.shop,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              hint: 'Enter phone number',
              icon: Iconsax.call,
              isRequired: true,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'Enter email address',
              icon: Iconsax.sms,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _addressController,
              label: 'Address',
              hint: 'Enter full address',
              icon: Iconsax.location,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Enter shop description',
              icon: Iconsax.document_text,
              maxLines: 4,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primary.withAlpha(100),
                  elevation: 4,
                  shadowColor: AppColors.primary.withAlpha(100),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : Icon(
                        _isEditing ? Iconsax.tick_circle : Iconsax.add_circle,
                        color: AppColors.white,
                        size: 24,
                      ),
                label: Text(
                  _isEditing ? 'Update Shop' : 'Add Shop',
                  style: AppTypography.h3.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.image, size: 48, color: AppColors.primary),
          const SizedBox(height: 12),
          Text(
            'Upload Shop Photo',
            style: AppTypography.body.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap to select image from gallery',
            style: AppTypography.caption.copyWith(
              color: AppColors.quaternary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankPassbookPhotoPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.document, size: 48, color: AppColors.primary),
          const SizedBox(height: 12),
          Text(
            'Upload Bank Passbook Photo',
            style: AppTypography.body.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap to select passbook image',
            style: AppTypography.caption.copyWith(
              color: AppColors.quaternary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTypography.body.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: AppTypography.body.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.body.copyWith(color: AppColors.quaternary),
            prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
            filled: true,
            fillColor: AppColors.primaryLight.withAlpha(50),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryLight,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryLight,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          style: AppTypography.body.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }
}

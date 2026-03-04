import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/distributor.dart';
import '../../providers/distributor_provider.dart';
import '../../theme/app_theme.dart';

class AddEditDistributorScreen extends ConsumerStatefulWidget {
  final Distributor? distributor;

  const AddEditDistributorScreen({super.key, this.distributor});

  @override
  ConsumerState<AddEditDistributorScreen> createState() =>
      _AddEditDistributorScreenState();
}

class _AddEditDistributorScreenState
    extends ConsumerState<AddEditDistributorScreen> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _minOrderController;
  late TextEditingController _deliveryTimeController;
  late TextEditingController _descriptionController;
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.distributor?.name);
    _locationController =
        TextEditingController(text: widget.distributor?.location);
    _phoneController =
        TextEditingController(text: widget.distributor?.phoneNo);
    _emailController = TextEditingController(text: widget.distributor?.email);
    _addressController =
        TextEditingController(text: widget.distributor?.address);
    _minOrderController = TextEditingController(
        text: widget.distributor?.minimumOrderValue.toString());
    _deliveryTimeController =
        TextEditingController(text: widget.distributor?.deliveryTime);
    _descriptionController =
        TextEditingController(text: widget.distributor?.description);
    if (widget.distributor?.photoUrl != null) {
      _selectedImage = File(widget.distributor!.photoUrl!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _minOrderController.dispose();
    _deliveryTimeController.dispose();
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
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _saveDistributor() {
    if (_nameController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final distributor = Distributor(
      id: widget.distributor?.id ?? DateTime.now().toString(),
      name: _nameController.text,
      location: _locationController.text,
      phoneNo: _phoneController.text,
      email: _emailController.text,
      address: _addressController.text,
      photoUrl: _selectedImage?.path ?? widget.distributor?.photoUrl,
      minimumOrderValue:
          double.tryParse(_minOrderController.text) ?? 10000,
      deliveryTime: _deliveryTimeController.text,
      description: _descriptionController.text,
    );

    if (widget.distributor != null) {
      ref
          .read(distributorNotifierProvider.notifier)
          .updateDistributor(distributor);
    } else {
      ref
          .read(distributorNotifierProvider.notifier)
          .addDistributor(distributor);
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.distributor != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_circle_left,
              color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isEditing ? 'Edit Distributor' : 'Add Distributor',
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
                  border: Border.all(
                    color: AppColors.primaryLight,
                    width: 2,
                  ),
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
                              onTap: () => setState(() => _selectedImage = null),
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
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.image,
                              size: 48,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Upload Distributor Photo',
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
                      ),
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _nameController,
              label: 'Distributor Name',
              hint: 'Enter distributor name',
              icon: Iconsax.box,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _locationController,
              label: 'Location',
              hint: 'Enter location',
              icon: Iconsax.location,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              hint: 'Enter phone number',
              icon: Iconsax.call,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'Enter email address',
              icon: Iconsax.sms,
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
              controller: _minOrderController,
              label: 'Minimum Order Value',
              hint: 'Enter minimum order',
              icon: Iconsax.box_1,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _deliveryTimeController,
              label: 'Delivery Time',
              hint: 'e.g., 24-48 hours',
              icon: Iconsax.truck_fast,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Enter distributor description',
              icon: Iconsax.document_text,
              maxLines: 4,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveDistributor,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 4,
                  shadowColor: AppColors.primary.withAlpha(100),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: Icon(
                  isEditing ? Iconsax.edit : Iconsax.add,
                  color: AppColors.white,
                  size: 22,
                ),
                label: Text(
                  isEditing ? 'Update Distributor' : 'Add Distributor',
                  style: AppTypography.body.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
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
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: AppTypography.body.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.body.copyWith(
              color: AppColors.quaternary,
              fontSize: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryLight,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.primaryLight,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: AppColors.white,
          ),
          style: AppTypography.body.copyWith(
            color: AppColors.primary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

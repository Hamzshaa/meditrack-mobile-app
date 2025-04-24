import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditrack/models/pharmacy.dart';
import 'package:meditrack/providers/pharmacy_provider.dart';
import 'package:meditrack/presentation/widgets/image_input_widget.dart';
import 'package:meditrack/core/constants.dart';
import 'package:meditrack/presentation/widgets/shared/curved_sliver_app_bar_delegate.dart';

class PharmacyFormPage extends ConsumerStatefulWidget {
  final Pharmacy? pharmacy;

  const PharmacyFormPage({this.pharmacy, super.key});

  @override
  ConsumerState<PharmacyFormPage> createState() => _PharmacyFormPageState();
}

class _PharmacyFormPageState extends ConsumerState<PharmacyFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool get _isEditing => widget.pharmacy != null;

  late TextEditingController _managerFirstNameController;
  late TextEditingController _managerLastNameController;
  late TextEditingController _managerEmailController;
  late TextEditingController _managerPhoneController;
  late TextEditingController _pharmacyNameController;
  late TextEditingController _addressController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  late TextEditingController _pharmacyEmailController;
  late TextEditingController _pharmacyPhoneController;

  List<XFile> _pickedImages = [];
  List<String> _existingImageUrls = [];

  static const double _maxHeaderHeight = kToolbarHeight + 100.0;
  static const double _minHeaderExtraPadding = 16.0;

  @override
  void initState() {
    super.initState();
    final p = widget.pharmacy;
    _managerFirstNameController =
        TextEditingController(text: p?.managerFirstName ?? '');
    _managerLastNameController =
        TextEditingController(text: p?.managerLastName ?? '');
    _managerEmailController =
        TextEditingController(text: p?.managerEmail ?? '');
    _managerPhoneController =
        TextEditingController(text: p?.managerPhone ?? '');
    _pharmacyNameController = TextEditingController(text: p?.name ?? '');
    _addressController = TextEditingController(text: p?.address ?? '');
    _latitudeController = TextEditingController(text: p?.latitude ?? '');
    _longitudeController = TextEditingController(text: p?.longitude ?? '');
    _pharmacyEmailController = TextEditingController(text: p?.email ?? '');
    _pharmacyPhoneController =
        TextEditingController(text: p?.phoneNumber ?? '');

    if (_isEditing && p != null) {
      _existingImageUrls = p.images.map((img) => img.imageUrl).toList();
    }
  }

  @override
  void dispose() {
    _managerFirstNameController.dispose();
    _managerLastNameController.dispose();
    _managerEmailController.dispose();
    _managerPhoneController.dispose();
    _pharmacyNameController.dispose();
    _addressController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _pharmacyEmailController.dispose();
    _pharmacyPhoneController.dispose();
    super.dispose();
  }

  void _onImagesPicked(List<XFile> images) {
    setState(() {
      _pickedImages = images;
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fix the errors in the form.'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    if (_isLoading) return;

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isEditing) {
        await ref.read(pharmacyListProvider.notifier).updatePharmacy(
              widget.pharmacy!.pharmacyId,
              managerFirstName: _managerFirstNameController.text,
              managerLastName: _managerLastNameController.text,
              managerEmail: _managerEmailController.text,
              managerPhone: _managerPhoneController.text,
              pharmacyName: _pharmacyNameController.text,
              address: _addressController.text,
              latitude: _latitudeController.text,
              longitude: _longitudeController.text,
              pharmacyEmail: _pharmacyEmailController.text.isEmpty
                  ? null
                  : _pharmacyEmailController.text,
              pharmacyPhone: _pharmacyPhoneController.text,
              images: _pickedImages.isNotEmpty ? _pickedImages : null,
            );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Pharmacy updated successfully!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );

          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/admin/pharmacies/${widget.pharmacy!.pharmacyId}');
          }
        }
      } else {
        await ref.read(pharmacyListProvider.notifier).addPharmacy(
              managerFirstName: _managerFirstNameController.text,
              managerLastName: _managerLastNameController.text,
              managerEmail: _managerEmailController.text,
              managerPhone: _managerPhoneController.text,
              pharmacyName: _pharmacyNameController.text,
              address: _addressController.text,
              latitude: _latitudeController.text,
              longitude: _longitudeController.text,
              pharmacyEmail: _pharmacyEmailController.text.isEmpty
                  ? null
                  : _pharmacyEmailController.text,
              pharmacyPhone: _pharmacyPhoneController.text,
              images: _pickedImages,
            );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Pharmacy created successfully!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );

          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/admin/pharmacies');
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    final double minHeaderHeight =
        kToolbarHeight + statusBarHeight + _minHeaderExtraPadding;

    final headerGradient = LinearGradient(
      colors: [colorScheme.primary, colorScheme.primary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            delegate: CurvedSliverAppBarDelegate(
              maxHeaderHeight: _maxHeaderHeight,
              minHeaderHeight: minHeaderHeight,
              gradient: headerGradient,
              foregroundColor: colorScheme.onPrimary,
              titleText: _isEditing ? 'Edit Pharmacy' : 'Add New Pharmacy',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => context.pop(),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save_rounded),
                    onPressed: _isLoading ? null : _submitForm,
                    tooltip: 'Save Pharmacy',
                  ),
                ),
              ],
            ),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(bottom: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.surface,
                    colorScheme.surfaceContainerLowest,
                  ],
                ),
              ),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildSectionHeader(
                        context,
                        icon: Icons.store_mall_directory_rounded,
                        title: 'Pharmacy Details',
                      ),
                      const SizedBox(height: 20),
                      _buildTextFormField(
                        controller: _pharmacyNameController,
                        label: 'Pharmacy Name',
                        icon: Icons.business_rounded,
                        isRequired: true,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _addressController,
                        label: 'Address',
                        icon: Icons.location_on_rounded,
                        isRequired: true,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _pharmacyPhoneController,
                        label: 'Pharmacy Phone',
                        icon: Icons.phone_rounded,
                        keyboardType: TextInputType.phone,
                        isRequired: true,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _pharmacyEmailController,
                        label: 'Pharmacy Email (Optional)',
                        icon: Icons.email_rounded,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextFormField(
                              controller: _latitudeController,
                              label: 'Latitude',
                              icon: Icons.pin_drop_rounded,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              isRequired: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextFormField(
                              controller: _longitudeController,
                              label: 'Longitude',
                              icon: Icons.pin_drop_rounded,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              isRequired: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSectionHeader(
                        context,
                        icon: Icons.person_rounded,
                        title: 'Manager Details',
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextFormField(
                                controller: _managerFirstNameController,
                                label: 'First Name',
                                icon: Icons.person_outline_rounded,
                                isRequired: true),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextFormField(
                                controller: _managerLastNameController,
                                label: 'Last Name',
                                icon: Icons.person_outline_rounded,
                                isRequired: true),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _managerPhoneController,
                        label: 'Phone',
                        icon: Icons.phone_android_rounded,
                        keyboardType: TextInputType.phone,
                        isRequired: true,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _managerEmailController,
                        label: 'Email',
                        icon: Icons.alternate_email_rounded,
                        keyboardType: TextInputType.emailAddress,
                        isRequired: true,
                      ),
                      const SizedBox(height: 24),
                      _buildSectionHeader(
                        context,
                        icon: Icons.photo_library_rounded,
                        title: 'Pharmacy Images',
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: colorScheme.surfaceContainerHigh,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ImageInputWidget(
                              existingImageUrls: _isEditing
                                  ? _existingImageUrls
                                      .map(
                                          (relPath) => '$mediaBaseUrl/$relPath')
                                      .toList()
                                  : [],
                              onImagesPicked: _onImagesPicked,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (_isLoading)
                        Center(
                          child: CircularProgressIndicator(
                            color: colorScheme.primary,
                          ),
                        )
                      else
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            icon: const Icon(Icons.save_rounded),
                            label: Text(
                              _isEditing
                                  ? 'UPDATE PHARMACY'
                                  : 'CREATE PHARMACY',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _submitForm,
                          ),
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isRequired = false,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8),
            child: RichText(
              text: TextSpan(
                text: label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.8),
                ),
                children: [
                  if (isRequired)
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: colorScheme.error,
                      ),
                    ),
                ],
              ),
            ),
          ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 1.5,
              ),
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHigh,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            errorMaxLines: 2,
          ),
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator ??
              (value) {
                if (isRequired && (value == null || value.isEmpty)) {
                  return 'This field is required';
                }
                if (label.toLowerCase().contains('email') &&
                    value != null &&
                    value.isNotEmpty &&
                    (!value.contains('@') || !value.contains('.'))) {
                  return 'Please enter a valid email';
                }

                if (label.toLowerCase().contains('phone') &&
                    value != null &&
                    value.isNotEmpty &&
                    !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
                        .hasMatch(value)) {
                  return 'Please enter a valid phone number';
                }
                if ((label.toLowerCase().contains('latitude') ||
                        label.toLowerCase().contains('longitude')) &&
                    value != null &&
                    value.isNotEmpty &&
                    double.tryParse(value) == null) {
                  return 'Invalid number';
                }
                return null;
              },
        ),
      ],
    );
  }
}

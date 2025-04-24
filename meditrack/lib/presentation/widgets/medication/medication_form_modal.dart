import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditrack/models/medication.dart';
import 'package:meditrack/providers/medication_provider.dart';

class MedicationFormModal extends ConsumerStatefulWidget {
  final Medication? medicationToEdit;

  const MedicationFormModal({super.key, this.medicationToEdit});

  @override
  ConsumerState<MedicationFormModal> createState() =>
      _MedicationFormModalState();
}

class _MedicationFormModalState extends ConsumerState<MedicationFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _brandNameController;
  late TextEditingController _genericNameController;
  late TextEditingController _strengthController;
  late TextEditingController _manufacturerController;
  late TextEditingController _reorderPointController;
  late TextEditingController _descriptionController;

  String? _selectedDosageForm;
  int? _selectedCategoryId;
  bool _isLoading = false;

  final List<String> _dosageForms = const [
    'tablet',
    'capsule',
    'liquid',
    'injection',
    'cream',
    'ointment',
    'syrup'
  ];

  @override
  void initState() {
    super.initState();
    final med = widget.medicationToEdit;
    _brandNameController =
        TextEditingController(text: med?.medicationBrandName ?? '');
    _genericNameController =
        TextEditingController(text: med?.medicationGenericName ?? '');
    _strengthController = TextEditingController(text: med?.strength ?? '');
    _manufacturerController =
        TextEditingController(text: med?.manufacturer ?? '');
    _reorderPointController =
        TextEditingController(text: med?.reorderPoint?.toString() ?? '');
    _descriptionController =
        TextEditingController(text: med?.description ?? '');
    _selectedDosageForm = med?.dosageForm;
    _selectedCategoryId = med?.categoryId;

    if (_selectedDosageForm != null &&
        !_dosageForms.contains(_selectedDosageForm)) {
      _selectedDosageForm = null;
    }
  }

  @override
  void dispose() {
    _brandNameController.dispose();
    _genericNameController.dispose();
    _strengthController.dispose();
    _manufacturerController.dispose();
    _reorderPointController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _selectedCategoryId != null &&
        _selectedDosageForm != null) {
      setState(() {
        _isLoading = true;
      });

      final notifier = ref.read(pharmacyMedicationsNotifierProvider.notifier);

      try {
        if (widget.medicationToEdit == null) {
          await notifier.addMedication(
            medicationBrandName: _brandNameController.text.trim(),
            medicationGenericName: _genericNameController.text.trim(),
            dosageForm: _selectedDosageForm!,
            strength: _strengthController.text.trim(),
            manufacturer: _manufacturerController.text.trim(),
            reorderPoint:
                int.tryParse(_reorderPointController.text.trim()) ?? 0,
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            categoryId: _selectedCategoryId!,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Medication added successfully'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        } else {
          await notifier.updateMedication(
            medicationId: widget.medicationToEdit!.medicationId,
            medicationBrandName: _brandNameController.text.trim(),
            medicationGenericName: _genericNameController.text.trim(),
            dosageForm: _selectedDosageForm!,
            strength: _strengthController.text.trim(),
            manufacturer: _manufacturerController.text.trim(),
            reorderPoint:
                int.tryParse(_reorderPointController.text.trim()) ?? 0,
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            categoryId: _selectedCategoryId!,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Medication updated successfully'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Error: ${e.toString().replaceFirst("Exception: ", "")}'),
              backgroundColor: Theme.of(context).colorScheme.error,
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
    } else {
      if (_selectedCategoryId == null || _selectedDosageForm == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Please ensure all required fields (including dropdowns) are selected.'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isRequired = false,
    TextInputType? keyboardType,
    int? maxLines,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          maxLines: maxLines,
          validator: validator,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEditMode = widget.medicationToEdit != null;

    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              top: 24,
              left: 24,
              right: 24),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.medication_rounded,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEditMode ? 'Edit Medication' : 'Add New Medication',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTextFormField(
                        controller: _brandNameController,
                        label: 'Brand Name',
                        icon: Icons.medication_outlined,
                        isRequired: true,
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Please enter a brand name'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _genericNameController,
                        label: 'Generic Name',
                        icon: Icons.medical_services_outlined,
                        isRequired: true,
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Please enter a generic name'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 8),
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Dosage Form',
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onSurface
                                            .withOpacity(0.8),
                                      ),
                                      children: const [
                                        TextSpan(
                                          text: ' *',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DropdownButtonFormField<String>(
                                  value: _selectedDosageForm,
                                  items: _dosageForms
                                      .map((form) => DropdownMenuItem(
                                            value: form,
                                            child: Text(
                                              form[0].toUpperCase() +
                                                  form.substring(1),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) => setState(
                                      () => _selectedDosageForm = value),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.format_list_bulleted,
                                      color: colorScheme.onSurface
                                          .withOpacity(0.6),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: colorScheme.outline
                                            .withOpacity(0.3),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: colorScheme.outline
                                            .withOpacity(0.3),
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
                                      vertical: 0,
                                      horizontal: 16,
                                    ),
                                    errorMaxLines: 2,
                                  ),
                                  validator: (value) => (value == null)
                                      ? 'Please select a dosage form'
                                      : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: _buildTextFormField(
                              controller: _strengthController,
                              label: 'Strength',
                              icon: Icons.exposure,
                              isRequired: true,
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                      ? 'Required'
                                      : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _manufacturerController,
                        label: 'Manufacturer',
                        icon: Icons.business_outlined,
                        isRequired: true,
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Please enter manufacturer'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, bottom: 8),
                            child: RichText(
                              text: TextSpan(
                                text: 'Category',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.8),
                                ),
                                children: const [
                                  TextSpan(
                                    text: ' *',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ref.watch(medicationCategoriesNotifierProvider).when(
                                data: (categories) {
                                  final validCategoryIds = categories
                                      .map((c) => c.categoryId)
                                      .toList();
                                  if (_selectedCategoryId != null &&
                                      !validCategoryIds
                                          .contains(_selectedCategoryId)) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (mounted) {
                                        setState(() {
                                          _selectedCategoryId = null;
                                        });
                                      }
                                    });
                                  }

                                  return DropdownButtonFormField<int>(
                                    value: _selectedCategoryId,
                                    items: categories
                                        .map((category) =>
                                            DropdownMenuItem<int>(
                                              value: category.categoryId,
                                              child:
                                                  Text(category.categoryName),
                                            ))
                                        .toList(),
                                    onChanged: (value) => setState(
                                        () => _selectedCategoryId = value),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.category_outlined,
                                        color: colorScheme.onSurface
                                            .withOpacity(0.6),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: colorScheme.outline
                                              .withOpacity(0.3),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: colorScheme.outline
                                              .withOpacity(0.3),
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
                                      fillColor:
                                          colorScheme.surfaceContainerHigh,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 0,
                                        horizontal: 16,
                                      ),
                                      errorMaxLines: 2,
                                    ),
                                    validator: (value) => (value == null)
                                        ? 'Please select a category'
                                        : null,
                                    isExpanded: true,
                                  );
                                },
                                loading: () => Container(
                                  height: 56,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerHigh,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                      child: CircularProgressIndicator()),
                                ),
                                error: (err, stack) => Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: colorScheme.errorContainer
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Error loading categories',
                                    style: TextStyle(color: colorScheme.error),
                                  ),
                                ),
                              ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _reorderPointController,
                        label: 'Reorder Point',
                        icon: Icons.inventory_2_outlined,
                        isRequired: true,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Please enter reorder point';
                          if (int.tryParse(value) == null)
                            return 'Must be a number';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _descriptionController,
                        label: 'Description (Optional)',
                        icon: Icons.description_outlined,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(
                                  color: colorScheme.outline.withOpacity(0.3),
                                ),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _isLoading ? null : _submitForm,
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(isEditMode
                                      ? 'Save Changes'
                                      : 'Add Medication'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
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

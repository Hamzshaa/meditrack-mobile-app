import 'package:meditrack/models/medication.dart';
import 'package:flutter/material.dart';

class MedicationDetailsModal extends StatelessWidget {
  final Medication medication;

  const MedicationDetailsModal({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24,
          ),
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
                    'Medication Details',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      context,
                      icon: Icons.medication_outlined,
                      label: 'Brand Name',
                      value: medication.medicationBrandName,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      context,
                      icon: Icons.medical_services_outlined,
                      label: 'Generic Name',
                      value: medication.medicationGenericName,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildDetailRow(
                            context,
                            icon: Icons.format_list_bulleted,
                            label: 'Dosage Form',
                            value: medication.dosageForm[0].toUpperCase() +
                                medication.dosageForm.substring(1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: _buildDetailRow(
                            context,
                            icon: Icons.exposure,
                            label: 'Strength',
                            value: medication.strength,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      context,
                      icon: Icons.business_outlined,
                      label: 'Manufacturer',
                      value: medication.manufacturer,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      context,
                      icon: Icons.category_outlined,
                      label: 'Category',
                      value: medication.categoryName ?? 'N/A',
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      context,
                      icon: Icons.inventory_2_outlined,
                      label: 'Reorder Point',
                      value: medication.reorderPoint?.toString() ?? 'N/A',
                    ),
                    if (medication.description?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        context,
                        icon: Icons.description_outlined,
                        label: 'Description',
                        value: medication.description!,
                        maxLines: 3,
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: colorScheme.onSurface.withOpacity(0.6),
                size: 20,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  value,
                  style: theme.textTheme.bodyMedium,
                  maxLines: maxLines,
                  overflow: maxLines > 1
                      ? TextOverflow.ellipsis
                      : TextOverflow.visible,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

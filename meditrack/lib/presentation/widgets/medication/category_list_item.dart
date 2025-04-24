import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditrack/models/medication_category.dart';
import 'package:meditrack/providers/medication_provider.dart';
import 'package:meditrack/presentation/widgets/medication/category_form_modal.dart';
import 'package:meditrack/presentation/widgets/shared/delete_confirmation_dialog.dart';

class CategoryListItem extends ConsumerWidget {
  final MedicationCategory category;

  const CategoryListItem({super.key, required this.category});

  void _showEditModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => CategoryFormModal(categoryToEdit: category),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return DeleteConfirmationDialog(
          itemName: category.categoryName,
          onConfirm: () async {
            Navigator.of(dialogContext).pop();
            try {
              await ref
                  .read(medicationCategoriesNotifierProvider.notifier)
                  .deleteCategory(category.categoryId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('${category.categoryName} deleted successfully.'),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to delete category: $e'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.category_rounded,
            color: colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          category.categoryName,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.edit_rounded,
                color: colorScheme.primary,
              ),
              onPressed: () => _showEditModal(context),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.primary.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                Icons.delete_rounded,
                color: colorScheme.error,
              ),
              onPressed: () => _showDeleteConfirmation(context, ref),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.error.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        onTap: () => _showEditModal(context),
      ),
    );
  }
}

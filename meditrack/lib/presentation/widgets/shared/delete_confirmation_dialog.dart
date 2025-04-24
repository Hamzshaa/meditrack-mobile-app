// presentation/widgets/shared/delete_confirmation_dialog.dart
import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String itemName;
  final String itemType; // e.g., "medication", "category"
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    super.key,
    required this.itemName,
    required this.onConfirm,
    this.itemType = 'item', // Default item type
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: theme.colorScheme.error),
          const SizedBox(width: 10),
          const Text('Confirm Deletion'),
        ],
      ),
      content: RichText(
        text: TextSpan(
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          children: <TextSpan>[
            TextSpan(
                text:
                    'Are you sure you want to permanently delete the $itemType '),
            TextSpan(
              text: '"$itemName"',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: '? This action cannot be undone.'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
          ),
          onPressed: onConfirm, // Call the provided confirm callback
          child: const Text('Delete'),
        ),
      ],
    );
  }
}

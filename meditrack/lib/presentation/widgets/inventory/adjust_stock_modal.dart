import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditrack/models/inventory.dart';
import 'package:meditrack/providers/inventory_provider.dart';

class AdjustStockModal extends ConsumerStatefulWidget {
  final InventoryTable batch;
  final bool isDeduct;

  const AdjustStockModal({
    super.key,
    required this.batch,
    required this.isDeduct,
  });

  @override
  ConsumerState<AdjustStockModal> createState() => _AdjustStockModalState();
}

class _AdjustStockModalState extends ConsumerState<AdjustStockModal> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final quantity = int.parse(_quantityController.text.trim());

      try {
        print(
            'Adjusting quantity: $quantity for ${widget.isDeduct ? 'deduct' : 'add'}');
        final notifier = ref.read(inventoryNotifierProvider.notifier);
        if (widget.isDeduct) {
          await notifier.deductInventory(
            inventoryId: widget.batch.inventoryId,
            quantity: quantity,
          );
        } else {
          await notifier.addToInventory(
            inventoryId: widget.batch.inventoryId,
            quantity: quantity,
          );
        }

        if (!context.mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Quantity ${widget.isDeduct ? 'deducted' : 'added'} successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to adjust quantity: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentQuantity = widget.batch.quantity;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.isDeduct ? 'Deduct Stock' : 'Add Stock',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Batch: ${widget.batch.batchNumber}',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.8),
                    ),
                    children: [
                      const TextSpan(text: 'Current: '),
                      TextSpan(
                        text: '$currentQuantity',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: widget.isDeduct
                              ? Colors.orange.shade700
                              : Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText:
                        'Quantity to ${widget.isDeduct ? 'deduct' : 'add'}',
                    labelStyle: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.6)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: widget.isDeduct
                            ? Colors.orange.shade700
                            : Colors.green.shade700,
                        width: 2,
                      ),
                    ),
                    prefixIcon: Icon(
                      widget.isDeduct ? Icons.remove : Icons.add,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: colorScheme.onSurface),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the quantity';
                    }
                    final int? quantity = int.tryParse(value);
                    if (quantity == null || quantity <= 0) {
                      return 'Please enter a valid positive quantity';
                    }
                    if (widget.isDeduct && quantity > currentQuantity) {
                      return 'Cannot deduct more than available ($currentQuantity)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: FilledButton.styleFrom(
                    backgroundColor: widget.isDeduct
                        ? Colors.orange.shade700
                        : Colors.green.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          widget.isDeduct ? 'Deduct Stock' : 'Add Stock',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:meditrack/models/inventory.dart';
import 'package:meditrack/providers/inventory_provider.dart';
import 'package:meditrack/presentation/widgets/inventory/add_batch_modal.dart';
import 'package:meditrack/presentation/widgets/inventory/adjust_stock_modal.dart';
import 'package:meditrack/presentation/widgets/inventory/edit_batch_modal.dart';
import 'package:meditrack/presentation/widgets/inventory/stock_level_indicator.dart';

class InventoryDetailModal extends ConsumerStatefulWidget {
  final Inventory inventory;

  const InventoryDetailModal({super.key, required this.inventory});

  @override
  ConsumerState<InventoryDetailModal> createState() =>
      _InventoryDetailModalState();
}

class _InventoryDetailModalState extends ConsumerState<InventoryDetailModal> {
  InventoryTable? _selectedBatch;

  @override
  void initState() {
    super.initState();
    widget.inventory.inventory.sort((a, b) {
      final dateA = a.expirationDate ?? DateTime(1900);
      final dateB = b.expirationDate ?? DateTime(1900);
      return dateA.compareTo(dateB);
    });
  }

  void _showAddBatchModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          AddBatchModal(medicationId: widget.inventory.medicationId),
    ).then((_) {
      // Refresh inventory list after modal closes
      ref.invalidate(inventoryNotifierProvider);
      // Potentially refresh the specific item if needed, but list refresh is simpler
    });
  }

  void _showEditBatchModal(BuildContext context, InventoryTable batch) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => EditBatchModal(
          batch: batch, medicationId: widget.inventory.medicationId),
    ).then((_) {
      ref.invalidate(inventoryNotifierProvider);
      setState(() {
        // If the edited batch was selected, clear selection or update if possible
        // For simplicity, just clear. The list will refresh anyway.
        _selectedBatch = null;
      });
    });
  }

  void _showAdjustStockModal(BuildContext context, InventoryTable batch,
      {required bool isDeduct}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AdjustStockModal(batch: batch, isDeduct: isDeduct),
    ).then((_) {
      ref.invalidate(inventoryNotifierProvider);
      setState(() {
        _selectedBatch = null; // Clear selection after adjustment
      });
    });
  }

  void _confirmDeleteBatch(BuildContext context, InventoryTable batch) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text(
              'Are you sure you want to delete batch "${batch.batchNumber}"? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Close the dialog
                try {
                  await ref
                      .read(inventoryNotifierProvider.notifier)
                      .deleteInventory(batch.inventoryId);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Batch deleted successfully'),
                        backgroundColor: Colors.green),
                  );
                  ref.invalidate(inventoryNotifierProvider); // Refresh list
                  setState(() {
                    _selectedBatch = null; // Clear selection
                  });
                  // Optionally close the main modal if the last batch was deleted
                  // if (widget.inventory.inventory.length == 1) { // Check before invalidation maybe?
                  //   Navigator.pop(context);
                  // }
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Failed to delete batch: $e'),
                        backgroundColor: Colors.red),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final inventoryData =
        ref.watch(inventoryNotifierProvider).asData?.value.firstWhere(
                  (item) => item.medicationId == widget.inventory.medicationId,
                  orElse: () => widget.inventory,
                ) ??
            widget.inventory;

    inventoryData.inventory.sort((a, b) {
      final dateA = a.expirationDate ?? DateTime(1900);
      final dateB = b.expirationDate ?? DateTime(1900);
      return dateA.compareTo(dateB);
    });

    if (_selectedBatch != null &&
        !inventoryData.inventory
            .any((b) => b.inventoryId == _selectedBatch!.inventoryId)) {
      _selectedBatch = null;
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      snap: true,
      snapSizes: const [0.6, 0.9],
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 16,
              spreadRadius: 0,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: colorScheme.outline.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Medication Info Card
                  Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: colorScheme.outline.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            inventoryData.medicationBrandName,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${inventoryData.medicationGenericName} • ${inventoryData.strength} ${inventoryData.dosageForm}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (inventoryData.manufacturer.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Manufacturer: ${inventoryData.manufacturer}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          if (inventoryData.description?.isNotEmpty ??
                              false) ...[
                            const SizedBox(height: 8),
                            Text(
                              inventoryData.description!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Stock Level Card
                  Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: colorScheme.outline.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Stock Level',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: inventoryData.totalQuantity <=
                                          inventoryData.reorderPoint
                                      ? Colors.red.shade50
                                      : colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${inventoryData.totalQuantity}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: inventoryData.totalQuantity <=
                                            inventoryData.reorderPoint
                                        ? Colors.red.shade700
                                        : colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Reorder at ${inventoryData.reorderPoint}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 12),
                          StockLevelIndicator(
                            currentQuantity: inventoryData.totalQuantity,
                            reorderPoint: inventoryData.reorderPoint,
                            maxQuantity: (inventoryData.reorderPoint * 2)
                                .clamp(inventoryData.totalQuantity + 10, 10000),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Add Batch Button
                  FilledButton.icon(
                    onPressed: () => _showAddBatchModal(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add New Batch'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Text(
                    'Batches',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                ]),
              ),
            ),

            // Batch Chips
            if (inventoryData.inventory.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 48,
                        color: colorScheme.onSurface.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No batches added yet',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Add a batch to track inventory',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 120,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 2.5,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final batch = inventoryData.inventory[index];
                      final isExpired = batch.expirationDate != null &&
                          batch.expirationDate!.isBefore(DateTime.now());
                      final expiringSoon = batch.expirationDate != null &&
                          !isExpired &&
                          batch.expirationDate!.isBefore(
                              DateTime.now().add(const Duration(days: 90)));

                      return FilterChip(
                        label: Text(
                          batch.batchNumber,
                          style: TextStyle(
                            color: isExpired
                                ? Colors.red.shade700
                                : (expiringSoon
                                    ? Colors.orange.shade700
                                    : colorScheme.onSurface),
                          ),
                        ),
                        selected:
                            _selectedBatch?.inventoryId == batch.inventoryId,
                        onSelected: (selected) {
                          setState(() {
                            _selectedBatch = selected ? batch : null;
                          });
                        },
                        selectedColor: colorScheme.primaryContainer,
                        backgroundColor: colorScheme.surfaceVariant,
                        checkmarkColor: colorScheme.onPrimaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: isExpired
                                ? Colors.red.shade300
                                : (expiringSoon
                                    ? Colors.orange.shade300
                                    : colorScheme.outline.withOpacity(0.3)),
                            width: 1,
                          ),
                        ),
                        avatar: isExpired
                            ? Icon(Icons.warning_amber_rounded,
                                size: 16, color: Colors.red.shade700)
                            : (expiringSoon
                                ? Icon(Icons.timer_outlined,
                                    size: 16, color: Colors.orange.shade700)
                                : null),
                      );
                    },
                    childCount: inventoryData.inventory.length,
                  ),
                ),
              ),

            // Selected Batch Details
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              sliver: SliverToBoxAdapter(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: _selectedBatch == null
                      ? const SizedBox.shrink()
                      : Card(
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: colorScheme.outline.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Batch Details',
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      iconSize: 20,
                                      onPressed: () {
                                        setState(() {
                                          _selectedBatch = null;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                _buildDetailRow(
                                    context,
                                    Icons.numbers,
                                    'Batch Number:',
                                    _selectedBatch!.batchNumber),
                                _buildDetailRow(
                                    context,
                                    Icons.inventory_2_outlined,
                                    'Quantity:',
                                    _selectedBatch!.quantity.toString()),
                                _buildDetailRow(
                                  context,
                                  Icons.calendar_today,
                                  'Expiration:',
                                  _selectedBatch!.expirationDate != null
                                      ? DateFormat('MMM dd, yyyy').format(
                                          _selectedBatch!.expirationDate!)
                                      : 'Not set',
                                  valueColor:
                                      (_selectedBatch!.expirationDate != null &&
                                              _selectedBatch!.expirationDate!
                                                  .isBefore(DateTime.now()))
                                          ? Colors.red.shade700
                                          : null,
                                ),
                                _buildDetailRow(
                                  context,
                                  Icons.update,
                                  'Last Updated:',
                                  _selectedBatch!.lastUpdated != null
                                      ? DateFormat('MMM dd, yyyy')
                                          .format(_selectedBatch!.lastUpdated!)
                                      : 'N/A',
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildActionButton(
                                      context,
                                      Icons.edit,
                                      'Edit',
                                      Colors.blue,
                                      () => _showEditBatchModal(
                                          context, _selectedBatch!),
                                    ),
                                    _buildActionButton(
                                      context,
                                      Icons.remove,
                                      'Deduct',
                                      Colors.orange,
                                      () => _showAdjustStockModal(
                                          context, _selectedBatch!,
                                          isDeduct: true),
                                    ),
                                    _buildActionButton(
                                      context,
                                      Icons.add,
                                      'Add',
                                      Colors.green,
                                      () => _showAdjustStockModal(
                                          context, _selectedBatch!,
                                          isDeduct: false),
                                    ),
                                    _buildActionButton(
                                      context,
                                      Icons.delete,
                                      'Delete',
                                      Colors.red,
                                      () => _confirmDeleteBatch(
                                          context, _selectedBatch!),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, IconData icon, String label, String value,
      {Color? valueColor}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: valueColor ?? colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label,
      Color color, VoidCallback onPressed) {
    return Column(
      children: [
        IconButton.filled(
          onPressed: onPressed,
          icon: Icon(icon, size: 20),
          style: IconButton.styleFrom(
            backgroundColor: color.withOpacity(0.1),
            foregroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
        ),
      ],
    );
  }
}

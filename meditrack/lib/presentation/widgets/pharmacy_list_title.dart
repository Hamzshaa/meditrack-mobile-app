import 'package:flutter/material.dart';
import 'package:meditrack/models/pharmacy.dart';

class PharmacyListTile extends StatelessWidget {
  final Pharmacy pharmacy;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PharmacyListTile({
    required this.pharmacy,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pharmacy.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    _buildInfoRow(
                      context,
                      icon: Icons.location_on_outlined,
                      text: pharmacy.address,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    _buildInfoRow(
                      context,
                      icon: Icons.person_outline,
                      text:
                          'Manager: ${pharmacy.managerFirstName} ${pharmacy.managerLastName}',
                    ),
                    const SizedBox(height: 4),
                    _buildInfoRow(
                      context,
                      icon: Icons.phone_outlined,
                      text: 'Phone: ${pharmacy.phoneNumber}',
                    ),
                    if (pharmacy.email != null &&
                        pharmacy.email!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      _buildInfoRow(
                        context,
                        icon: Icons.email_outlined,
                        text: 'Email: ${pharmacy.email}',
                      ),
                    ]
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Chip(
                    label: Text('ID: ${pharmacy.pharmacyId}'),
                    labelStyle: textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                    backgroundColor:
                        theme.colorScheme.secondaryContainer.withOpacity(0.7),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    side: BorderSide.none,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onEdit != null)
                        _buildActionButton(
                          context: context,
                          icon: Icons.edit_outlined,
                          color: Colors.blue.shade700,
                          tooltip: 'Edit',
                          onPressed: onEdit!,
                        ),
                      if (onEdit != null && onDelete != null)
                        const SizedBox(width: 4),
                      if (onDelete != null)
                        _buildActionButton(
                          context: context,
                          icon: Icons.delete_outline,
                          color: Colors.red.shade700,
                          tooltip: 'Delete',
                          onPressed: onDelete!,
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context,
      {required IconData icon, required String text, int maxLines = 1}) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: textTheme.bodyMedium?.copyWith(color: Colors.grey.shade800),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}

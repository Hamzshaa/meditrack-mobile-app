import 'package:flutter/material.dart';

enum PharmacyEmptyStateType { noPharmacies, noResults }

class PharmacyEmptyStateSliver extends StatelessWidget {
  final PharmacyEmptyStateType type;
  final String? query;

  const PharmacyEmptyStateSliver({
    super.key,
    required this.type,
    this.query,
  });

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: type == PharmacyEmptyStateType.noPharmacies
          ? _buildNoPharmacies(context)
          : _buildNoResults(context, query ?? ''),
    );
  }

  Widget _buildNoPharmacies(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_pharmacy_outlined,
              size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('No pharmacies found.', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('Tap the + button to add one.',
              style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildNoResults(BuildContext context, String query) {
    final theme = Theme.of(context);
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No pharmacies match "$query"',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text('Try searching for something else.',
              style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
}

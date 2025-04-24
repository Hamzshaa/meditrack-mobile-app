import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Use if retry needs ref
import 'package:meditrack/providers/pharmacy_provider.dart'; // Import provider for retry

class PharmacyErrorSliver extends ConsumerWidget {
  // Use ConsumerWidget
  final Object error;
  // final VoidCallback onRetry; // Or invalidate directly

  const PharmacyErrorSliver({
    super.key,
    required this.error,
    // required this.onRetry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Add ref
    final theme = Theme.of(context);
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 60, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'Error loading pharmacies',
              style: theme.textTheme.titleLarge
                  ?.copyWith(color: Colors.red.shade700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text('$error',
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              onPressed: () =>
                  ref.invalidate(pharmacyListProvider), // Use ref to invalidate
            )
          ],
        ),
      ),
    );
  }
}

// presentation/widgets/shared/error_display.dart
import 'package:flutter/material.dart';
import 'package:meditrack/data/services/location_service.dart'; // Import location exceptions if used

class ErrorDisplay extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;

  const ErrorDisplay({
    super.key,
    required this.error,
    this.onRetry,
  });

  // Helper to get a user-friendly message (similar to the one in HomePage)
  String _getFriendlyErrorMessage(Object error) {
    if (error is LocationServiceDisabledException) {
      return 'Location services are disabled. Please enable them in your device settings.';
    } else if (error is LocationPermissionDeniedException) {
      return 'Location permission was denied. Please grant permission to proceed.';
    } else if (error is LocationPermissionDeniedForeverException) {
      return 'Location permission was permanently denied. Please grant permission in app settings.';
    } else if (error
        .toString()
        .contains('Authentication token is null or empty')) {
      return 'Authentication failed or session expired. Please log out and log back in.';
    } else if (error
        .toString()
        .contains('Authentication token is still loading')) {
      return 'Authenticating... Please wait a moment.'; // Or just show loading?
    } else if (error.toString().contains('Failed host lookup') ||
        error.toString().contains('SocketException')) {
      return 'Network error. Please check your internet connection and try again.';
    } else if (error.toString().contains('Failed to fetch') ||
        error.toString().contains('Failed to load')) {
      return 'Could not load data. Please check your connection and try again.';
    }
    // Generic fallback - remove "Exception: " prefix if present
    return error.toString().replaceFirst('Exception: ', '');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final friendlyMessage = _getFriendlyErrorMessage(error);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: theme.colorScheme.error,
              size: 50,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              friendlyMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  foregroundColor: theme.colorScheme.onError,
                  backgroundColor: theme.colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

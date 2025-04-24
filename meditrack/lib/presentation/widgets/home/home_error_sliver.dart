import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditrack/data/services/location_service.dart';
import 'package:meditrack/providers/location_provider.dart';

class HomeErrorSliver extends ConsumerWidget {
  final Object error;
  final VoidCallback onRetry;

  const HomeErrorSliver({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: _buildErrorWidget(context, ref, error, onRetry),
    );
  }

  Widget _buildErrorWidget(
      BuildContext context, WidgetRef ref, Object error, VoidCallback onRetry) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final errorMessage = _getErrorMessage(error);
    bool isLocationError = error is LocationServiceDisabledException ||
        error is LocationPermissionDeniedException ||
        error is LocationPermissionDeniedForeverException;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
              isLocationError
                  ? Icons.location_off_outlined
                  : Icons.error_outline_rounded,
              size: 60,
              color: colorScheme.error),
          const SizedBox(height: 16),
          Text('Oops! Something went wrong.',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(color: colorScheme.error),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(errorMessage,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          if (isLocationError)
            ElevatedButton.icon(
                icon: const Icon(Icons.settings_outlined),
                label: const Text('Open Location Settings'),
                style: ElevatedButton.styleFrom(
                    foregroundColor: colorScheme.onErrorContainer,
                    backgroundColor: colorScheme.errorContainer),
                onPressed: () =>
                    ref.read(currentLocationProvider.notifier).openSettings()),
          if (isLocationError) const SizedBox(height: 10),
          ElevatedButton.icon(
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry Search'),
              style: ElevatedButton.styleFrom(
                  foregroundColor: colorScheme.onPrimary,
                  backgroundColor: colorScheme.primary),
              onPressed: onRetry),
        ],
      ),
    );
  }

  String _getErrorMessage(Object error) {
    if (error is LocationServiceDisabledException) {
      return 'Location services are disabled. Please enable them in your device settings to find nearby pharmacies.';
    } else if (error is LocationPermissionDeniedException) {
      return 'Location permission was denied. Please grant permission through the app settings to find nearby pharmacies.';
    } else if (error is LocationPermissionDeniedForeverException) {
      return 'Location permission was permanently denied. Please go to your app settings and grant location permission to find nearby pharmacies.';
    } else if (error.toString().contains('Could not get location')) {
      return 'Could not determine your location. Please ensure location services are enabled and permissions are granted.';
    } else if (error.toString().contains('token is null or empty')) {
      return 'Authentication failed. Please try logging out and back in.';
    } else if (error.toString().contains('Failed host lookup') ||
        error.toString().contains('SocketException')) {
      return 'Network error. Please check your internet connection and try again.';
    }
    String specificError = error.toString();
    if (specificError.length > 150) {
      specificError = "${specificError.substring(0, 150)}...";
    }
    return 'An error occurred while loading medication data: $specificError. Please try again.';
  }
}

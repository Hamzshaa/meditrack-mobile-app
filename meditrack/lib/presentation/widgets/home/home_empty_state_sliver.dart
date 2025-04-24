import 'package:flutter/material.dart';

enum EmptyStateType { prompt, noResults }

class HomeEmptyStateSliver extends StatelessWidget {
  final EmptyStateType type;
  final String? query;

  const HomeEmptyStateSliver({
    super.key,
    required this.type,
    this.query,
  });

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: type == EmptyStateType.prompt
          ? _buildSearchPrompt(context)
          : _buildNoResultsFound(context, query ?? ''),
    );
  }

  Widget _buildSearchPrompt(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_rounded,
              size: 80, color: colorScheme.primary.withOpacity(0.6)),
          const SizedBox(height: 20),
          Text('Find Medications Near You',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(color: colorScheme.onSurface),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
              'Enter a medication name or brand in the search bar above to begin.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildNoResultsFound(BuildContext context, String query) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              size: 80, color: colorScheme.secondary.withOpacity(0.6)),
          const SizedBox(height: 20),
          Text('No Matches Found',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(color: colorScheme.onSurface),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
              children: [
                const TextSpan(
                    text: 'We couldn\'t find any medications matching '),
                TextSpan(
                    text: '"$query"',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface)),
                const TextSpan(
                    text:
                        '.\nTry checking the spelling or using a different term.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

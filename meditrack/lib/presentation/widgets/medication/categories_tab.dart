import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditrack/providers/medication_provider.dart';
import 'package:meditrack/presentation/screens/medication_management_page.dart';
import 'package:meditrack/presentation/widgets/medication/category_list_item.dart';
import 'package:meditrack/presentation/widgets/shared/error_display.dart';
import 'package:meditrack/presentation/widgets/shared/loading_indicator.dart';

class CategoriesTab extends ConsumerWidget {
  const CategoriesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categoriesAsync = ref.watch(medicationCategoriesNotifierProvider);
    final searchQuery = ref.watch(categorySearchQueryProvider);

    Future<void> refreshCategories() async {
      ref.invalidate(medicationCategoriesNotifierProvider);
    }

    return RefreshIndicator(
      color: colorScheme.primary,
      onRefresh: refreshCategories,
      child: categoriesAsync.when(
        data: (categories) {
          final filteredCategories = searchQuery.isEmpty
              ? categories
              : categories
                  .where((cat) => cat.categoryName
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()))
                  .toList();

          if (filteredCategories.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.category_rounded,
                      size: 48,
                      color: colorScheme.onSurface.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      searchQuery.isEmpty
                          ? 'No categories found'
                          : 'No matches for "$searchQuery"',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (searchQuery.isEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Tap the + button to add a new category',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            itemCount: filteredCategories.length,
            itemBuilder: (context, index) {
              if (index == filteredCategories.length - 1) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: kBottomNavigationBarHeight),
                      child: CategoryListItem(
                        category: filteredCategories[index],
                      ),
                    ),
                  ],
                );
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CategoryListItem(category: filteredCategories[index]),
              );
            },
          );
        },
        loading: () => const LoadingIndicator(message: 'Loading categories...'),
        error: (error, stack) =>
            ErrorDisplay(error: error, onRetry: refreshCategories),
      ),
    );
  }
}

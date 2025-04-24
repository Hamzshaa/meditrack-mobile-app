import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditrack/providers/medication_provider.dart';
import 'package:meditrack/presentation/screens/medication_management_page.dart';
import 'package:meditrack/presentation/widgets/medication/medication_list_item.dart';
import 'package:meditrack/presentation/widgets/shared/error_display.dart';
import 'package:meditrack/presentation/widgets/shared/loading_indicator.dart';

class MedicationsTab extends ConsumerWidget {
  const MedicationsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final medicationsAsync = ref.watch(pharmacyMedicationsNotifierProvider);
    final searchQuery = ref.watch(medicationSearchQueryProvider);

    Future<void> refreshMedications() async {
      ref.invalidate(medicationsNotifierProvider);
    }

    return RefreshIndicator(
      color: colorScheme.primary,
      onRefresh: refreshMedications,
      child: medicationsAsync.when(
        data: (medications) {
          final filteredMedications = searchQuery.isEmpty
              ? medications
              : medications
                  .where((med) =>
                      med.medicationBrandName
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()) ||
                      med.medicationGenericName
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()) ||
                      med.manufacturer
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()))
                  .toList();

          if (filteredMedications.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.medication_rounded,
                      size: 48,
                      color: colorScheme.onSurface.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      searchQuery.isEmpty
                          ? 'No medications found'
                          : 'No matches for "$searchQuery"',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (searchQuery.isEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Tap the + button to add a new medication',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.4),
                        ),
                        textAlign: TextAlign.center,
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
            itemCount: filteredMedications.length,
            itemBuilder: (context, index) {
              if (index == filteredMedications.length - 1) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: kBottomNavigationBarHeight),
                      child: MedicationListItem(
                        medication: filteredMedications[index],
                      ),
                    ),
                  ],
                );
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: MedicationListItem(
                  medication: filteredMedications[index],
                ),
              );
            },
          );
        },
        loading: () =>
            const LoadingIndicator(message: 'Loading medications...'),
        error: (error, stack) => ErrorDisplay(
          error: error,
          onRetry: refreshMedications,
        ),
      ),
    );
  }
}

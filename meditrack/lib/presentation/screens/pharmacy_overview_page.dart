import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:meditrack/models/pharmacy_overview_data.dart';
import 'package:meditrack/presentation/widgets/shared/app_drawer.dart';
import 'package:meditrack/presentation/widgets/pharmacy_overview/expiring_soon_list.dart';
import 'package:meditrack/presentation/widgets/pharmacy_overview/recent_medications_list.dart';
import 'package:meditrack/presentation/widgets/shared/theme_toggle_button.dart';
import 'package:meditrack/providers/pharmacy_provider.dart';
import 'package:meditrack/presentation/widgets/pharmacy_overview/stat_card.dart';
import 'package:meditrack/presentation/widgets/pharmacy_overview/section_header.dart';
import 'package:meditrack/providers/user_provider.dart';

class PharmacyOverviewPage extends ConsumerWidget {
  const PharmacyOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewAsyncValue = ref.watch(pharmacyOverviewProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final DateFormat dateFormat = DateFormat('dd MMM yyyy');
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: null,
        centerTitle: false,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
        actions: [
          const ThemeToggleButton(),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(pharmacyOverviewProvider);
            },
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      drawer: currentUser != null ? AppDrawer(currentUser: currentUser) : null,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary.withAlpha(15),
              colorScheme.primary.withAlpha(5),
            ],
          ),
        ),
        child: RefreshIndicator(
          color: colorScheme.primary,
          onRefresh: () async {
            ref.invalidate(pharmacyOverviewProvider);
            await ref.read(pharmacyOverviewProvider.future);
          },
          child: overviewAsyncValue.when(
            data: (data) {
              final pharmacy = data.pharmacy;
              final stats = data.stats;

              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pharmacy Dashboard',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Comprehensive overview of your pharmacy',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Divider(
                            color: colorScheme.outline.withOpacity(0.1),
                            height: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverToBoxAdapter(
                      child: _buildPharmacyInfoCard(pharmacy, theme),
                    ),
                  ),
                  const SliverPadding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: SectionHeader(
                        title: 'Inventory Metrics',
                        icon: Icons.query_stats,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    sliver: SliverToBoxAdapter(
                      child: _buildStatsGrid(stats, theme),
                    ),
                  ),
                  const SliverPadding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: SectionHeader(
                        title: 'Recent Additions',
                        icon: Icons.history,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    sliver: SliverToBoxAdapter(
                      child: RecentMedicationsList(
                        medications: data.recentMedications,
                        dateFormat: dateFormat,
                        theme: theme,
                      ),
                    ),
                  ),
                  const SliverPadding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: SectionHeader(
                        title: 'Expiring Soon',
                        icon: Icons.hourglass_bottom_rounded,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                    sliver: SliverToBoxAdapter(
                      child: ExpiringSoonList(
                        expiring: data.expiringSoon,
                        dateFormat: dateFormat,
                        theme: theme,
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => Center(
              child: CircularProgressIndicator(
                color: colorScheme.primary,
              ),
            ),
            error: (error, stackTrace) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.errorContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error_outline,
                        size: 40,
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Failed to Load Data',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      error is Exception
                          ? error.toString().replaceFirst("Exception: ", "")
                          : 'An unknown error occurred.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => ref.invalidate(pharmacyOverviewProvider),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPharmacyInfoCard(PharmacyData pharmacy, ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.store_rounded,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    pharmacy.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoRow(
              Icons.location_on_rounded,
              pharmacy.address,
              theme,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.phone_rounded,
              pharmacy.phoneNumber,
              theme,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.email_rounded,
              pharmacy.email,
              theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 18,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(Stats stats, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final criticalColor = Colors.red.shade600;
    final warningColor = Colors.orange.shade700;
    final primaryColor = colorScheme.primary;
    final secondaryColor = colorScheme.secondary;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 0.8,
        children: [
          StatCard(
            icon: Icons.medication_rounded,
            value: stats.totalMedications.toString(),
            label: 'Medications',
            iconColor: primaryColor,
          ),
          StatCard(
            icon: Icons.inventory_rounded,
            value: stats.totalQuantity,
            label: 'Total Units',
            iconColor: secondaryColor,
          ),
          StatCard(
            icon: Icons.warning_rounded,
            value: stats.nearExpiry.toString(),
            label: 'Near Expiry',
            iconColor: warningColor,
            backgroundColor: warningColor.withOpacity(0.08),
          ),
          StatCard(
            icon: Icons.error_outline_rounded,
            value: stats.expiredBatches.toString(),
            label: 'Expired',
            iconColor: criticalColor,
            backgroundColor: criticalColor.withOpacity(0.08),
          ),
          StatCard(
            icon: Icons.add_shopping_cart_rounded,
            value: stats.reorderNeeded.toString(),
            label: 'Reorder',
            iconColor: warningColor,
            backgroundColor: warningColor.withOpacity(0.08),
          ),
          StatCard(
            icon: Icons.remove_shopping_cart_rounded,
            value: stats.outOfStock.toString(),
            label: 'Out of Stock',
            iconColor: criticalColor,
            backgroundColor: criticalColor.withOpacity(0.08),
          ),
          StatCard(
            icon: Icons.layers_rounded,
            value: stats.totalBatches.toString(),
            label: 'Total Batches',
            iconColor: secondaryColor,
          ),
        ],
      ),
    );
  }
}

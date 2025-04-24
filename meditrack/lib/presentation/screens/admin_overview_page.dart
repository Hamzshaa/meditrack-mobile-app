import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditrack/models/admin_overview_data.dart';
import 'package:meditrack/presentation/widgets/shared/app_drawer.dart';
import 'package:meditrack/presentation/widgets/shared/theme_toggle_button.dart';
import 'package:meditrack/providers/admin_provider.dart';
import 'package:meditrack/presentation/widgets/admin_overview/admin_summary_card.dart';
import 'package:meditrack/presentation/widgets/recent_comment_list_item.dart';
import 'package:meditrack/providers/user_provider.dart';

class AdminOverviewPage extends ConsumerWidget {
  const AdminOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminDataAsync = ref.watch(adminOverviewProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: null, // Removed title
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
              ref.invalidate(adminOverviewProvider);
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
              colorScheme.primary.withAlpha((255 * 0.03).round()),
              colorScheme.primary.withAlpha((255 * 0.01).round()),
            ],
          ),
        ),
        child: RefreshIndicator(
          color: colorScheme.primary,
          onRefresh: () async {
            ref.invalidate(adminOverviewProvider);
            await ref.read(adminOverviewProvider.future);
          },
          child: adminDataAsync.when(
            loading: () => Center(
              child: CircularProgressIndicator(
                color: colorScheme.primary,
              ),
            ),
            error: (error, stackTrace) {
              return Center(
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
                        'Failed to Load Overview',
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
                          color: colorScheme.onSurface
                              .withAlpha((255 * 0.7).round()),
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
                        onPressed: () => ref.invalidate(adminOverviewProvider),
                      ),
                    ],
                  ),
                ),
              );
            },
            data: (data) => _buildOverviewContent(
              context,
              theme,
              colorScheme,
              data,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewContent(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    AdminOverviewData data,
  ) {
    return CustomScrollView(
      slivers: [
        // New Overview Header Section
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard Overview',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Summary of your pharmacy management system',
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
        // Existing Content
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummarySection(context, theme, colorScheme, data),
                const SizedBox(height: 28),
                _buildRecentCommentsSection(
                    theme, colorScheme, data.recentComments),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummarySection(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    AdminOverviewData data,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.insights_rounded,
              color: colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Key Metrics',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            AdminSummaryCard(
              icon: Icons.store_rounded,
              title: 'Pharmacies',
              value: data.totalPharmacies.toString(),
              iconColor: Colors.teal,
              backgroundColor: Colors.teal.withOpacity(0.1),
              elevation: 2,
            ),
            AdminSummaryCard(
              icon: Icons.comment_rounded,
              title: 'Comments',
              value: data.totalComments.toString(),
              iconColor: Colors.blue,
              backgroundColor: Colors.blue.withOpacity(0.1),
              elevation: 2,
            ),
            AdminSummaryCard(
              icon: Icons.people_rounded,
              title: 'User Roles',
              value: data.userRoles.length.toString(),
              iconColor: Colors.purple,
              backgroundColor: Colors.purple.withOpacity(0.1),
              elevation: 2,
            ),
            AdminSummaryCard(
              icon: Icons.local_pharmacy_rounded,
              title: 'Pharmacy Staff',
              value: data.userRoles[1].count.toString(),
              iconColor: Colors.orange,
              backgroundColor: Colors.orange.withOpacity(0.1),
              elevation: 2,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentCommentsSection(
    ThemeData theme,
    ColorScheme colorScheme,
    List<RecentComment> comments,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.forum_rounded,
              color: colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Recent Activity',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (comments.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.comment_rounded,
                    size: 40,
                    color: colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No recent comments',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Container(
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
            child: Column(
              children: comments
                  .take(5)
                  .map((comment) => RecentCommentListItem(comment: comment))
                  .toList(),
            ),
          ),
      ],
    );
  }
}

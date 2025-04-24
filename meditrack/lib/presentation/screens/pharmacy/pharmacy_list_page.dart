import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditrack/presentation/widgets/shared/theme_toggle_button.dart';
import 'package:meditrack/providers/pharmacy_provider.dart';
import 'package:meditrack/providers/user_provider.dart';
import 'package:meditrack/models/pharmacy.dart';
import 'package:meditrack/presentation/widgets/pharmacy_list_title.dart';
import 'package:meditrack/presentation/widgets/shared/app_drawer.dart';
import 'package:meditrack/presentation/widgets/shared/curved_sliver_app_bar_delegate.dart';
import 'package:meditrack/presentation/widgets/home/home_search_bar.dart';
import 'package:meditrack/presentation/widgets/pharmacy/pharmacy_empty_state_sliver.dart';
import 'package:meditrack/presentation/widgets/pharmacy/pharmacy_error_sliver.dart';

final _searchQueryProvider = StateProvider<String>((ref) => '');

class PharmacyListPage extends ConsumerStatefulWidget {
  const PharmacyListPage({super.key});

  @override
  ConsumerState<PharmacyListPage> createState() => _PharmacyListPageState();
}

class _PharmacyListPageState extends ConsumerState<PharmacyListPage> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  static const double _maxHeaderHeight = 180.0;
  static const double _minHeaderExtraPadding = 10.0;
  static const double _extraScrollPixels = 100.0;

  @override
  void initState() {
    super.initState();
    _searchController.text = ref.read(_searchQueryProvider);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(_searchQueryProvider.notifier).state = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    ref.read(_searchQueryProvider.notifier).state = '';
    _searchController.text = '';
    ref.invalidate(pharmacyListProvider);
    await ref.read(pharmacyListProvider.future);
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, Pharmacy pharmacy) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Pharmacy?'),
        content: Text(
          'Are you sure you want to delete ${pharmacy.name}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref
            .read(pharmacyListProvider.notifier)
            .deletePharmacy(pharmacy.pharmacyId);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('${pharmacy.name} deleted successfully.'),
                backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Error deleting pharmacy: $e'),
                backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pharmacyListAsync = ref.watch(pharmacyListProvider);
    final currentUser = ref.watch(currentUserProvider);
    final searchQuery = ref.watch(_searchQueryProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final router = GoRouter.of(context);
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double minHeaderHeight =
        kToolbarHeight + statusBarHeight + _minHeaderExtraPadding;
    final double screenHeight = MediaQuery.of(context).size.height;
    final headerGradient = LinearGradient(
      colors: [colorScheme.primary, colorScheme.primary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final headerForegroundColor = colorScheme.onPrimary;

    final searchBarWidget = HomeSearchBar(
      controller: _searchController,
      onClear: () {
        _searchController.clear();
        ref.read(_searchQueryProvider.notifier).state = '';
      },
    );

    return Scaffold(
      drawer: currentUser != null ? AppDrawer(currentUser: currentUser) : null,
      body: RefreshIndicator(
        edgeOffset: _maxHeaderHeight - 40,
        color: colorScheme.primary,
        onRefresh: _handleRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          slivers: [
            SliverPersistentHeader(
              delegate: CurvedSliverAppBarDelegate(
                maxHeaderHeight: _maxHeaderHeight,
                minHeaderHeight: minHeaderHeight,
                gradient: headerGradient,
                foregroundColor: headerForegroundColor,
                titleText: 'Pharmacies',
                leading: Builder(
                  builder: (c) => IconButton(
                    icon:
                        Icon(Icons.menu_rounded, color: headerForegroundColor),
                    onPressed: () => Scaffold.of(c).openDrawer(),
                  ),
                ),
                actions: [
                  const ThemeToggleButton(),
                  const SizedBox(width: 8),
                  IconButton(
                      icon: Icon(Icons.refresh_rounded,
                          color: headerForegroundColor),
                      onPressed: _handleRefresh,
                      tooltip: 'Refresh List'),
                ],
              ),
              pinned: true,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                child: searchBarWidget,
              ),
            ),
            pharmacyListAsync.when(
              data: (pharmacies) {
                final filteredPharmacies = pharmacies.where((pharmacy) {
                  final query = searchQuery.toLowerCase().trim();
                  if (query.isEmpty) return true;

                  return pharmacy.name.toLowerCase().contains(query) ||
                      pharmacy.address.toLowerCase().contains(query);
                }).toList();

                if (pharmacies.isEmpty) {
                  return const PharmacyEmptyStateSliver(
                      type: PharmacyEmptyStateType.noPharmacies);
                }
                if (filteredPharmacies.isEmpty && searchQuery.isNotEmpty) {
                  return PharmacyEmptyStateSliver(
                      type: PharmacyEmptyStateType.noResults,
                      query: searchQuery);
                }

                return SliverPadding(
                  padding: const EdgeInsets.only(top: 0, bottom: 80.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final pharmacy = filteredPharmacies[index];
                        return PharmacyListTile(
                          pharmacy: pharmacy,
                          onTap: () => router
                              .go('/admin/pharmacies/${pharmacy.pharmacyId}'),
                          onEdit: () {
                            FocusScope.of(context).unfocus();
                            router.go(
                                '/admin/pharmacies/${pharmacy.pharmacyId}/edit',
                                extra: pharmacy);
                          },
                          onDelete: () =>
                              _confirmDelete(context, ref, pharmacy),
                        );
                      },
                      childCount: filteredPharmacies.length,
                    ),
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator())),
              error: (error, stack) => PharmacyErrorSliver(error: error),
            ),
            SliverLayoutBuilder(
              builder: (BuildContext context, SliverConstraints constraints) {
                final minTotalExtent = screenHeight + _extraScrollPixels;

                final remainingHeightNeeded =
                    minTotalExtent - constraints.precedingScrollExtent;

                final minBoxHeight =
                    remainingHeightNeeded > 0 ? remainingHeightNeeded : 0.0;

                return SliverToBoxAdapter(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: minBoxHeight),
                    child: Container(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          context.go('/admin/pharmacies/new');
        },
        tooltip: 'Add Pharmacy',
        child: const Icon(Icons.add),
      ),
    );
  }
}

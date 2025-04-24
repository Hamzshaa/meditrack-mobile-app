import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditrack/models/inventory.dart';
import 'package:meditrack/presentation/widgets/shared/theme_toggle_button.dart';
import 'package:meditrack/providers/inventory_provider.dart';
import 'package:meditrack/providers/user_provider.dart';
import 'package:meditrack/presentation/widgets/shared/app_drawer.dart';
import 'package:meditrack/presentation/widgets/inventory/inventory_detail_modal.dart';
import 'package:meditrack/presentation/widgets/inventory/inventory_list_item.dart';
import 'package:meditrack/presentation/widgets/inventory/expiring_warning_card.dart';
import 'package:meditrack/presentation/widgets/inventory/expiring_list_modal.dart';
import 'package:meditrack/models/expiring_medication_data.dart';

import 'package:meditrack/presentation/widgets/shared/curved_sliver_app_bar_delegate.dart';
import 'package:meditrack/presentation/widgets/home/home_search_bar.dart';

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  ConsumerState<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  Timer? _debounce;

  AsyncValue<ExpiringMedications> _expiringDataState =
      const AsyncValue.loading();

  bool _isExpiredDismissed = false;
  bool _isExpiringSoonDismissed = false;

  static const double _maxHeaderHeight = 220.0;
  static const double _minHeaderExtraPadding = 10.0;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_onSearchChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fetchExpiringData();
      }
    });
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          _searchTerm = _searchController.text;
        });
      }
    });
  }

  Future<void> _fetchExpiringData() async {
    if (mounted) {
      setState(() {
        _isExpiredDismissed = false;
        _isExpiringSoonDismissed = false;
        _expiringDataState = const AsyncValue.loading();
      });
    }

    try {
      final data = await ref
          .read(inventoryNotifierProvider.notifier)
          .getExpiringMedications();

      if (mounted) {
        setState(() {
          _expiringDataState = AsyncValue.data(data);
        });
      }
    } catch (error, stackTrace) {
      if (mounted) {
        setState(() {
          _expiringDataState = AsyncValue.error(error, stackTrace);
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _showInventoryDetail(BuildContext context, Inventory inventory) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => InventoryDetailModal(inventory: inventory),
    );
  }

  void _showExpiringListModal<T>(
      BuildContext context, String title, List<T> items, bool isExpiredList) {
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No items found for "$title".'),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.grey[700],
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExpiringListModal<T>(
        title: title,
        items: items,
        isExpiredList: isExpiredList,
      ),
    );
  }

  Future<void> _handleRefresh() async {
    ref.invalidate(inventoryNotifierProvider);
    try {
      await Future.wait([
        _fetchExpiringData(),
        ref.read(inventoryNotifierProvider.future),
      ]);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Refresh failed: $e'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final inventoryAsyncValue = ref.watch(inventoryNotifierProvider);
    final currentUser = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    final double minHeaderHeight =
        kToolbarHeight + statusBarHeight + _minHeaderExtraPadding;

    final double bottomPadding = kBottomNavigationBarHeight +
        MediaQuery.of(context).padding.bottom +
        60.0;

    final headerGradient = LinearGradient(
      colors: [colorScheme.primary.withOpacity(0.9), colorScheme.primary],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    final headerForegroundColor = colorScheme.onPrimary;

    final searchBarWidget = HomeSearchBar(
      controller: _searchController,
      onClear: () {
        _searchController.clear();

        setState(() {
          _searchTerm = '';
        });
      },
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        drawer:
            currentUser != null ? AppDrawer(currentUser: currentUser) : null,
        body: RefreshIndicator(
          color: colorScheme.primary,
          backgroundColor: colorScheme.surface,
          edgeOffset: _maxHeaderHeight - 40,
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
                  titleText: 'Inventory',
                  leading: Builder(
                    builder: (BuildContext c) => IconButton(
                        icon: const Icon(Icons.menu_rounded),
                        tooltip: 'Open Menu',
                        onPressed: () => Scaffold.of(c).openDrawer()),
                  ),
                  actions: [
                    const ThemeToggleButton(),
                    const SizedBox(width: 8),
                    IconButton(
                        icon: const Icon(Icons.refresh_rounded),
                        tooltip: 'Refresh Inventory',
                        onPressed: _handleRefresh),
                    const SizedBox(width: 8),
                  ],
                ),
                pinned: true,
              ),
              SliverToBoxAdapter(
                child: _expiringDataState.when(
                  data: (data) {
                    return Column(
                      children: [
                        const SizedBox(height: 16),
                        if (!_isExpiredDismissed &&
                            data.expiredMedications.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 1),
                            child: ExpiringWarningCard(
                              title: 'Expired Items',
                              count: data.expiredMedications.length,
                              icon: Icons.error_outline_rounded,
                              backgroundColor: Colors.red.shade100,
                              iconColor: Colors.red.shade800,
                              onTap: () => _showExpiringListModal(
                                  context,
                                  'Expired Items',
                                  data.expiredMedications,
                                  true),
                              onDismiss: () =>
                                  setState(() => _isExpiredDismissed = true),
                            ),
                          ),
                        if (!_isExpiringSoonDismissed &&
                            data.expiringSoon.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 1),
                            child: ExpiringWarningCard(
                              title: 'Expiring Soon',
                              count: data.expiringSoon.length,
                              icon: Icons.warning_amber_rounded,
                              backgroundColor: Colors.orange.shade100,
                              iconColor: Colors.orange.shade900,
                              onTap: () => _showExpiringListModal(context,
                                  'Expiring Soon', data.expiringSoon, false),
                              onDismiss: () => setState(
                                  () => _isExpiringSoonDismissed = true),
                            ),
                          ),
                        if ((!_isExpiredDismissed &&
                                data.expiredMedications.isNotEmpty) ||
                            (!_isExpiringSoonDismissed &&
                                data.expiringSoon.isNotEmpty))
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0)
                                    .copyWith(top: 8.0),
                            child: Divider(
                                height: 1,
                                thickness: 0.5,
                                color: colorScheme.outlineVariant
                                    .withOpacity(0.3)),
                          ),
                      ],
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                        child: SizedBox(
                            height: 24,
                            width: 24,
                            child:
                                CircularProgressIndicator(strokeWidth: 2.5))),
                  ),
                  error: (error, stackTrace) => Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Material(
                      borderRadius: BorderRadius.circular(12),
                      color: colorScheme.errorContainer.withOpacity(0.5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber_rounded,
                                color: colorScheme.error, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Failed to load warnings',
                                style: TextStyle(
                                    color: colorScheme.onErrorContainer),
                              ),
                            ),
                            IconButton(
                              icon:
                                  Icon(Icons.refresh, color: colorScheme.error),
                              onPressed: _fetchExpiringData,
                              tooltip: 'Retry Warnings',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: searchBarWidget,
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(bottom: bottomPadding),
                sliver: inventoryAsyncValue.when(
                  data: (inventoryList) {
                    final searchTermLower = _searchTerm.toLowerCase();
                    final filteredList = inventoryList.where((inventory) {
                      final brandName =
                          inventory.medicationBrandName.toLowerCase();
                      final genericName =
                          inventory.medicationGenericName.toLowerCase();
                      return brandName.contains(searchTermLower) ||
                          genericName.contains(searchTermLower);
                    }).toList();

                    if (inventoryList.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 64,
                                  color: colorScheme.onSurface.withOpacity(0.3),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Your inventory is empty",
                                  style: theme.textTheme.titleLarge?.copyWith(
                                      color: colorScheme.onSurface
                                          .withOpacity(0.5)),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Tap the '+' button below to add the first item",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: colorScheme.onSurface
                                          .withOpacity(0.4)),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else if (filteredList.isEmpty && _searchTerm.isNotEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 64,
                                  color: colorScheme.onSurface.withOpacity(0.4),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No results for "$_searchTerm"',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                      color: colorScheme.onSurface
                                          .withOpacity(0.6)),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try searching for a different medication name.',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: colorScheme.onSurface
                                          .withOpacity(0.4)),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final inventory = filteredList[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            child: InventoryListItem(
                              key: ValueKey(inventory.medicationId),
                              inventory: inventory,
                              onTap: () =>
                                  _showInventoryDetail(context, inventory),
                            ),
                          );
                        },
                        childCount: filteredList.length,
                      ),
                    );
                  },
                  loading: () => const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (error, stackTrace) => SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline_rounded,
                              size: 48, color: colorScheme.error),
                          const SizedBox(height: 16),
                          Text('Failed to load inventory',
                              style: theme.textTheme.titleLarge
                                  ?.copyWith(color: colorScheme.error)),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              error.toString(),
                              style: TextStyle(
                                  color:
                                      colorScheme.onSurface.withOpacity(0.6)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                              icon: const Icon(Icons.refresh),
                              label: const Text('Try Again'),
                              onPressed: _handleRefresh),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Add Inventory Item - Not Implemented Yet')));
          },
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          tooltip: 'Add Inventory Item',
          child: const Icon(Icons.add_shopping_cart_outlined),
        ),
      ),
    );
  }
}

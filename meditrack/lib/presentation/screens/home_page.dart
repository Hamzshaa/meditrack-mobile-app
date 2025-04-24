// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditrack/models/medication.dart';
import 'package:meditrack/presentation/widgets/home/medication_details_content.dart';
import 'package:meditrack/presentation/widgets/shared/theme_toggle_button.dart';
import 'package:meditrack/providers/medication_provider.dart';
import 'package:meditrack/providers/user_provider.dart';
import 'package:meditrack/presentation/widgets/shared/app_drawer.dart';
import 'package:meditrack/presentation/widgets/home/home_search_bar.dart';
import 'package:meditrack/presentation/widgets/home/medication_list_sliver.dart';
import 'package:meditrack/presentation/widgets/home/home_empty_state_sliver.dart';
import 'package:meditrack/presentation/widgets/home/home_error_sliver.dart';
import 'package:meditrack/presentation/widgets/shared/curved_sliver_app_bar_delegate.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  bool _initialLoadAttempted = false;

  static const double _maxHeaderHeight = 220.0;
  static const double _minHeaderExtraPadding = 10.0;
  static const double _extraScrollPixels = 200.0;

  @override
  void initState() {
    super.initState();
    _searchController.text = ref.read(searchQueryProvider);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text;
      ref.read(searchQueryProvider.notifier).state = query;
      _triggerSearch(query);
    });
  }

  void _triggerSearch(String query) {
    if (!_initialLoadAttempted) {
      _initialLoadAttempted = true;
    }
    ref.read(medicationsNotifierProvider.notifier).search(query);
  }

  Future<void> _handleRefresh() async {
    await ref
        .read(medicationsNotifierProvider.notifier)
        .search(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double minHeaderHeight =
        kToolbarHeight + statusBarHeight + _minHeaderExtraPadding;
    final double screenHeight = MediaQuery.of(context).size.height;
    final medicationsAsync = ref.watch(medicationsNotifierProvider);
    final userState = ref.watch(currentUserNotifierProvider);
    final isLoggedIn = ref.watch(isAuthenticatedProvider);
    final currentUser = ref.watch(currentUserProvider);
    final isSearchEmpty = _searchController.text.isEmpty;
    final headerGradient = LinearGradient(
      colors: [
        colorScheme.primary.withOpacity(0.9),
        colorScheme.primary,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final headerForegroundColor = colorScheme.onPrimary;

    final searchBarWidget = HomeSearchBar(
      controller: _searchController,
      onClear: () {
        _searchController.clear();
        _onSearchChanged();
      },
      onSubmitted: (value) {
        _debounce?.cancel();
        _triggerSearch(value);
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
                title: const Text('MediTrack'),
                leading: isLoggedIn
                    ? Builder(
                        builder: (BuildContext c) => IconButton(
                            icon: const Icon(Icons.menu_rounded),
                            onPressed: () => Scaffold.of(c).openDrawer()))
                    : null,
                actions: [
                  const ThemeToggleButton(),
                  if (!isLoggedIn)
                    userState.maybeWhen(
                        loading: () => Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: headerForegroundColor))),
                        orElse: () => IconButton(
                            icon: Icon(Icons.login_rounded,
                                color: headerForegroundColor),
                            tooltip: 'Login',
                            onPressed: () => context.push("/login"))),
                  const SizedBox(width: 8),
                ],
              ),
              pinned: true,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
                child: searchBarWidget,
              ),
            ),
            _buildSliverContent(context, medicationsAsync, isSearchEmpty),
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
    );
  }

  Widget _buildSliverContent(BuildContext context,
      AsyncValue<List<Medication>> asyncValue, bool isSearchEmpty) {
    return asyncValue.when(
      data: (medications) {
        if ((!_initialLoadAttempted && medications.isEmpty) ||
            (isSearchEmpty && _initialLoadAttempted && medications.isEmpty)) {
          return const HomeEmptyStateSliver(type: EmptyStateType.prompt);
        } else if (!isSearchEmpty && medications.isEmpty) {
          return HomeEmptyStateSliver(
              type: EmptyStateType.noResults, query: _searchController.text);
        } else {
          return MedicationListSliver(
            medications: medications,
            onItemTap: (medication) =>
                _showMedicationDetailsBottomSheet(context, medication),
          );
        }
      },
      loading: () => const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => HomeErrorSliver(
        error: error,
        onRetry: () => _triggerSearch(_searchController.text),
      ),
    );
  }

  void _showMedicationDetailsBottomSheet(
      BuildContext context, Medication medication) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      backgroundColor: theme.cardColor,
      builder: (ctx) {
        return MedicationDetailsContent(medication: medication);
      },
    );
  }
}

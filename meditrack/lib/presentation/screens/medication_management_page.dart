import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditrack/presentation/widgets/shared/theme_toggle_button.dart';
import 'package:meditrack/providers/user_provider.dart';
import 'package:meditrack/presentation/widgets/shared/app_drawer.dart';
import 'package:meditrack/presentation/widgets/medication/categories_tab.dart';
import 'package:meditrack/presentation/widgets/medication/medications_tab.dart';
import 'package:meditrack/presentation/widgets/medication/medication_form_modal.dart';
import 'package:meditrack/presentation/widgets/medication/category_form_modal.dart';

import 'package:meditrack/presentation/widgets/shared/curved_sliver_app_bar_delegate.dart';
import 'package:meditrack/presentation/widgets/home/home_search_bar.dart';

final medicationSearchQueryProvider = StateProvider<String>((ref) => '');
final categorySearchQueryProvider = StateProvider<String>((ref) => '');

class MedicationManagementPage extends ConsumerStatefulWidget {
  const MedicationManagementPage({super.key});

  @override
  ConsumerState<MedicationManagementPage> createState() =>
      _MedicationManagementPageState();
}

class _MedicationManagementPageState
    extends ConsumerState<MedicationManagementPage> {
  int _selectedIndex = 0;
  final _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounce;

  static const double _maxHeaderHeight = 140.0;
  static const double _minHeaderExtraPadding = 10.0;
  static const double _extraScrollPixels = 100.0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      _searchController.text = ref.read(medicationSearchQueryProvider);
      ref.read(categorySearchQueryProvider.notifier).state = '';
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      final query = _searchController.text;

      final targetProvider = _selectedIndex == 0
          ? medicationSearchQueryProvider
          : categorySearchQueryProvider;

      if (ref.read(targetProvider) != query) {
        ref.read(targetProvider.notifier).state = query;
      }
    });
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;

      final currentQuery = ref.read(_selectedIndex == 0
          ? medicationSearchQueryProvider
          : categorySearchQueryProvider);

      if (_searchController.text != currentQuery) {
        _searchController.text = currentQuery;

        _searchController.selection = TextSelection.fromPosition(
            TextPosition(offset: _searchController.text.length));
      }
    });
    _searchFocusNode.unfocus();
  }

  void _openAddModal() {
    _searchFocusNode.unfocus();
    if (_selectedIndex == 0) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: const MedicationFormModal(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: const CategoryFormModal(),
        ),
      );
    }
  }

  Future<void> _handleRefresh() async {
    _searchController.clear();
    ref.read(medicationSearchQueryProvider.notifier).state = '';
    ref.read(categorySearchQueryProvider.notifier).state = '';
    print("Refresh complete on Medication Management Page");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentUser = ref.watch(currentUserProvider);
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double minHeaderHeight =
        kToolbarHeight + statusBarHeight + _minHeaderExtraPadding;
    final double screenHeight = MediaQuery.of(context).size.height;
    final searchBarWidget = HomeSearchBar(
      controller: _searchController,
      onClear: () {
        _searchController.clear();

        final targetProvider = _selectedIndex == 0
            ? medicationSearchQueryProvider
            : categorySearchQueryProvider;
        ref.read(targetProvider.notifier).state = '';
      },
    );

    final headerGradient = LinearGradient(
      colors: [colorScheme.primary, colorScheme.primary],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
    final headerForegroundColor = colorScheme.onPrimary;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        drawer:
            currentUser != null ? AppDrawer(currentUser: currentUser) : null,
        body: RefreshIndicator(
          edgeOffset: _maxHeaderHeight - 40,
          color: colorScheme.primary,
          onRefresh: _handleRefresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverPersistentHeader(
                delegate: CurvedSliverAppBarDelegate(
                  maxHeaderHeight: _maxHeaderHeight,
                  minHeaderHeight: minHeaderHeight,
                  gradient: headerGradient,
                  foregroundColor: headerForegroundColor,
                  titleText: _selectedIndex == 0 ? 'Medications' : 'Categories',
                  leading: Builder(
                    builder: (BuildContext c) => IconButton(
                        icon: const Icon(Icons.menu_rounded),
                        tooltip: 'Open Menu',
                        onPressed: () => Scaffold.of(c).openDrawer()),
                  ),
                  actions: const [
                    ThemeToggleButton(),
                    SizedBox(width: 16),
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
              SliverFillRemaining(
                hasScrollBody: true,
                fillOverscroll: true,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        theme.colorScheme.surface,
                        theme.colorScheme.surfaceContainerLowest
                      ],
                    ),
                  ),
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: const <Widget>[
                      MedicationsTab(),
                      CategoriesTab(),
                    ],
                  ),
                ),
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
        bottomNavigationBar: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, -1))
          ]),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: _buildNavBarIcon(
                        context, 0, Icons.medication_liquid_outlined),
                    label: 'Medications'),
                BottomNavigationBarItem(
                    icon: _buildNavBarIcon(context, 1, Icons.category_outlined),
                    label: 'Categories'),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: colorScheme.primary,
              unselectedItemColor:
                  colorScheme.onSurfaceVariant.withOpacity(0.7),
              selectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: colorScheme.primary),
              unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant.withOpacity(0.7)),
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              backgroundColor: colorScheme.surface,
              onTap: _onItemTapped,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _openAddModal,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          tooltip: _selectedIndex == 0 ? 'Add Medication' : 'Add Category',
          child: const Icon(Icons.add_rounded),
        ),
      ),
    );
  }

  Widget _buildNavBarIcon(BuildContext context, int index, IconData iconData) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isSelected = _selectedIndex == index;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isSelected
            ? colorScheme.primary.withOpacity(0.12)
            : Colors.transparent,
      ),
      child: Icon(
        iconData,
        color: isSelected
            ? colorScheme.primary
            : colorScheme.onSurfaceVariant.withOpacity(0.7),
        size: 24,
      ),
    );
  }
}

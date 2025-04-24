import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditrack/presentation/widgets/shared/app_drawer.dart';
import 'package:meditrack/presentation/widgets/shared/curved_sliver_app_bar_delegate.dart';
import 'package:meditrack/providers/theme_provider.dart';
import 'package:meditrack/providers/user_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  static const double _maxHeaderHeight = 180.0;
  static const double _minHeaderExtraPadding = 10.0;
  static const double _extraScrollPixels = 200.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double minHeaderHeight =
        kToolbarHeight + statusBarHeight + _minHeaderExtraPadding;
    final double screenHeight = MediaQuery.of(context).size.height;

    final currentThemeMode = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    final currentUser = ref.watch(currentUserProvider);

    final headerGradient = LinearGradient(
      colors: [
        colorScheme.primary,
        colorScheme.primary.withOpacity(0.9),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final headerForegroundColor = colorScheme.onPrimary;

    return Scaffold(
      drawer: currentUser != null ? AppDrawer(currentUser: currentUser) : null,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: [
          SliverPersistentHeader(
            delegate: CurvedSliverAppBarDelegate(
              maxHeaderHeight: _maxHeaderHeight,
              minHeaderHeight: minHeaderHeight,
              gradient: headerGradient,
              foregroundColor: headerForegroundColor,
              titleText: 'Settings',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: const [],
            ),
            pinned: true,
          ),
          SliverPadding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),
                Card(
                  elevation: 1,
                  shadowColor: colorScheme.shadow.withOpacity(0.05),
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: colorScheme.outline.withOpacity(0.05),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.palette_outlined,
                                  color: colorScheme.primary),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Appearance',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeIn,
                          child: SegmentedButton<ThemeMode>(
                            key: ValueKey(currentThemeMode),
                            style: SegmentedButton.styleFrom(
                              backgroundColor:
                                  colorScheme.surfaceVariant.withOpacity(0.6),
                              selectedBackgroundColor:
                                  colorScheme.primary.withOpacity(0.15),
                              selectedForegroundColor: colorScheme.primary,
                              visualDensity:
                                  VisualDensity.adaptivePlatformDensity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: BorderSide(
                                color:
                                    colorScheme.outlineVariant.withOpacity(0.1),
                              ),
                            ),
                            segments: const <ButtonSegment<ThemeMode>>[
                              ButtonSegment<ThemeMode>(
                                value: ThemeMode.light,
                                label: Text('Light'),
                                icon: Icon(Icons.light_mode_outlined),
                              ),
                              ButtonSegment<ThemeMode>(
                                value: ThemeMode.dark,
                                label: Text('Dark'),
                                icon: Icon(Icons.dark_mode_outlined),
                              ),
                              ButtonSegment<ThemeMode>(
                                value: ThemeMode.system,
                                label: Text('System'),
                                icon: Icon(Icons.brightness_auto_outlined),
                              ),
                            ],
                            selected: <ThemeMode>{currentThemeMode},
                            onSelectionChanged: (Set<ThemeMode> newSelection) {
                              if (newSelection.isNotEmpty) {
                                themeNotifier.setThemeMode(newSelection.first);
                              }
                            },
                            multiSelectionEnabled: false,
                            showSelectedIcon: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: colorScheme.outline.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'MediTrack',
                        applicationVersion: '1.0.0',
                        applicationLegalese: '© 2024 Your Company Name',
                        applicationIcon: Icon(
                          Icons.medical_services_outlined,
                          size: 36,
                          color: colorScheme.primary,
                        ),
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            "Manage your pharmacy inventory effectively.",
                            style: theme.textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.help_outline_outlined,
                              color: colorScheme.primary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'About & Help',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'App version, contact support',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color:
                                        colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded,
                              color: colorScheme.onSurface.withOpacity(0.5)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ]),
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditrack/models/user.dart';
import 'package:meditrack/providers/auth_provider.dart';

class AppDrawer extends ConsumerWidget {
  final User currentUser;

  const AppDrawer({
    required this.currentUser,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final initials =
        _getUserInitials('${currentUser.first_name} ${currentUser.last_name}');

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: colorScheme.primary,
            ),
            accountName: Text(
              '${currentUser.first_name} ${currentUser.last_name}',
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              currentUser.email,
              style: TextStyle(color: colorScheme.onPrimary.withOpacity(0.8)),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: colorScheme.secondary,
              child: Text(
                initials,
                style: TextStyle(
                  color: colorScheme.onSecondary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _createDrawerItem(
                  context: context,
                  icon: Icons.home_outlined,
                  title: 'Home',
                  onTap: () => _navigateTo(context, '/'),
                ),
                if (currentUser.role == 'admin') ..._buildAdminItems(context),
                if (currentUser.role == 'pharmacy_staff')
                  ..._buildPharmacyStaffItems(context),
                const Divider(height: 20, thickness: 1),
                _buildSettingsSectionHeader(),
                _createDrawerItem(
                  context: context,
                  icon: Icons.person_outline,
                  title: 'Profile',
                  onTap: () => _navigateTo(context, '/profile'),
                ),
                _createDrawerItem(
                  context: context,
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () => _navigateTo(context, '/settings'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: ListTile(
              leading: Icon(Icons.logout, color: colorScheme.error),
              title: Text(
                'Logout',
                style: TextStyle(color: colorScheme.error, fontSize: 16),
              ),
              onTap: () => _logout(context, ref),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAdminItems(BuildContext context) {
    return [
      _buildRoleSectionHeader('ADMINISTRATION'),
      _createDrawerItem(
        context: context,
        icon: Icons.dashboard_outlined,
        title: 'Dashboard Overview',
        onTap: () => _navigateTo(context, '/admin/overview'),
      ),
      _createDrawerItem(
        context: context,
        icon: Icons.local_pharmacy_outlined,
        title: 'Pharmacy Management',
        onTap: () => _navigateTo(context, '/admin/pharmacies'),
      ),
      // _createDrawerItem(
      //   context: context,
      //   icon: Icons.message_outlined,
      //   title: 'Contact Messages',
      //   onTap: () => _navigateTo(context, '/admin/messages'),
      // ),
    ];
  }

  List<Widget> _buildPharmacyStaffItems(BuildContext context) {
    return [
      _buildRoleSectionHeader('PHARMACY MANAGEMENT'),
      _createDrawerItem(
        context: context,
        icon: Icons.analytics_outlined,
        title: 'Pharmacy Overview',
        onTap: () => _navigateTo(context, '/pharmacy/overview'),
      ),
      _createDrawerItem(
        context: context,
        icon: Icons.medication_outlined,
        title: 'Medication Management',
        onTap: () => _navigateTo(context, '/pharmacy/medications'),
      ),
      _createDrawerItem(
        context: context,
        icon: Icons.inventory_outlined,
        title: 'Inventory Management',
        onTap: () => _navigateTo(context, '/pharmacy/inventory'),
      ),
    ];
  }

  Widget _buildRoleSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: Colors.grey.shade600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsSectionHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 8, 16, 8),
      child: Text(
        'SETTINGS',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: Colors.grey.shade600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  ListTile _createDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
      dense: true,
    );
  }

  void _navigateTo(BuildContext context, String route) {
    final scaffoldState = Scaffold.maybeOf(context);
    if (scaffoldState != null && scaffoldState.isDrawerOpen) {
      Navigator.of(context).pop();
    }

    if (context.mounted) {
      context.push(route);
    }
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    if (context.mounted) {
      final scaffoldState = Scaffold.maybeOf(context);
      if (scaffoldState != null && scaffoldState.isDrawerOpen) {
        Navigator.pop(context);
      }
    }

    try {
      ref.read(authNotifierProvider.notifier).logout();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go('/login');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  String _getUserInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';

    final nonEmptyParts = parts.where((part) => part.isNotEmpty).toList();
    if (nonEmptyParts.length >= 2) {
      return '${nonEmptyParts[0][0]}${nonEmptyParts.last[0]}'.toUpperCase();
    } else if (nonEmptyParts.isNotEmpty) {
      return nonEmptyParts[0][0].toUpperCase();
    }
    return '?';
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditrack/models/user.dart';
import 'package:meditrack/presentation/widgets/shared/app_drawer.dart';
import 'package:meditrack/providers/user_provider.dart';
import 'package:meditrack/presentation/widgets/profile_avatar.dart';
import 'package:meditrack/presentation/widgets/info_tile.dart';
import 'package:meditrack/presentation/widgets/shared/theme_toggle_button.dart';
import 'package:intl/intl.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  String _formatLastLogin(String? lastLoginDate) {
    if (lastLoginDate == null) return 'Never';
    try {
      final dateTime = DateTime.parse(lastLoginDate).toLocal();
      return DateFormat('MMM d, yyyy hh:mm a').format(dateTime);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentUserAsyncValue = ref.watch(currentUserNotifierProvider);

    return currentUserAsyncValue.when(
      data: (currentUser) {
        if (currentUser == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Profile')),
            body: const Center(child: Text('Please log in to view profile.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: theme.brightness == Brightness.light
                ? Colors.black
                : Colors.white,
            actions: const [
              ThemeToggleButton(),
            ],
          ),
          drawer: AppDrawer(currentUser: currentUser),
          body: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProfileHeader(context, currentUser),
                const SizedBox(height: 24),
                _buildInfoCard(context, currentUser),
                const SizedBox(height: 24),
                _buildActionButtons(context),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(child: Text('Error loading profile: $error')),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, User user) {
    final theme = Theme.of(context);
    final fullName = "${user.first_name} ${user.last_name}";

    return Column(
      children: [
        ProfileAvatar(name: fullName, radius: 50),
        const SizedBox(height: 16),
        Text(
          fullName,
          style: theme.textTheme.headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, User user) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            InfoTile(
              icon: Icons.phone_outlined,
              title: 'Phone',
              value: user.phone ?? 'Not Set',
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            InfoTile(
              icon: Icons.badge_outlined,
              title: 'Role',
              value: user.role,
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            InfoTile(
              icon: Icons.history_outlined,
              title: 'Last Login',
              value: _formatLastLogin(user.last_login),
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            InfoTile(
              icon: Icons.numbers_outlined,
              title: 'User ID',
              value: user.user_id.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.edit_outlined),
          label: const Text('Edit Profile'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            context.push('/profile/edit');
          },
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          icon: const Icon(Icons.lock_outline),
          label: const Text('Change Password'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: BorderSide(color: theme.colorScheme.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            context.push('/profile/change-password');
          },
        ),
      ],
    );
  }
}

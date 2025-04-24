// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import 'package:meditrack/providers/pharmacy_provider.dart';
import 'package:meditrack/models/pharmacy.dart';
import 'package:meditrack/core/constants.dart';

import 'package:meditrack/presentation/widgets/shared/curved_sliver_app_bar_delegate.dart';

class PharmacyPage extends ConsumerWidget {
  final int pharmacyId;

  const PharmacyPage({required this.pharmacyId, super.key});

  static const double _maxHeaderHeight = 160.0;
  static const double _minHeaderExtraPadding = 10.0;

  Widget _buildInfoTile(
      BuildContext context, IconData icon, String title, String subtitle) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 20),
        ),
        title: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withOpacity(0.8))),
        subtitle: Text(subtitle,
            style:
                TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6))),
        contentPadding: EdgeInsets.zero,
        visualDensity: const VisualDensity(vertical: -2),
      ),
    );
  }

  Future<void> _launchUrl(Uri url, BuildContext context) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch $url'),
          ),
        );
      }
    }
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, Pharmacy pharmacy) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Pharmacy?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
            'Are you sure you want to delete ${pharmacy.name}? This action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref
            .read(pharmacyListProvider.notifier)
            .deletePharmacy(pharmacy.pharmacyId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${pharmacy.name} deleted successfully.'),
              backgroundColor: Colors.green,
            ),
          );

          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/admin/pharmacies');
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting pharmacy: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pharmacyAsyncValue = ref.watch(pharmacyDetailsProvider(pharmacyId));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    final double minHeaderHeight =
        kToolbarHeight + statusBarHeight + _minHeaderExtraPadding;

    final headerGradient = LinearGradient(
      colors: [colorScheme.primary.withOpacity(0.9), colorScheme.primary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final headerForegroundColor = colorScheme.onPrimary;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary.withOpacity(0.05),
              colorScheme.primary.withOpacity(0.01),
            ],
          ),
        ),
        child: RefreshIndicator(
          edgeOffset: _maxHeaderHeight - 40,
          color: colorScheme.primary,
          onRefresh: () async {
            ref.invalidate(pharmacyDetailsProvider(pharmacyId));

            await ref.read(pharmacyDetailsProvider(pharmacyId).future);
          },
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
                  title: pharmacyAsyncValue.maybeWhen(
                    data: (pharmacy) => Text(pharmacy.name,
                        overflow: TextOverflow.ellipsis, maxLines: 1),
                    orElse: () => const Text('Pharmacy Details'),
                  ),
                  leading: const BackButton(),
                  actions: [
                    pharmacyAsyncValue.maybeWhen(
                      data: (pharmacy) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              tooltip: 'Edit Pharmacy',
                              onPressed: () => context.go(
                                  '/admin/pharmacies/${pharmacy.pharmacyId}/edit',
                                  extra: pharmacy)),
                          IconButton(
                              icon: const Icon(Icons.delete_outline),
                              tooltip: 'Delete Pharmacy',
                              onPressed: () =>
                                  _confirmDelete(context, ref, pharmacy)),
                        ],
                      ),
                      orElse: () => const SizedBox.shrink(),
                    ),
                  ],
                ),
                pinned: true,
              ),
              pharmacyAsyncValue.when(
                data: (pharmacy) =>
                    _buildPharmacyDetailsSlivers(context, pharmacy),
                loading: () => const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator())),
                error: (error, stackTrace) => SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildErrorWidget(context, ref, error),
                ),
              ),
              SliverFillRemaining(
                  hasScrollBody: false,
                  fillOverscroll: false,
                  child: Container()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPharmacyDetailsSlivers(BuildContext context, Pharmacy pharmacy) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final imageUrls =
        pharmacy.images.map((img) => '$mediaBaseUrl/${img.imageUrl}').toList();

    return SliverList(
        delegate: SliverChildListDelegate([
      const SizedBox(height: 16),
      if (imageUrls.isNotEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CarouselSlider(
              options: CarouselOptions(
                height: 220.0,
                autoPlay: imageUrls.length > 1,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                viewportFraction: 1.0,
                enableInfiniteScroll: imageUrls.length > 1,
              ),
              items: imageUrls.map((url) {
                return Builder(
                  builder: (BuildContext context) {
                    return CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) => Container(
                        color: colorScheme.surfaceVariant,
                        child: Center(
                          child: CircularProgressIndicator(
                              color: colorScheme.primary),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: colorScheme.surfaceVariant,
                        child: Center(
                          child: Icon(Icons.broken_image_outlined,
                              color: colorScheme.onSurfaceVariant, size: 40),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        )
      else
        Container(
          height: 180,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Icon(Icons.storefront_outlined,
                size: 60, color: colorScheme.onSurfaceVariant),
          ),
        ),
      const SizedBox(height: 24),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Card(
          elevation: 1,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(Icons.local_pharmacy_outlined,
                      size: 24, color: colorScheme.primary),
                  const SizedBox(width: 12),
                  Text('Pharmacy Information',
                      style: textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold))
                ]),
                const SizedBox(height: 16),
                _buildInfoTile(context, Icons.location_on_outlined, 'Address',
                    pharmacy.address),
                _buildInfoTile(context, Icons.phone_outlined, 'Phone',
                    pharmacy.phoneNumber),
                if (pharmacy.email != null && pharmacy.email!.isNotEmpty)
                  _buildInfoTile(
                      context, Icons.email_outlined, 'Email', pharmacy.email!),
                if (pharmacy.latitudeDouble != null &&
                    pharmacy.longitudeDouble != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.map_outlined),
                      label: const Text('View on Map'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary.withOpacity(0.1),
                        foregroundColor: colorScheme.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                      onPressed: () {
                        final lat = pharmacy.latitudeDouble!;
                        final lon = pharmacy.longitudeDouble!;
                        final mapUrl = Uri.parse(
                            'https://www.google.com/maps/search/?api=1&query=$lat,$lon');
                        _launchUrl(mapUrl, context);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Card(
          elevation: 1,
          margin: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(Icons.person_pin_circle_outlined,
                      size: 24, color: colorScheme.primary),
                  const SizedBox(width: 12),
                  Text('Manager Information',
                      style: textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold))
                ]),
                const SizedBox(height: 16),
                _buildInfoTile(context, Icons.person_outline, 'Name',
                    '${pharmacy.managerFirstName} ${pharmacy.managerLastName}'),
                _buildInfoTile(context, Icons.phone_android_outlined,
                    'Manager Phone', pharmacy.managerPhone),
                _buildInfoTile(context, Icons.alternate_email, 'Manager Email',
                    pharmacy.managerEmail),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'Created: ${DateFormat.yMd().add_jm().format(pharmacy.createdAt.toLocal())} • Updated: ${DateFormat.yMd().add_jm().format(pharmacy.updatedAt.toLocal())}',
          style: textTheme.bodySmall
              ?.copyWith(color: colorScheme.onSurface.withOpacity(0.5)),
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(height: 32),
    ]));
  }

  Widget _buildErrorWidget(BuildContext context, WidgetRef ref, Object error) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.error_outline_rounded,
                size: 40, color: colorScheme.onErrorContainer),
          ),
          const SizedBox(height: 24),
          Text('Error loading pharmacy details',
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: colorScheme.error)),
          const SizedBox(height: 8),
          Text(error.toString(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.onSurface.withOpacity(0.6))),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
            onPressed: () =>
                ref.invalidate(pharmacyDetailsProvider(pharmacyId)),
            style: ElevatedButton.styleFrom(
                foregroundColor: colorScheme.onPrimary,
                backgroundColor: colorScheme.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
          )
        ],
      ),
    );
  }
}

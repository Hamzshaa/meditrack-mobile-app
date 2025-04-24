import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditrack/models/medication.dart';
import 'package:meditrack/presentation/widgets/home/detail_row.dart';
import 'package:meditrack/presentation/widgets/medication_list_item.dart';
import 'package:url_launcher/url_launcher.dart';

class MedicationDetailsContent extends StatelessWidget {
  final Medication medication;

  const MedicationDetailsContent({super.key, required this.medication});

  Future<void> _launchUrlHelper(
      BuildContext context, Uri url, String errorMsg) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final distanceFormatted =
        MedicationListItem.formatDistance(medication.distance);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
          left: 24.0, right: 24.0, top: 20.0, bottom: 30.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 15.0),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          Text(
            medication.medicationBrandName,
            style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold, color: colorScheme.primary),
          ),
          if (medication.medicationGenericName.isNotEmpty &&
              medication.medicationGenericName.toLowerCase() !=
                  medication.medicationBrandName.toLowerCase())
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 8.0),
              child: Text(
                medication.medicationGenericName,
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          Divider(
              height: 20,
              thickness: 0.5,
              color: colorScheme.outline.withOpacity(0.3)),
          DetailRow(
              icon: Icons.local_pharmacy_outlined,
              label: 'Pharmacy:',
              value: medication.pharmacyName ?? 'N/A'),
          DetailRow(
              icon: Icons.location_on_outlined,
              label: 'Address:',
              value: medication.pharmacyAddress ?? 'N/A'),
          if (medication.distance != null)
            DetailRow(
                icon: Icons.social_distance_outlined,
                label: 'Distance:',
                value: distanceFormatted),
          DetailRow(
              icon: Icons.science_outlined,
              label: 'Strength:',
              value:
                  medication.strength.isNotEmpty ? medication.strength : 'N/A'),
          DetailRow(
              icon: Icons.grain_outlined,
              label: 'Form:',
              value: medication.dosageForm.isNotEmpty
                  ? medication.dosageForm
                  : 'N/A'),
          if (medication.manufacturer.isNotEmpty)
            DetailRow(
                icon: Icons.factory_outlined,
                label: 'Maker:',
                value: medication.manufacturer),
          if (medication.expirationDate != null)
            DetailRow(
                icon: Icons.calendar_today_outlined,
                label: 'Expires:',
                value: DateFormat.yMMMd().format(medication.expirationDate!)),
          if (medication.description != null &&
              medication.description!.isNotEmpty) ...[
            const SizedBox(height: 4),
            DetailRow(
                icon: Icons.info_outline,
                label: 'Notes:',
                value: medication.description!),
          ],
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (medication.googleMapsUrl != null &&
                  medication.googleMapsUrl!.isNotEmpty)
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.directions_car_filled_outlined),
                    label: const Text('Directions'),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: colorScheme.onPrimary,
                        backgroundColor: colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        textStyle: theme.textTheme.labelLarge),
                    onPressed: () {
                      final url = Uri.parse(medication.googleMapsUrl!);
                      _launchUrlHelper(
                          context, url, 'Could not open map application.');
                    },
                  ),
                )
              else if (medication.pharmacyAddress != null &&
                  medication.pharmacyAddress!.isNotEmpty)
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.map_outlined),
                    label: const Text('Show Map'),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: colorScheme.onSecondaryContainer,
                        backgroundColor: colorScheme.secondaryContainer,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        textStyle: theme.textTheme.labelLarge),
                    onPressed: () {
                      final query =
                          Uri.encodeComponent(medication.pharmacyAddress!);
                      final mapUrl = Uri.parse(
                          'https://www.google.com/maps/search/?api=1&query=$query');
                      _launchUrlHelper(
                          context, mapUrl, 'Could not open map application.');
                    },
                  ),
                ),
              if ((medication.googleMapsUrl != null &&
                      medication.googleMapsUrl!.isNotEmpty) ||
                  (medication.pharmacyAddress != null &&
                      medication.pharmacyAddress!.isNotEmpty))
                if (medication.pharmacyPhone != null &&
                    medication.pharmacyPhone!.isNotEmpty)
                  const SizedBox(width: 10),
              if (medication.pharmacyPhone != null &&
                  medication.pharmacyPhone!.isNotEmpty)
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.phone_outlined),
                    label: const Text('Call'),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: colorScheme.onSecondaryContainer,
                        backgroundColor: colorScheme.secondaryContainer,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        textStyle: theme.textTheme.labelLarge),
                    onPressed: () {
                      final phoneUrl =
                          Uri(scheme: 'tel', path: medication.pharmacyPhone!);
                      _launchUrlHelper(
                          context, phoneUrl, 'Could not initiate call.');
                    },
                  ),
                )
            ],
          )
        ],
      ),
    );
  }
}

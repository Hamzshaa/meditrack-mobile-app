import 'package:flutter/material.dart';
import 'package:meditrack/models/medication.dart';
import 'package:meditrack/presentation/widgets/medication_list_item.dart';

class MedicationListSliver extends StatelessWidget {
  final List<Medication> medications;
  final Function(Medication) onItemTap;

  const MedicationListSliver({
    super.key,
    required this.medications,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding:
          const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 4.0, right: 4.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final medication = medications[index];
            return MedicationListItem(
              key: ValueKey(medication.medicationId),
              medication: medication,
              onTap: () => onItemTap(medication),
            );
          },
          childCount: medications.length,
        ),
      ),
    );
  }
}

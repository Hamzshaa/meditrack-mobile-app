// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expiring_medication_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpiredMedications _$ExpiredMedicationsFromJson(Map<String, dynamic> json) =>
    ExpiredMedications(
      medicationId: (json['medication_id'] as num).toInt(),
      medicationBrandName: json['medication_brand_name'] as String,
      batchNumber: json['batch_number'] as String,
      expirationDate:
          dateTimeFromStringNullable(json['expiration_date'] as String?),
      daysAgo: (json['days_ago'] as num).toInt(),
    );

Map<String, dynamic> _$ExpiredMedicationsToJson(ExpiredMedications instance) =>
    <String, dynamic>{
      'medication_id': instance.medicationId,
      'medication_brand_name': instance.medicationBrandName,
      'batch_number': instance.batchNumber,
      'expiration_date': dateTimeToStringNullable(instance.expirationDate),
      'days_ago': instance.daysAgo,
    };

ExpiringSoon _$ExpiringSoonFromJson(Map<String, dynamic> json) => ExpiringSoon(
      medicationId: (json['medication_id'] as num).toInt(),
      medicationBrandName: json['medication_brand_name'] as String,
      batchNumber: json['batch_number'] as String,
      expirationDate:
          dateTimeFromStringNullable(json['expiration_date'] as String?),
      daysLeft: (json['days_left'] as num).toInt(),
    );

Map<String, dynamic> _$ExpiringSoonToJson(ExpiringSoon instance) =>
    <String, dynamic>{
      'medication_id': instance.medicationId,
      'medication_brand_name': instance.medicationBrandName,
      'batch_number': instance.batchNumber,
      'expiration_date': dateTimeToStringNullable(instance.expirationDate),
      'days_left': instance.daysLeft,
    };

ExpiringMedications _$ExpiringMedicationsFromJson(Map<String, dynamic> json) =>
    ExpiringMedications(
      expiredMedications: (json['expiredMedications'] as List<dynamic>?)
              ?.map(
                  (e) => ExpiredMedications.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      expiringSoon: (json['expiringSoon'] as List<dynamic>?)
              ?.map((e) => ExpiringSoon.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ExpiringMedicationsToJson(
        ExpiringMedications instance) =>
    <String, dynamic>{
      'expiredMedications':
          instance.expiredMedications.map((e) => e.toJson()).toList(),
      'expiringSoon': instance.expiringSoon.map((e) => e.toJson()).toList(),
    };

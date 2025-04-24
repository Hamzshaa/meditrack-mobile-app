// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pharmacy_overview_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PharmacyData _$PharmacyDataFromJson(Map<String, dynamic> json) => PharmacyData(
      name: json['name'] as String,
      address: json['address'] as String,
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$PharmacyDataToJson(PharmacyData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'phone_number': instance.phoneNumber,
      'email': instance.email,
    };

Stats _$StatsFromJson(Map<String, dynamic> json) => Stats(
      totalMedications: (json['totalMedications'] as num).toInt(),
      totalBatches: (json['totalBatches'] as num).toInt(),
      totalQuantity: json['totalQuantity'] as String,
      expiredBatches: (json['expiredBatches'] as num).toInt(),
      reorderNeeded: (json['reorderNeeded'] as num).toInt(),
      outOfStock: (json['outOfStock'] as num).toInt(),
      nearExpiry: (json['nearExpiry'] as num).toInt(),
    );

Map<String, dynamic> _$StatsToJson(Stats instance) => <String, dynamic>{
      'totalMedications': instance.totalMedications,
      'totalBatches': instance.totalBatches,
      'totalQuantity': instance.totalQuantity,
      'expiredBatches': instance.expiredBatches,
      'reorderNeeded': instance.reorderNeeded,
      'outOfStock': instance.outOfStock,
      'nearExpiry': instance.nearExpiry,
    };

RecentMedications _$RecentMedicationsFromJson(Map<String, dynamic> json) =>
    RecentMedications(
      medicationId: (json['medication_id'] as num).toInt(),
      medicationBrandName: json['medication_brand_name'] as String,
      strength: json['strength'] as String,
      manufacturer: json['manufacturer'] as String,
      createdAt: dateTimeFromStringNullable(json['created_at'] as String?),
    );

Map<String, dynamic> _$RecentMedicationsToJson(RecentMedications instance) =>
    <String, dynamic>{
      'medication_id': instance.medicationId,
      'medication_brand_name': instance.medicationBrandName,
      'strength': instance.strength,
      'manufacturer': instance.manufacturer,
      'created_at': dateTimeToStringNullable(instance.createdAt),
    };

ExpiringSoon _$ExpiringSoonFromJson(Map<String, dynamic> json) => ExpiringSoon(
      inventoryId: (json['inventory_id'] as num).toInt(),
      batchNumber: json['batch_number'] as String,
      expirationDate:
          dateTimeFromStringNullable(json['expiration_date'] as String?),
      quantity: (json['quantity'] as num).toInt(),
      medicationBrandName: json['medication_brand_name'] as String,
      strength: json['strength'] as String,
    );

Map<String, dynamic> _$ExpiringSoonToJson(ExpiringSoon instance) =>
    <String, dynamic>{
      'inventory_id': instance.inventoryId,
      'batch_number': instance.batchNumber,
      'expiration_date': dateTimeToStringNullable(instance.expirationDate),
      'quantity': instance.quantity,
      'medication_brand_name': instance.medicationBrandName,
      'strength': instance.strength,
    };

PharmacyOverviewData _$PharmacyOverviewDataFromJson(
        Map<String, dynamic> json) =>
    PharmacyOverviewData(
      pharmacy: PharmacyData.fromJson(json['pharmacy'] as Map<String, dynamic>),
      stats: Stats.fromJson(json['stats'] as Map<String, dynamic>),
      recentMedications: (json['recentMedications'] as List<dynamic>?)
              ?.map(
                  (e) => RecentMedications.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      expiringSoon: (json['expiringSoon'] as List<dynamic>?)
              ?.map((e) => ExpiringSoon.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$PharmacyOverviewDataToJson(
        PharmacyOverviewData instance) =>
    <String, dynamic>{
      'pharmacy': instance.pharmacy.toJson(),
      'stats': instance.stats.toJson(),
      'recentMedications':
          instance.recentMedications.map((e) => e.toJson()).toList(),
      'expiringSoon': instance.expiringSoon.map((e) => e.toJson()).toList(),
    };

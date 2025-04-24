// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Medication _$MedicationFromJson(Map<String, dynamic> json) => Medication(
      medicationId: (json['medication_id'] as num).toInt(),
      medicationBrandName: json['medication_brand_name'] as String,
      medicationGenericName: json['medication_generic_name'] as String,
      dosageForm: json['dosage_form'] as String,
      strength: json['strength'] as String,
      manufacturer: json['manufacturer'] as String,
      description: json['description'] as String?,
      pharmacyId: (json['pharmacy_id'] as num?)?.toInt(),
      pharmacyName: json['pharmacy_name'] as String?,
      pharmacyAddress: json['pharmacy_address'] as String?,
      pharmacyPhone: json['pharmacy_phone'] as String?,
      pharmacyEmail: json['pharmacy_email'] as String?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      expirationDate:
          Medication._dateTimeFromJson(json['expiration_date'] as String?),
      distance: (json['distance'] as num?)?.toDouble(),
      googleMapsUrl: json['googleMapsUrl'] as String?,
      categoryId: (json['category_id'] as num?)?.toInt(),
      categoryName: json['category_name'] as String?,
      createdAt: Medication._dateTimeFromJson(json['created_at'] as String?),
      updatedAt: Medication._dateTimeFromJson(json['updated_at'] as String?),
      reorderPoint: (json['reorder_point'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MedicationToJson(Medication instance) =>
    <String, dynamic>{
      'medication_id': instance.medicationId,
      'medication_brand_name': instance.medicationBrandName,
      'medication_generic_name': instance.medicationGenericName,
      'dosage_form': instance.dosageForm,
      'strength': instance.strength,
      'manufacturer': instance.manufacturer,
      'description': instance.description,
      'pharmacy_id': instance.pharmacyId,
      'pharmacy_name': instance.pharmacyName,
      'pharmacy_address': instance.pharmacyAddress,
      'pharmacy_phone': instance.pharmacyPhone,
      'pharmacy_email': instance.pharmacyEmail,
      'images': instance.images,
      'expiration_date': Medication._dateTimeToJson(instance.expirationDate),
      'distance': instance.distance,
      'googleMapsUrl': instance.googleMapsUrl,
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'created_at': Medication._dateTimeToJson(instance.createdAt),
      'updated_at': Medication._dateTimeToJson(instance.updatedAt),
      'reorder_point': instance.reorderPoint,
    };

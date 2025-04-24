// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicationCategory _$MedicationCategoryFromJson(Map<String, dynamic> json) =>
    MedicationCategory(
      categoryId: (json['category_id'] as num).toInt(),
      categoryName: json['category_name'] as String,
      pharmacyId: (json['pharmacy_id'] as num).toInt(),
    );

Map<String, dynamic> _$MedicationCategoryToJson(MedicationCategory instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'pharmacy_id': instance.pharmacyId,
    };

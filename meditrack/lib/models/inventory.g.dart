// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryTable _$InventoryTableFromJson(Map<String, dynamic> json) =>
    InventoryTable(
      inventoryId: (json['inventory_id'] as num).toInt(),
      batchNumber: json['batch_number'] as String,
      expirationDate:
          dateTimeFromStringNullable(json['expiration_date'] as String?),
      quantity: (json['quantity'] as num).toInt(),
      lastUpdated: dateTimeFromStringNullable(json['last_updated'] as String?),
    );

Map<String, dynamic> _$InventoryTableToJson(InventoryTable instance) =>
    <String, dynamic>{
      'inventory_id': instance.inventoryId,
      'batch_number': instance.batchNumber,
      'expiration_date': dateTimeToStringNullable(instance.expirationDate),
      'quantity': instance.quantity,
      'last_updated': dateTimeToStringNullable(instance.lastUpdated),
    };

Inventory _$InventoryFromJson(Map<String, dynamic> json) => Inventory(
      medicationId: (json['medication_id'] as num).toInt(),
      medicationBrandName: json['medication_brand_name'] as String,
      medicationGenericName: json['medication_generic_name'] as String,
      dosageForm: json['dosage_form'] as String,
      strength: json['strength'] as String,
      manufacturer: json['manufacturer'] as String,
      description: json['description'] as String?,
      categoryId: (json['category_id'] as num).toInt(),
      createdAt: dateTimeFromStringNullable(json['created_at'] as String?),
      updatedAt: dateTimeFromStringNullable(json['updated_at'] as String?),
      pharmacyId: (json['pharmacy_id'] as num).toInt(),
      inventory: (json['inventory'] as List<dynamic>?)
              ?.map((e) => InventoryTable.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalQuantity: (json['total_quantity'] as num).toInt(),
      reorderPoint: (json['reorder_point'] as num).toInt(),
    );

Map<String, dynamic> _$InventoryToJson(Inventory instance) => <String, dynamic>{
      'medication_id': instance.medicationId,
      'medication_brand_name': instance.medicationBrandName,
      'medication_generic_name': instance.medicationGenericName,
      'dosage_form': instance.dosageForm,
      'strength': instance.strength,
      'manufacturer': instance.manufacturer,
      'description': instance.description,
      'category_id': instance.categoryId,
      'created_at': dateTimeToStringNullable(instance.createdAt),
      'updated_at': dateTimeToStringNullable(instance.updatedAt),
      'pharmacy_id': instance.pharmacyId,
      'inventory': instance.inventory.map((e) => e.toJson()).toList(),
      'total_quantity': instance.totalQuantity,
      'reorder_point': instance.reorderPoint,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Batch _$BatchFromJson(Map<String, dynamic> json) => Batch(
      inventoryId: (json['inventory_id'] as num).toInt(),
      batchNumber: json['batch_number'] as String,
      expirationDate:
          dateTimeFromStringNullable(json['expiration_date'] as String?),
    );

Map<String, dynamic> _$BatchToJson(Batch instance) => <String, dynamic>{
      'inventory_id': instance.inventoryId,
      'batch_number': instance.batchNumber,
      'expiration_date': dateTimeToStringNullable(instance.expirationDate),
    };

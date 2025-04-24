// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pharmacy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PharmacyImage _$PharmacyImageFromJson(Map<String, dynamic> json) =>
    PharmacyImage(
      imageId: (json['image_id'] as num).toInt(),
      imageUrl: json['image_url'] as String,
    );

Map<String, dynamic> _$PharmacyImageToJson(PharmacyImage instance) =>
    <String, dynamic>{
      'image_id': instance.imageId,
      'image_url': instance.imageUrl,
    };

Pharmacy _$PharmacyFromJson(Map<String, dynamic> json) => Pharmacy(
      pharmacyId: (json['pharmacy_id'] as num).toInt(),
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String?,
      managerId: (json['manager_id'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      managerFirstName: json['manager_first_name'] as String,
      managerLastName: json['manager_last_name'] as String,
      managerEmail: json['manager_email'] as String,
      managerPhone: json['manager_phone'] as String,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => PharmacyImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$PharmacyToJson(Pharmacy instance) => <String, dynamic>{
      'pharmacy_id': instance.pharmacyId,
      'name': instance.name,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'phone_number': instance.phoneNumber,
      'email': instance.email,
      'manager_id': instance.managerId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'manager_first_name': instance.managerFirstName,
      'manager_last_name': instance.managerLastName,
      'manager_email': instance.managerEmail,
      'manager_phone': instance.managerPhone,
      'images': instance.images,
    };

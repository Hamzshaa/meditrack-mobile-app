import 'package:json_annotation/json_annotation.dart';

part 'medication.g.dart';

@JsonSerializable()
class Medication {
  @JsonKey(name: 'medication_id')
  final int medicationId;

  @JsonKey(name: 'medication_brand_name')
  final String medicationBrandName;

  @JsonKey(name: 'medication_generic_name')
  final String medicationGenericName;

  @JsonKey(name: 'dosage_form')
  final String dosageForm;

  final String strength;
  final String manufacturer;

  final String? description;

  @JsonKey(name: 'pharmacy_id')
  final int? pharmacyId;

  @JsonKey(name: 'pharmacy_name')
  final String? pharmacyName;

  @JsonKey(name: 'pharmacy_address')
  final String? pharmacyAddress;

  @JsonKey(name: 'pharmacy_phone')
  final String? pharmacyPhone;

  @JsonKey(name: 'pharmacy_email')
  final String? pharmacyEmail;

  final List<String>? images;

  @JsonKey(
      name: 'expiration_date',
      fromJson: _dateTimeFromJson,
      toJson: _dateTimeToJson)
  final DateTime? expirationDate;

  final double? distance;

  final String? googleMapsUrl;

  @JsonKey(name: 'category_id')
  final int? categoryId;

  @JsonKey(name: 'category_name')
  final String? categoryName;

  @JsonKey(
      name: 'created_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? createdAt;

  @JsonKey(
      name: 'updated_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? updatedAt;

  @JsonKey(name: 'reorder_point')
  final int? reorderPoint;

  Medication({
    required this.medicationId,
    required this.medicationBrandName,
    required this.medicationGenericName,
    required this.dosageForm,
    required this.strength,
    required this.manufacturer,
    this.description,
    this.pharmacyId,
    this.pharmacyName,
    this.pharmacyAddress,
    this.pharmacyPhone,
    this.pharmacyEmail,
    this.images,
    this.expirationDate,
    this.distance,
    this.googleMapsUrl,
    this.categoryId,
    this.categoryName,
    this.createdAt,
    this.updatedAt,
    this.reorderPoint,
  });

  static DateTime? _dateTimeFromJson(String? json) =>
      json == null ? null : DateTime.tryParse(json);
  static String? _dateTimeToJson(DateTime? dateTime) =>
      dateTime?.toIso8601String();

  factory Medication.fromJson(Map<String, dynamic> json) =>
      _$MedicationFromJson(json);

  Map<String, dynamic> toJson() => _$MedicationToJson(this);
}

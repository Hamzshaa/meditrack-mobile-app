import 'package:json_annotation/json_annotation.dart';

part 'pharmacy.g.dart';

@JsonSerializable()
class PharmacyImage {
  @JsonKey(name: 'image_id')
  final int imageId;
  @JsonKey(name: 'image_url')
  final String imageUrl;

  PharmacyImage({
    required this.imageId,
    required this.imageUrl,
  });

  factory PharmacyImage.fromJson(Map<String, dynamic> json) =>
      _$PharmacyImageFromJson(json);

  Map<String, dynamic> toJson() => _$PharmacyImageToJson(this);
}

@JsonSerializable()
class Pharmacy {
  @JsonKey(name: 'pharmacy_id')
  final int pharmacyId;
  final String name;
  final String address;
  // Store as String from JSON, parse to double when needed
  final String latitude;
  final String longitude;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  final String? email;
  @JsonKey(name: 'manager_id')
  final int managerId;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'manager_first_name')
  final String managerFirstName;
  @JsonKey(name: 'manager_last_name')
  final String managerLastName;
  @JsonKey(name: 'manager_email')
  final String managerEmail;
  @JsonKey(name: 'manager_phone')
  final String managerPhone;
  @JsonKey(defaultValue: [])
  final List<PharmacyImage> images;

  Pharmacy({
    required this.pharmacyId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    this.email,
    required this.managerId,
    required this.createdAt,
    required this.updatedAt,
    required this.managerFirstName,
    required this.managerLastName,
    required this.managerEmail,
    required this.managerPhone,
    required this.images,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) =>
      _$PharmacyFromJson(json);

  Map<String, dynamic> toJson() => _$PharmacyToJson(this);

  double? get latitudeDouble {
    return double.tryParse(latitude);
  }

  double? get longitudeDouble {
    return double.tryParse(longitude);
  }
}

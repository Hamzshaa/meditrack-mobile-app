import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meditrack/utils/date_utils.dart';

part 'pharmacy_overview_data.g.dart';

@JsonSerializable(explicitToJson: true)
class PharmacyData extends Equatable {
  final String name;
  final String address;

  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  final String email;

  const PharmacyData({
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.email,
  });

  factory PharmacyData.fromJson(Map<String, dynamic> json) =>
      _$PharmacyDataFromJson(json);
  Map<String, dynamic> toJson() => _$PharmacyDataToJson(this);
  @override
  List<Object?> get props => [name, address, phoneNumber, email];
}

@JsonSerializable(explicitToJson: true)
class Stats extends Equatable {
  final int totalMedications;
  final int totalBatches;
  final String totalQuantity;
  final int expiredBatches;
  final int reorderNeeded;
  final int outOfStock;
  final int nearExpiry;

  const Stats({
    required this.totalMedications,
    required this.totalBatches,
    required this.totalQuantity,
    required this.expiredBatches,
    required this.reorderNeeded,
    required this.outOfStock,
    required this.nearExpiry,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => _$StatsFromJson(json);

  Map<String, dynamic> toJson() => _$StatsToJson(this);

  @override
  List<Object?> get props => [
        totalMedications,
        totalBatches,
        totalQuantity,
        expiredBatches,
        reorderNeeded,
        outOfStock,
        nearExpiry,
      ];
}

@JsonSerializable(explicitToJson: true)
class RecentMedications extends Equatable {
  @JsonKey(name: 'medication_id')
  final int medicationId;
  @JsonKey(name: 'medication_brand_name')
  final String medicationBrandName;
  final String strength;
  final String manufacturer;
  @JsonKey(
      name: 'created_at',
      fromJson: dateTimeFromStringNullable,
      toJson: dateTimeToStringNullable)
  final DateTime? createdAt;

  const RecentMedications({
    required this.medicationId,
    required this.medicationBrandName,
    required this.strength,
    required this.manufacturer,
    this.createdAt,
  });

  factory RecentMedications.fromJson(Map<String, dynamic> json) =>
      _$RecentMedicationsFromJson(json);
  Map<String, dynamic> toJson() => _$RecentMedicationsToJson(this);

  @override
  List<Object?> get props => [
        medicationId,
        medicationBrandName,
        strength,
        manufacturer,
        createdAt,
      ];
}

@JsonSerializable(explicitToJson: true)
class ExpiringSoon extends Equatable {
  @JsonKey(name: 'inventory_id')
  final int inventoryId;
  @JsonKey(name: 'batch_number')
  final String batchNumber;
  @JsonKey(
    name: 'expiration_date',
    fromJson: dateTimeFromStringNullable,
    toJson: dateTimeToStringNullable,
  )
  final DateTime? expirationDate;
  final int quantity;
  @JsonKey(name: 'medication_brand_name')
  final String medicationBrandName;
  final String strength;

  const ExpiringSoon({
    required this.inventoryId,
    required this.batchNumber,
    required this.expirationDate,
    required this.quantity,
    required this.medicationBrandName,
    required this.strength,
  });

  factory ExpiringSoon.fromJson(Map<String, dynamic> json) =>
      _$ExpiringSoonFromJson(json);

  Map<String, dynamic> toJson() => _$ExpiringSoonToJson(this);

  @override
  List<Object?> get props => [
        inventoryId,
        batchNumber,
        expirationDate,
        quantity,
        medicationBrandName,
        strength,
      ];
}

@JsonSerializable(explicitToJson: true)
class PharmacyOverviewData extends Equatable {
  final PharmacyData pharmacy;

  final Stats stats;

  @JsonKey(defaultValue: [])
  final List<RecentMedications> recentMedications;

  @JsonKey(defaultValue: [])
  final List<ExpiringSoon> expiringSoon;

  const PharmacyOverviewData({
    required this.pharmacy,
    required this.stats,
    required this.recentMedications,
    required this.expiringSoon,
  });

  factory PharmacyOverviewData.fromJson(Map<String, dynamic> json) =>
      _$PharmacyOverviewDataFromJson(json);

  Map<String, dynamic> toJson() => _$PharmacyOverviewDataToJson(this);

  @override
  List<Object?> get props => [
        pharmacy,
        stats,
        recentMedications,
        expiringSoon,
      ];
}

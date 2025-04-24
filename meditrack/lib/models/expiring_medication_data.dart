import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:meditrack/utils/date_utils.dart';

part 'expiring_medication_data.g.dart';

@JsonSerializable(explicitToJson: true)
class ExpiredMedications extends Equatable {
  @JsonKey(name: 'medication_id')
  final int medicationId;
  @JsonKey(name: 'medication_brand_name')
  final String medicationBrandName;
  @JsonKey(name: 'batch_number')
  final String batchNumber;
  @JsonKey(
    name: 'expiration_date',
    fromJson: dateTimeFromStringNullable,
    toJson: dateTimeToStringNullable,
  )
  final DateTime? expirationDate;
  @JsonKey(name: 'days_ago')
  final int daysAgo;

  const ExpiredMedications({
    required this.medicationId,
    required this.medicationBrandName,
    required this.batchNumber,
    this.expirationDate,
    required this.daysAgo,
  });

  factory ExpiredMedications.fromJson(Map<String, dynamic> json) =>
      _$ExpiredMedicationsFromJson(json);

  Map<String, dynamic> toJson() => _$ExpiredMedicationsToJson(this);

  @override
  List<Object?> get props => [
        medicationId,
        medicationBrandName,
        batchNumber,
        expirationDate,
        daysAgo,
      ];
}

@JsonSerializable(explicitToJson: true)
class ExpiringSoon extends Equatable {
  @JsonKey(name: 'medication_id')
  final int medicationId;
  @JsonKey(name: 'medication_brand_name')
  final String medicationBrandName;
  @JsonKey(name: 'batch_number')
  final String batchNumber;
  @JsonKey(
    name: 'expiration_date',
    fromJson: dateTimeFromStringNullable,
    toJson: dateTimeToStringNullable,
  )
  final DateTime? expirationDate;
  @JsonKey(name: 'days_left')
  final int daysLeft;

  const ExpiringSoon({
    required this.medicationId,
    required this.medicationBrandName,
    required this.batchNumber,
    this.expirationDate,
    required this.daysLeft,
  });

  factory ExpiringSoon.fromJson(Map<String, dynamic> json) =>
      _$ExpiringSoonFromJson(json);

  Map<String, dynamic> toJson() => _$ExpiringSoonToJson(this);

  @override
  List<Object?> get props => [
        medicationId,
        medicationBrandName,
        batchNumber,
        expirationDate,
        daysLeft,
      ];
}

@JsonSerializable(explicitToJson: true)
class ExpiringMedications extends Equatable {
  @JsonKey(defaultValue: [])
  final List<ExpiredMedications> expiredMedications;
  @JsonKey(defaultValue: [])
  final List<ExpiringSoon> expiringSoon;

  const ExpiringMedications({
    required this.expiredMedications,
    required this.expiringSoon,
  });

  factory ExpiringMedications.fromJson(Map<String, dynamic> json) =>
      _$ExpiringMedicationsFromJson(json);

  Map<String, dynamic> toJson() => _$ExpiringMedicationsToJson(this);

  @override
  List<Object?> get props => [expiredMedications, expiringSoon];
}

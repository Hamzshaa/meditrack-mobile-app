import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meditrack/utils/date_utils.dart';

part 'batch.g.dart';

@JsonSerializable(explicitToJson: true)
class Batch extends Equatable {
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

  const Batch({
    required this.inventoryId,
    required this.batchNumber,
    this.expirationDate,
  });

  factory Batch.fromJson(Map<String, dynamic> json) => _$BatchFromJson(json);

  Map<String, dynamic> toJson() => _$BatchToJson(this);

  @override
  List<Object?> get props => [inventoryId, batchNumber, expirationDate];
}

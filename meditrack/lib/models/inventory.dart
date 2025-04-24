import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meditrack/utils/date_utils.dart';

part 'inventory.g.dart';

@JsonSerializable(explicitToJson: true)
class InventoryTable extends Equatable {
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
  @JsonKey(
      name: 'last_updated',
      fromJson: dateTimeFromStringNullable,
      toJson: dateTimeToStringNullable)
  final DateTime? lastUpdated;

  const InventoryTable({
    required this.inventoryId,
    required this.batchNumber,
    required this.expirationDate,
    required this.quantity,
    this.lastUpdated,
  });

  factory InventoryTable.fromJson(Map<String, dynamic> json) =>
      _$InventoryTableFromJson(json);
  Map<String, dynamic> toJson() => _$InventoryTableToJson(this);
  @override
  List<Object?> get props => [
        inventoryId,
        batchNumber,
        expirationDate,
        quantity,
        lastUpdated,
      ];
}

@JsonSerializable(explicitToJson: true)
class Inventory extends Equatable {
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
  @JsonKey(name: 'category_id')
  final int categoryId;
  @JsonKey(
      name: 'created_at',
      fromJson: dateTimeFromStringNullable,
      toJson: dateTimeToStringNullable)
  final DateTime? createdAt;
  @JsonKey(
      name: 'updated_at',
      fromJson: dateTimeFromStringNullable,
      toJson: dateTimeToStringNullable)
  final DateTime? updatedAt;
  @JsonKey(name: 'pharmacy_id')
  final int pharmacyId;
  @JsonKey(defaultValue: [])
  final List<InventoryTable> inventory;
  @JsonKey(name: 'total_quantity')
  final int totalQuantity;
  @JsonKey(name: 'reorder_point')
  final int reorderPoint;

  const Inventory({
    required this.medicationId,
    required this.medicationBrandName,
    required this.medicationGenericName,
    required this.dosageForm,
    required this.strength,
    required this.manufacturer,
    this.description,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.pharmacyId,
    required this.inventory,
    required this.totalQuantity,
    required this.reorderPoint,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) =>
      _$InventoryFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryToJson(this);

  @override
  List<Object?> get props => [
        medicationId,
        medicationBrandName,
        medicationGenericName,
        dosageForm,
        strength,
        manufacturer,
        description,
        categoryId,
        createdAt,
        updatedAt,
        pharmacyId,
        inventory,
        totalQuantity,
        reorderPoint,
      ];
}

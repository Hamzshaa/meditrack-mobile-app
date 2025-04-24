import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'medication_category.g.dart';

@JsonSerializable(explicitToJson: true)
class MedicationCategory extends Equatable {
  @JsonKey(name: 'category_id')
  final int categoryId;
  @JsonKey(name: 'category_name')
  final String categoryName;
  @JsonKey(name: 'pharmacy_id')
  final int pharmacyId;

  const MedicationCategory({
    required this.categoryId,
    required this.categoryName,
    required this.pharmacyId,
  });

  factory MedicationCategory.fromJson(Map<String, dynamic> json) =>
      _$MedicationCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$MedicationCategoryToJson(this);

  @override
  List<Object?> get props => [categoryId, categoryName, pharmacyId];

  @override
  String toString() {
    return 'MedicationCategory{categoryId: $categoryId, categoryName: $categoryName, pharmacyId: $pharmacyId}';
  }
}

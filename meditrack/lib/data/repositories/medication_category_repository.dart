import 'package:meditrack/data/services/medication_category_api_service.dart';
import 'package:meditrack/models/medication_category.dart';

class MedicationCategoryRepository {
  final MedicationCategoryApiService medicationCategoryApiService;

  MedicationCategoryRepository(this.medicationCategoryApiService);

  Future<List<MedicationCategory>> getCategories({
    required String token,
  }) async {
    try {
      final medicationCategoryListJson =
          await medicationCategoryApiService.getCategories(token: token);

      return medicationCategoryListJson.map((json) {
        if (json is Map<String, dynamic>) {
          return MedicationCategory.fromJson(json);
        } else {
          throw const FormatException(
              'Invalid item format in medication category list');
        }
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addCategory({
    required String token,
    required String categoryName,
  }) async {
    try {
      await medicationCategoryApiService.addCategory(
        token: token,
        categoryName: categoryName,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCategory({
    required String token,
    required int categoryId,
    required String categoryName,
  }) async {
    try {
      await medicationCategoryApiService.updateCategory(
        token: token,
        categoryId: categoryId,
        categoryName: categoryName,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCategory({
    required String token,
    required int categoryId,
  }) async {
    try {
      await medicationCategoryApiService.deleteCategory(
        token: token,
        categoryId: categoryId,
      );
    } catch (e) {
      rethrow;
    }
  }
}

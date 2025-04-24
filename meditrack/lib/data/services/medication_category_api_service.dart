import 'package:dio/dio.dart';

class MedicationCategoryApiService {
  final Dio dio;

  MedicationCategoryApiService(this.dio);

  Future<List<dynamic>> getCategories({
    required String token,
  }) async {
    try {
      const url = '/medication-categories';
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );

      if (response.data is List) {
        return response.data as List<dynamic>;
      } else {
        throw Exception('API returned unexpected data format.');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load medication categories: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load medication categories: $e');
    }
  }

  Future<void> addCategory({
    required String token,
    required String categoryName,
  }) async {
    try {
      const url = '/medication-categories';
      final response = await dio.post(
        url,
        data: {'category_name': categoryName},
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add medication category.');
      }
    } on DioException catch (e) {
      throw Exception('Failed to add medication category: ${e.message}');
    } catch (e) {
      throw Exception('Failed to add medication category: $e');
    }
  }

  Future<void> updateCategory({
    required String token,
    required int categoryId,
    required String categoryName,
  }) async {
    try {
      final url = '/medication-categories/$categoryId';
      final response = await dio.put(
        url,
        data: {
          'category_name': categoryName,
        },
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update medication category.');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update medication category: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update medication category: $e');
    }
  }

  Future<void> deleteCategory({
    required String token,
    required int categoryId,
  }) async {
    try {
      final url = '/medication-categories/$categoryId';
      final response = await dio.delete(
        url,
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete medication category.');
      }
    } on DioException catch (e) {
      throw Exception('Failed to delete medication category: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete medication category: $e');
    }
  }
}

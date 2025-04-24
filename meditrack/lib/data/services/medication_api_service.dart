import 'package:dio/dio.dart';

class MedicationApiService {
  final Dio dio;

  MedicationApiService(this.dio);

  Future<List<dynamic>> searchMedication({
    required String searchQuery,
    required double lat,
    required double lon,
  }) async {
    try {
      final response = await dio.get(
        '/medications/search',
        queryParameters: {
          'searchQuery': searchQuery,
          'lat': lat,
          'lon': lon,
        },
      );

      if (response.data is List) {
        return response.data as List<dynamic>;
      } else {
        throw Exception('API returned unexpected data format.');
      }
    } on DioException catch (e) {
      throw Exception('Failed to search medication: ${e.message}');
    } catch (e) {
      throw Exception('Failed to search medication data: $e');
    }
  }

  Future<List<dynamic>> getMedications({
    required String token,
  }) async {
    try {
      const url = '/medications';
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
      throw Exception('Failed to load medication data: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load medication data: $e');
    }
  }

  Future<dynamic> getMedicationById({
    required String token,
    required int medicationId,
  }) async {
    try {
      final response = await dio.get(
        '/medications/$medicationId',
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );

      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('API returned unexpected data format.');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load medication data: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load medication data: $e');
    }
  }

  Future<void> addMedication({
    required String token,
    required String medicationBrandName,
    required String medicationGenericName,
    required String dosageForm,
    required String strength,
    required String manufacturer,
    required int reorderPoint,
    String? description,
    required String categoryId,
  }) async {
    try {
      const url = '/medications';
      final response = await dio.post(
        url,
        data: {
          'medication_brand_name': medicationBrandName,
          'medication_generic_name': medicationGenericName,
          'dosage_form': dosageForm,
          'strength': strength,
          'manufacturer': manufacturer,
          'reorder_point': reorderPoint,
          'description': description,
          'category_id': categoryId,
        },
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add medication.');
      }
    } on DioException catch (e) {
      throw Exception('Failed to add medication: ${e.message}');
    } catch (e) {
      throw Exception('Failed to add medication: $e');
    }
  }

  Future<void> updateMedication({
    required String token,
    required int medicationId,
    required String medicationBrandName,
    required String medicationGenericName,
    required String dosageForm,
    required String strength,
    required String manufacturer,
    required int reorderPoint,
    String? description,
    required String categoryId,
  }) async {
    try {
      final url = '/medications/$medicationId';
      final response = await dio.put(
        url,
        data: {
          'medication_brand_name': medicationBrandName,
          'medication_generic_name': medicationGenericName,
          'dosage_form': dosageForm,
          'strength': strength,
          'manufacturer': manufacturer,
          'reorder_point': reorderPoint,
          'description': description,
          'category_id': categoryId,
        },
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update medication.');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update medication: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update medication: $e');
    }
  }

  Future<void> deleteMedication({
    required String token,
    required int medicationId,
  }) async {
    try {
      final url = '/medications/$medicationId';
      final response = await dio.delete(
        url,
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete medication.');
      }
    } on DioException catch (e) {
      throw Exception('Failed to delete medication: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete medication: $e');
    }
  }
}

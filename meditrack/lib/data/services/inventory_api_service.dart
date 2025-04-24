import 'package:dio/dio.dart';

class InventoryApiService {
  final Dio dio;

  InventoryApiService(this.dio);

  Future<List<dynamic>> getInventory({
    required String token,
  }) async {
    try {
      const url = '/inventory';
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
      throw Exception('Failed to load inventory data: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load inventory data: $e');
    }
  }

  Future<dynamic> getInventoryById({
    required String token,
    required int inventoryId,
  }) async {
    try {
      final response = await dio.get(
        '/inventory/$inventoryId',
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
      throw Exception('Failed to load inventory data: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load inventory data: $e');
    }
  }

  Future<void> addInventory({
    required String token,
    required int medicationId,
    required String batchNumber,
    required int quantity,
    required String expirationDate,
  }) async {
    try {
      const url = '/inventory';
      final response = await dio.post(
        url,
        data: {
          'medication_id': medicationId,
          'batch_number': batchNumber,
          'quantity': quantity,
          'expiration_date': expirationDate,
        },
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add inventory.');
      }
    } on DioException catch (e) {
      throw Exception('Failed to add inventory: ${e.message}');
    } catch (e) {
      throw Exception('Failed to add inventory: $e');
    }
  }

  Future<void> updateInventory({
    required String token,
    required int inventoryId,
    required int medicationId,
    required String batchNumber,
    required int quantity,
    required String expirationDate,
  }) async {
    try {
      final url = '/inventory/$inventoryId';
      final response = await dio.put(
        url,
        data: {
          'medication_id': medicationId,
          'batch_number': batchNumber,
          'quantity': quantity,
          'expiration_date': expirationDate,
        },
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update inventory.');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update inventory: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update inventory: $e');
    }
  }

  Future<void> deleteInventory({
    required String token,
    required int inventoryId,
  }) async {
    try {
      final url = '/inventory/$inventoryId';
      final response = await dio.delete(
        url,
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete inventory.');
      }
    } on DioException catch (e) {
      throw Exception('Failed to delete inventory: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete inventory: $e');
    }
  }

  Future<void> deductInventory({
    required String token,
    required int inventoryId,
    required int quantity,
  }) async {
    print('Deduct Inventory Service Function');
    try {
      const url = '/inventory/deduct';
      final response = await dio.put(
        url,
        data: {
          'quantity': quantity,
          'inventory_id': inventoryId,
        },
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );

      print('Response status code: $response ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception('Failed to deduct inventory.');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      throw Exception('Failed to deduct inventory: ${e.message}');
    } catch (e) {
      print('General Exception: $e');
      throw Exception('Failed to deduct inventory: $e');
    }
  }

  Future<void> addToInventory({
    required String token,
    required int inventoryId,
    required int quantity,
  }) async {
    try {
      const url = '/inventory/addtoinventory';
      final response = await dio.put(
        url,
        data: {
          'quantity': quantity,
          'inventory_id': inventoryId,
        },
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add to inventory.');
      }
    } on DioException catch (e) {
      throw Exception('Failed to add to inventory: ${e.message}');
    } catch (e) {
      throw Exception('Failed to add to inventory: $e');
    }
  }

  Future<List<dynamic>> getBatches({
    required String token,
    int? medicationId,
  }) async {
    try {
      final url = '/inventory/batches?medicationId=$medicationId';
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
      throw Exception('Failed to load batches data: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load batches data: $e');
    }
  }

  Future<dynamic> getExpiringMedications({
    required String token,
  }) async {
    try {
      const url = '/inventory/expired';
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
            'API returned unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load expiring medications data: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load expiring medications data: $e');
    }
  }
}

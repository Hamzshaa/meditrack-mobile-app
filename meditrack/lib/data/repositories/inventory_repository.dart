import 'package:meditrack/data/services/inventory_api_service.dart';
import 'package:meditrack/models/batch.dart';
import 'package:meditrack/models/expiring_medication_data.dart';
import 'package:meditrack/models/inventory.dart';

class InventoryRepository {
  final InventoryApiService inventoryApiService;

  InventoryRepository(this.inventoryApiService);

  Future<List<Inventory>> getInventory({
    required String token,
  }) async {
    try {
      final inventoryListJson =
          await inventoryApiService.getInventory(token: token);

      return inventoryListJson.map((json) {
        if (json is Map<String, dynamic>) {
          return Inventory.fromJson(json);
        } else {
          throw const FormatException('Invalid item format in inventory list');
        }
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Inventory> getInventoryById({
    required String token,
    required int inventoryId,
  }) async {
    try {
      final inventoryJson = await inventoryApiService.getInventoryById(
        token: token,
        inventoryId: inventoryId,
      );

      if (inventoryJson is Map<String, dynamic>) {
        return Inventory.fromJson(inventoryJson);
      } else {
        throw const FormatException('Invalid item format in inventory list');
      }
    } catch (e) {
      rethrow;
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
      await inventoryApiService.addInventory(
        token: token,
        medicationId: medicationId,
        batchNumber: batchNumber,
        quantity: quantity,
        expirationDate: expirationDate,
      );
    } catch (e) {
      rethrow;
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
      await inventoryApiService.updateInventory(
        token: token,
        inventoryId: inventoryId,
        medicationId: medicationId,
        batchNumber: batchNumber,
        quantity: quantity,
        expirationDate: expirationDate,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteInventory({
    required String token,
    required int inventoryId,
  }) async {
    try {
      await inventoryApiService.deleteInventory(
        token: token,
        inventoryId: inventoryId,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deductInventory({
    required String token,
    required int inventoryId,
    required int quantity,
  }) async {
    try {
      await inventoryApiService.deductInventory(
        token: token,
        inventoryId: inventoryId,
        quantity: quantity,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addToInventory({
    required String token,
    required int inventoryId,
    required int quantity,
  }) async {
    try {
      await inventoryApiService.addToInventory(
        token: token,
        inventoryId: inventoryId,
        quantity: quantity,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Batch>> getBatches({
    required String token,
    int? medicationId,
  }) async {
    try {
      final batchListJson = await inventoryApiService.getBatches(
        token: token,
        medicationId: medicationId,
      );

      return batchListJson.map((json) {
        if (json is Map<String, dynamic>) {
          return Batch.fromJson(json);
        } else {
          throw const FormatException('Invalid item format in batch list');
        }
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<ExpiringMedications> getExpiringMedications({
    required String token,
  }) async {
    try {
      final expiringMedicationsJson =
          await inventoryApiService.getExpiringMedications(token: token);

      print(
          '#########################################################################################################################expiringMedicationsJson: $expiringMedicationsJson');

      if (expiringMedicationsJson is Map<String, dynamic>) {
        print(
            '----------------------------------------------------------------------------------------------------------------------------------------------------------------');
        return ExpiringMedications.fromJson(expiringMedicationsJson);
      } else {
        print(
            'Invalid item format in expiring medications list: $expiringMedicationsJson');
        throw const FormatException(
            'Invalid item format in expiring medications list');
      }
    } catch (e) {
      print(
          '***************************************************************************************************************************************************************Error in getExpiringMedications: $e'); // Log the error for debugging
      rethrow;
    }
  }
}

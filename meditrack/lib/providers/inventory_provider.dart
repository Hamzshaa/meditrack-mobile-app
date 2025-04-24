import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:meditrack/data/services/inventory_api_service.dart';
import 'package:meditrack/data/repositories/inventory_repository.dart';
import 'package:meditrack/models/inventory.dart';
import 'package:meditrack/models/batch.dart';
import 'package:meditrack/models/expiring_medication_data.dart';
import 'package:meditrack/providers/auth_provider.dart';
import 'package:meditrack/providers/dio_provider.dart';

part 'inventory_provider.g.dart';

@riverpod
InventoryApiService inventoryApiService(InventoryApiServiceRef ref) {
  final dio = ref.watch(dioProvider);
  return InventoryApiService(dio);
}

@riverpod
InventoryRepository inventoryRepository(InventoryRepositoryRef ref) {
  final apiService = ref.watch(inventoryApiServiceProvider);
  return InventoryRepository(apiService);
}

String _getTokenOrThrow(ref) {
  final tokenAsyncValue = ref.watch(authNotifierProvider);

  if (tokenAsyncValue is AsyncData<String?>) {
    final String? token = tokenAsyncValue.value;
    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is null or empty. Please log in.');
    }
    return token;
  } else if (tokenAsyncValue is AsyncLoading) {
    throw Exception('Authentication token is still loading.');
  } else if (tokenAsyncValue is AsyncError) {
    throw Exception(
        'Error loading authentication token: ${tokenAsyncValue.error}');
  } else {
    throw Exception('Unexpected authentication state.');
  }
}

@riverpod
class InventoryNotifier extends _$InventoryNotifier {
  @override
  FutureOr<List<Inventory>> build() async {
    final token = _getTokenOrThrow(ref);
    final inventoryRepo = ref.watch(inventoryRepositoryProvider);

    final link = ref.keepAlive();
    final timer = Timer(const Duration(seconds: 30), () {
      link.close();
    });
    ref.onDispose(() => timer.cancel());

    final inventoryList = await inventoryRepo.getInventory(token: token);
    return inventoryList;
  }

  Future<List<Inventory>> getInventory() async {
    final token = _getTokenOrThrow(ref);
    final inventoryRepo = ref.watch(inventoryRepositoryProvider);

    final link = ref.keepAlive();
    final timer = Timer(const Duration(seconds: 30), () {
      link.close();
    });
    ref.onDispose(() => timer.cancel());

    final inventoryList = await inventoryRepo.getInventory(token: token);
    return inventoryList;
  }

  Future<Inventory> getInventoryById(int inventoryId) async {
    final token = _getTokenOrThrow(ref);
    final inventoryRepo = ref.watch(inventoryRepositoryProvider);

    final link = ref.keepAlive();
    final timer = Timer(const Duration(seconds: 30), () {
      link.close();
    });
    ref.onDispose(() => timer.cancel());

    final inventory = await inventoryRepo.getInventoryById(
      token: token,
      inventoryId: inventoryId,
    );
    return inventory;
  }

  Future<void> addInventory({
    required int medicationId,
    required String batchNumber,
    required int quantity,
    required String expirationDate,
  }) async {
    final token = _getTokenOrThrow(ref);
    final inventoryRepo = ref.watch(inventoryRepositoryProvider);

    final link = ref.keepAlive();
    final timer = Timer(const Duration(seconds: 30), () {
      link.close();
    });
    ref.onDispose(() => timer.cancel());

    await inventoryRepo.addInventory(
      token: token,
      medicationId: medicationId,
      batchNumber: batchNumber,
      quantity: quantity,
      expirationDate: expirationDate,
    );
  }

  Future<void> updateInventory({
    required int inventoryId,
    required int medicationId,
    required String batchNumber,
    required int quantity,
    required String expirationDate,
  }) async {
    final token = _getTokenOrThrow(ref);
    final inventoryRepo = ref.watch(inventoryRepositoryProvider);

    final link = ref.keepAlive();
    final timer = Timer(const Duration(seconds: 30), () {
      link.close();
    });
    ref.onDispose(() => timer.cancel());

    await inventoryRepo.updateInventory(
      token: token,
      inventoryId: inventoryId,
      medicationId: medicationId,
      batchNumber: batchNumber,
      quantity: quantity,
      expirationDate: expirationDate,
    );
  }

  Future<void> deleteInventory(int inventoryId) async {
    final token = _getTokenOrThrow(ref);
    final inventoryRepo = ref.watch(inventoryRepositoryProvider);

    final link = ref.keepAlive();
    final timer = Timer(const Duration(seconds: 30), () {
      link.close();
    });
    ref.onDispose(() => timer.cancel());

    await inventoryRepo.deleteInventory(
      token: token,
      inventoryId: inventoryId,
    );
  }

  Future<List<Batch>> getBatchList({int? medicationId}) async {
    final token = _getTokenOrThrow(ref);
    final inventoryRepo = ref.watch(inventoryRepositoryProvider);

    final link = ref.keepAlive();
    final timer = Timer(const Duration(seconds: 30), () {
      link.close();
    });
    ref.onDispose(() => timer.cancel());

    final batchList = await inventoryRepo.getBatches(
      token: token,
      medicationId: medicationId,
    );
    return batchList;
  }

  Future<ExpiringMedications> getExpiringMedications() async {
    final token = _getTokenOrThrow(ref);
    final inventoryRepo = ref.watch(inventoryRepositoryProvider);

    final link = ref.keepAlive();
    final timer = Timer(const Duration(seconds: 30), () {
      link.close();
    });
    ref.onDispose(() => timer.cancel());

    final expiringMedications = await inventoryRepo.getExpiringMedications(
      token: token,
    );
    return expiringMedications;
  }

  Future<void> deductInventory({
    required int inventoryId,
    required int quantity,
  }) async {
    final token = _getTokenOrThrow(ref);
    final inventoryRepo = ref.watch(inventoryRepositoryProvider);

    await inventoryRepo.deductInventory(
      token: token,
      inventoryId: inventoryId,
      quantity: quantity,
    );

    ref.invalidateSelf();

    await future;
  }

  Future<void> addToInventory({
    required int inventoryId,
    required int quantity,
  }) async {
    final token = _getTokenOrThrow(ref);
    final inventoryRepo = ref.watch(inventoryRepositoryProvider);

    await inventoryRepo.addToInventory(
      token: token,
      inventoryId: inventoryId,
      quantity: quantity,
    );

    ref.invalidateSelf();

    await future;
  }
}

@riverpod
Future<ExpiringMedications> expiringMedications(
    ExpiringMedicationsRef ref) async {
  final token = _getTokenOrThrow(ref);
  final inventoryRepo = ref.watch(inventoryRepositoryProvider);

  return await inventoryRepo.getExpiringMedications(token: token);
}

import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:meditrack/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:meditrack/data/services/medication_api_service.dart';
import 'package:meditrack/data/services/medication_category_api_service.dart';
import 'package:meditrack/data/repositories/medication_repository.dart';
import 'package:meditrack/data/repositories/medication_category_repository.dart';
import 'package:meditrack/models/medication.dart';
import 'package:meditrack/models/medication_category.dart';
import 'dio_provider.dart';
import 'location_provider.dart';

part 'medication_provider.g.dart';

@riverpod
MedicationApiService medicationApiService(MedicationApiServiceRef ref) {
  final dio = ref.watch(dioProvider);
  return MedicationApiService(dio);
}

@riverpod
MedicationRepository medicationRepository(MedicationRepositoryRef ref) {
  final apiService = ref.watch(medicationApiServiceProvider);
  return MedicationRepository(apiService);
}

@riverpod
MedicationCategoryApiService medicationCategoryApiService(
    MedicationCategoryApiServiceRef ref) {
  final dio = ref.watch(dioProvider);
  return MedicationCategoryApiService(dio);
}

@riverpod
MedicationCategoryRepository medicationCategoryRepository(
    MedicationCategoryRepositoryRef ref) {
  final apiService = ref.watch(medicationCategoryApiServiceProvider);
  return MedicationCategoryRepository(apiService);
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
    throw Exception('Authentication state is not ready or unexpected.');
  }
}

@riverpod
class MedicationsNotifier extends _$MedicationsNotifier {
  Future<List<Medication>> _fetchMedicationsByLocation(
    String searchQuery,
    Position location,
  ) async {
    final medicationRepo = ref.read(medicationRepositoryProvider);

    try {
      final medications = await medicationRepo.searchMedication(
        searchQuery: searchQuery,
        lat: location.latitude,
        lon: location.longitude,
      );
      return medications;
    } catch (e) {
      throw Exception("Failed to search medications: $e");
    }
  }

  @override
  Future<List<Medication>> build() async {
    final position = await ref.read(currentLocationProvider.future);

    return await _fetchMedicationsByLocation('', position);
  }

  Future<void> search(String searchQuery) async {
    state = const AsyncValue.loading();

    try {
      final position = await ref.read(currentLocationProvider.future);

      state = await AsyncValue.guard(
          () => _fetchMedicationsByLocation(searchQuery, position));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<Medication> getMedicationById(int medicationId) async {
    try {
      final token = _getTokenOrThrow(ref);
      final medicationRepo = ref.read(medicationRepositoryProvider);
      return await medicationRepo.getMedicationById(
        token: token,
        medicationId: medicationId,
      );
    } catch (e) {
      throw Exception("Failed to get medication details: $e");
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    ref.read(currentLocationProvider);

    ref.invalidateSelf();
  }
}

@riverpod
class PharmacyMedicationsNotifier extends _$PharmacyMedicationsNotifier {
  Future<List<Medication>> _fetchPharmacyMedications() async {
    final token = _getTokenOrThrow(ref);
    final medicationRepo = ref.read(medicationRepositoryProvider);
    try {
      final medications = await medicationRepo.getMedications(token: token);
      return medications;
    } catch (e) {
      throw Exception("Failed to fetch pharmacy medications: $e");
    }
  }

  @override
  Future<List<Medication>> build() async {
    ref.watch(authNotifierProvider);
    return await _fetchPharmacyMedications();
  }

  Future<void> addMedication({
    required String medicationBrandName,
    required String medicationGenericName,
    required String dosageForm,
    required String strength,
    required String manufacturer,
    required int reorderPoint,
    String? description,
    required int categoryId,
  }) async {
    final token = _getTokenOrThrow(ref);
    final medicationRepo = ref.read(medicationRepositoryProvider);

    try {
      await medicationRepo.addMedication(
        token: token,
        medicationBrandName: medicationBrandName,
        medicationGenericName: medicationGenericName,
        categoryId: categoryId.toString(),
        dosageForm: dosageForm,
        strength: strength,
        manufacturer: manufacturer,
        reorderPoint: reorderPoint,
        description: description,
      );

      ref.invalidateSelf();
    } catch (e) {
      print("Error adding medication: $e");
      throw Exception("Failed to add medication. Please try again.");
    }
  }

  Future<void> updateMedication({
    required int medicationId,
    required String medicationBrandName,
    required String medicationGenericName,
    required String dosageForm,
    required String strength,
    required String manufacturer,
    required int reorderPoint,
    String? description,
    required int categoryId,
  }) async {
    final token = _getTokenOrThrow(ref);
    final medicationRepo = ref.read(medicationRepositoryProvider);

    try {
      await medicationRepo.updateMedication(
        token: token,
        medicationId: medicationId,
        medicationBrandName: medicationBrandName,
        medicationGenericName: medicationGenericName,
        categoryId: categoryId.toString(),
        dosageForm: dosageForm,
        strength: strength,
        manufacturer: manufacturer,
        reorderPoint: reorderPoint,
        description: description,
      );

      ref.invalidateSelf();
    } catch (e) {
      print("Error updating medication: $e");
      throw Exception("Failed to update medication. Please try again.");
    }
  }

  Future<void> deleteMedication(int medicationId) async {
    final token = _getTokenOrThrow(ref);
    final medicationRepo = ref.read(medicationRepositoryProvider);

    try {
      await medicationRepo.deleteMedication(
        token: token,
        medicationId: medicationId,
      );

      ref.invalidateSelf();
    } catch (e) {
      print("Error deleting medication: $e");
      throw Exception("Failed to delete medication. Please try again.");
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() => _fetchPharmacyMedications());
  }
}

@riverpod
class MedicationCategoriesNotifier extends _$MedicationCategoriesNotifier {
  @override
  Future<List<MedicationCategory>> build() async {
    ref.watch(authNotifierProvider);
    final token = _getTokenOrThrow(ref);
    final medicationCategoryRepository =
        ref.watch(medicationCategoryRepositoryProvider);

    return await medicationCategoryRepository.getCategories(token: token);
  }

  Future<void> addCategory(String categoryName) async {
    final token = _getTokenOrThrow(ref);
    final medicationCategoryRepository =
        ref.read(medicationCategoryRepositoryProvider);

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await medicationCategoryRepository.addCategory(
        token: token,
        categoryName: categoryName,
      );

      return await medicationCategoryRepository.getCategories(token: token);
    });
  }

  Future<void> updateCategory(int categoryId, String categoryName) async {
    final token = _getTokenOrThrow(ref);
    final medicationCategoryRepository =
        ref.read(medicationCategoryRepositoryProvider);

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await medicationCategoryRepository.updateCategory(
        token: token,
        categoryId: categoryId,
        categoryName: categoryName,
      );
      return await medicationCategoryRepository.getCategories(token: token);
    });
  }

  Future<void> deleteCategory(int categoryId) async {
    final token = _getTokenOrThrow(ref);
    final medicationCategoryRepository =
        ref.read(medicationCategoryRepositoryProvider);

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await medicationCategoryRepository.deleteCategory(
        token: token,
        categoryId: categoryId,
      );
      return await medicationCategoryRepository.getCategories(token: token);
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final token = _getTokenOrThrow(ref);
    final medicationCategoryRepository =
        ref.read(medicationCategoryRepositoryProvider);

    state = await AsyncValue.guard(() async {
      return await medicationCategoryRepository.getCategories(token: token);
    });
  }
}

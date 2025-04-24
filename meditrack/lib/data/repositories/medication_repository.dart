import 'package:meditrack/data/services/medication_api_service.dart';
import 'package:meditrack/models/medication.dart';

class MedicationRepository {
  final MedicationApiService medicationApiService;

  MedicationRepository(this.medicationApiService);

  Future<List<Medication>> searchMedication({
    required String searchQuery,
    required double lat,
    required double lon,
  }) async {
    try {
      final medicationListJson = await medicationApiService.searchMedication(
        searchQuery: searchQuery,
        lat: lat,
        lon: lon,
      );

      return medicationListJson.map((json) {
        if (json is Map<String, dynamic>) {
          return Medication.fromJson(json);
        } else {
          throw const FormatException('Invalid item format in medication list');
        }
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Medication>> getMedications({
    required String token,
  }) async {
    try {
      final medicationListJson =
          await medicationApiService.getMedications(token: token);

      return medicationListJson.map((json) {
        if (json is Map<String, dynamic>) {
          return Medication.fromJson(json);
        } else {
          throw const FormatException('Invalid item format in medication list');
        }
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Medication> getMedicationById({
    required String token,
    required int medicationId,
  }) async {
    try {
      final medicationJson = await medicationApiService.getMedicationById(
        token: token,
        medicationId: medicationId,
      );

      if (medicationJson is Map<String, dynamic>) {
        return Medication.fromJson(medicationJson);
      } else {
        throw const FormatException('Invalid item format in medication list');
      }
    } catch (e) {
      rethrow;
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
      await medicationApiService.addMedication(
        token: token,
        medicationBrandName: medicationBrandName,
        medicationGenericName: medicationGenericName,
        dosageForm: dosageForm,
        strength: strength,
        manufacturer: manufacturer,
        reorderPoint: reorderPoint,
        description: description,
        categoryId: categoryId,
      );
    } catch (e) {
      rethrow;
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
      await medicationApiService.updateMedication(
        token: token,
        medicationId: medicationId,
        medicationBrandName: medicationBrandName,
        medicationGenericName: medicationGenericName,
        dosageForm: dosageForm,
        strength: strength,
        manufacturer: manufacturer,
        reorderPoint: reorderPoint,
        description: description,
        categoryId: categoryId,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteMedication({
    required String token,
    required int medicationId,
  }) async {
    try {
      await medicationApiService.deleteMedication(
        token: token,
        medicationId: medicationId,
      );
    } catch (e) {
      rethrow;
    }
  }
}

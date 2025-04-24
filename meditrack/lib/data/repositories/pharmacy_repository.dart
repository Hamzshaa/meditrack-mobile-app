import 'package:image_picker/image_picker.dart';
import 'package:meditrack/data/services/pharmacy_api_service.dart';
import 'package:meditrack/models/pharmacy.dart';
import 'package:meditrack/models/pharmacy_overview_data.dart';

class PharmacyRepository {
  final PharmacyApiService _pharmacyApiService;

  PharmacyRepository(this._pharmacyApiService);

  Future<Pharmacy> getPharmacyById(
      {required int pharmacyId, required String token}) async {
    try {
      final jsonPharmacy = await _pharmacyApiService.getPharmacyById(
          pharmacyId: pharmacyId, token: token);

      return Pharmacy.fromJson(jsonPharmacy);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Pharmacy>> getAllPharmacies({required String token}) async {
    try {
      final pharmacyListJson =
          await _pharmacyApiService.getAllPharmacies(token: token);

      return pharmacyListJson
          .map((json) => Pharmacy.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Pharmacy> createPharmacy({
    required String managerFirstName,
    required String managerLastName,
    required String managerEmail,
    required String managerPhone,
    required String pharmacyName,
    required String address,
    required String latitude,
    required String longitude,
    String? pharmacyEmail,
    required String pharmacyPhone,
    List<XFile>? images,
    required String token,
  }) async {
    try {
      final createdPharmacyJson = await _pharmacyApiService.createPharmacy(
        managerFirstName: managerFirstName,
        managerLastName: managerLastName,
        managerEmail: managerEmail,
        managerPhone: managerPhone,
        pharmacyName: pharmacyName,
        address: address,
        latitude: latitude,
        longitude: longitude,
        pharmacyEmail: pharmacyEmail,
        pharmacyPhone: pharmacyPhone,
        images: images,
        token: token,
      );

      return Pharmacy.fromJson(createdPharmacyJson);
    } catch (e) {
      rethrow;
    }
  }

  Future<Pharmacy> updatePharmacy(
    int pharmacyId, {
    required String managerFirstName,
    required String managerLastName,
    required String managerEmail,
    required String managerPhone,
    required String pharmacyName,
    required String address,
    required String latitude,
    required String longitude,
    String? pharmacyEmail,
    required String pharmacyPhone,
    List<XFile>? images,
    required String token,
  }) async {
    try {
      final updatedPharmacyJson = await _pharmacyApiService.updatePharmacy(
        pharmacyId,
        managerFirstName: managerFirstName,
        managerLastName: managerLastName,
        managerEmail: managerEmail,
        managerPhone: managerPhone,
        pharmacyName: pharmacyName,
        address: address,
        latitude: latitude,
        longitude: longitude,
        pharmacyEmail: pharmacyEmail,
        pharmacyPhone: pharmacyPhone,
        images: images,
        token: token,
      );

      return Pharmacy.fromJson(updatedPharmacyJson);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePharmacy(
      {required int pharmacyId, required String token}) async {
    try {
      await _pharmacyApiService.deletePharmacy(
          pharmacyId: pharmacyId, token: token);
    } catch (e) {
      rethrow;
    }
  }

  Future<PharmacyOverviewData> fetchPharmacyOverview(
      {required String token}) async {
    try {
      final dynamic jsonData =
          await _pharmacyApiService.getPharmacyOverviewData(token: token);

      if (jsonData is! Map<String, dynamic>) {
        throw Exception(
            'API did not return a valid JSON object (Map). Got: ${jsonData?.runtimeType}');
      }

      final parsedData = PharmacyOverviewData.fromJson(jsonData);
      return parsedData;
    } catch (e) {
      rethrow;
    }
  }
}

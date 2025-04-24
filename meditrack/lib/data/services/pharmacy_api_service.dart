import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

class PharmacyApiService {
  final Dio dio;

  PharmacyApiService(this.dio);

  Future<Map<String, dynamic>> getPharmacyById({
    required int pharmacyId,
    required String token,
  }) async {
    final String url = '/pharmacies/$pharmacyId';
    try {
      final response = await dio.get(
        url,
        options: Options(headers: {"Authorization": token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        } else {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Expected a Map but received ${response.data.runtimeType}',
            type: DioExceptionType.badResponse,
          );
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load pharmacy: Status ${response.statusCode}',
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      String errorMsg =
          e.response?.data?['message'] ?? e.message ?? 'Network error';
      throw Exception('Failed to load pharmacy details. $errorMsg');
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  Future<List<dynamic>> getAllPharmacies({required String token}) async {
    const String url = '/pharmacies';
    try {
      final response = await dio.get(
        url,
        options: Options(headers: {"Authorization": token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is List) {
          return response.data as List<dynamic>;
        } else {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Expected a List but received ${response.data.runtimeType}',
            type: DioExceptionType.badResponse,
          );
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load pharmacies: Status ${response.statusCode}',
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      String errorMsg =
          e.response?.data?['message'] ?? e.message ?? 'Network error';
      throw Exception('Failed to load pharmacies list. $errorMsg');
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  Future<Map<String, dynamic>> createPharmacy({
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
    const String url = '/pharmacies';
    try {
      final Map<String, dynamic> dataFields = {
        'first_name': managerFirstName,
        'last_name': managerLastName,
        'manager_email': managerEmail,
        'manager_phone': managerPhone,
        'pharmacy_name': pharmacyName,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'pharmacy_phone': pharmacyPhone,
        if (pharmacyEmail != null && pharmacyEmail.isNotEmpty)
          'pharmacy_email': pharmacyEmail,
      };

      if (images != null && images.isNotEmpty) {
        List<MultipartFile> imageFiles = [];
        for (var imageFile in images) {
          final Uint8List fileBytes = await imageFile.readAsBytes();
          final String fileName = imageFile.name;
          final String? mimeType = imageFile.mimeType;

          imageFiles.add(MultipartFile.fromBytes(
            fileBytes,
            filename: fileName,
            contentType: mimeType != null ? MediaType.parse(mimeType) : null,
          ));
        }

        dataFields['pharmacy_image'] = imageFiles;
      }

      final formData = FormData.fromMap(dataFields);

      final response = await dio.post(
        url,
        options: Options(headers: {"Authorization": token}),
        data: formData,
      );

      if ((response.statusCode == 201 || response.statusCode == 200) &&
          response.data != null) {
        if (response.data is Map<String, dynamic> &&
            response.data['pharmacy'] is Map<String, dynamic>) {
          return response.data['pharmacy'] as Map<String, dynamic>;
        } else {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Unexpected response structure after creating pharmacy.',
            type: DioExceptionType.badResponse,
          );
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to create pharmacy: Status ${response.statusCode}',
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      String errorMsg =
          e.response?.data?['message'] ?? e.message ?? 'Unknown error';
      throw Exception('Failed to create pharmacy. $errorMsg');
    } catch (e) {
      if (e.toString().contains('MultipartFile is only supported')) {
        throw Exception(
            'File upload failed: Platform incompatibility. Please ensure you are running on a compatible platform or the web adaptation is correct.');
      }
      throw Exception('An unexpected error occurred during pharmacy creation.');
    }
  }

  Future<Map<String, dynamic>> updatePharmacy(
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
    final String url = '/pharmacies/$pharmacyId';
    try {
      final Map<String, dynamic> dataFields = {
        'first_name': managerFirstName,
        'last_name': managerLastName,
        'manager_email': managerEmail,
        'manager_phone': managerPhone,
        'pharmacy_name': pharmacyName,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'pharmacy_phone': pharmacyPhone,
        if (pharmacyEmail != null && pharmacyEmail.isNotEmpty)
          'pharmacy_email': pharmacyEmail,
        '_method': 'PUT',
      };

      if (images != null && images.isNotEmpty) {
        List<MultipartFile> imageFiles = [];
        for (var imageFile in images) {
          final Uint8List fileBytes = await imageFile.readAsBytes();

          final String fileName = imageFile.name;

          final String? mimeType = imageFile.mimeType;

          imageFiles.add(MultipartFile.fromBytes(
            fileBytes,
            filename: fileName,
            contentType: mimeType != null ? MediaType.parse(mimeType) : null,
          ));
        }

        dataFields['pharmacy_image'] = imageFiles;
      }

      final formData = FormData.fromMap(dataFields);

      final response = await dio.put(
        url,
        options: Options(headers: {"Authorization": token}),
        data: formData,
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map<String, dynamic> &&
            response.data['pharmacy'] is Map<String, dynamic>) {
          return response.data['pharmacy'] as Map<String, dynamic>;
        } else {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Unexpected response structure after updating pharmacy.',
            type: DioExceptionType.badResponse,
          );
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to update pharmacy: Status ${response.statusCode}',
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      String errorMsg =
          e.response?.data?['message'] ?? e.message ?? 'Unknown error';
      throw Exception('Failed to update pharmacy. $errorMsg');
    } catch (e) {
      if (e.toString().contains('MultipartFile is only supported')) {
        throw Exception(
            'File upload failed: Platform incompatibility. Please ensure you are running on a compatible platform or the web adaptation is correct.');
      }
      throw Exception('An unexpected error occurred during pharmacy update.');
    }
  }

  Future<void> deletePharmacy({
    required int pharmacyId,
    required String token,
  }) async {
    final String url = '/pharmacies/$pharmacyId';
    try {
      final response = await dio.delete(
        url,
        options: Options(headers: {"Authorization": token}),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to delete pharmacy: Status ${response.statusCode}',
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      String errorMsg =
          e.response?.data?['message'] ?? e.message ?? 'Network error';
      throw Exception('Failed to delete pharmacy. $errorMsg');
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  Future<Map<String, dynamic>> getPharmacyOverviewData(
      {required String token}) async {
    try {
      const String url = '/overview/pharmacy-dashboard';
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': token,
            'Accept': 'application/json',
          },
        ),
      );

      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception(
            'API returned unexpected data format for pharmacy overview.');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw Exception(
            'Unauthorized. Please check login credentials or permissions.');
      }
      throw Exception('Failed to load pharmacy overview data: ${e.message}');
    } catch (e) {
      throw Exception(
          'An unexpected error occurred while fetching pharmacy data.');
    }
  }
}

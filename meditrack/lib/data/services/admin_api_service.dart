import 'package:dio/dio.dart';

class AdminApiService {
  final Dio dio;

  static const String _adminOverviewEndpoint = '/overview/admin-dashboard';

  AdminApiService(this.dio);

  Future<Map<String, dynamic>> getAdminOverviewData(
      {required String token}) async {
    try {
      final response = await dio.get(
        _adminOverviewEndpoint,
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
            'API returned unexpected data format for admin overview.');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw Exception(
            'Unauthorized. Please check login credentials or permissions.');
      }
      throw Exception('Failed to load admin overview data: ${e.message}');
    } catch (e) {
      throw Exception(
          'An unexpected error occurred while fetching admin data.');
    }
  }
}

import 'package:meditrack/data/services/admin_api_service.dart';
import 'package:meditrack/models/admin_overview_data.dart';

class AdminRepository {
  final AdminApiService adminApiService;

  AdminRepository(this.adminApiService);

  Future<AdminOverviewData> fetchAdminOverview({required String token}) async {
    try {
      final dynamic jsonData =
          await adminApiService.getAdminOverviewData(token: token);

      if (jsonData is! Map<String, dynamic>) {
        throw Exception(
            'API did not return a valid JSON object (Map). Got: ${jsonData?.runtimeType}');
      }

      final parsedData = AdminOverviewData.fromJson(jsonData);
      return parsedData;
    } catch (e) {
      rethrow;
    }
  }
}

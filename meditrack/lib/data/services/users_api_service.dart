import 'package:dio/dio.dart';

class UsersApiService {
  final Dio dio;

  UsersApiService(this.dio);

  Future updateUserProfile({
    required int userId,
    required Map<String, dynamic> profileData,
    required String token,
  }) async {
    final String url = '/users/$userId';

    try {
      final response = await dio.put(url,
          options: Options(headers: {"Authorization": token}),
          data: profileData);

      if (response.statusCode == 200 && response.data != null) {
        return response.data["user"] as Map<String, dynamic>;
      } else {
        throw Exception('Failed to parse updated user data.');
      }
    } on DioException catch (e) {
      throw Exception(
          'Failed to update profile. ${e.response?.data['message'] ?? 'Please try again.'}');
    } catch (e) {
      throw Exception('An unexpected error occurred updating profile.');
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required int userId,
    required String token,
  }) async {
    final String url = '/users/$userId/password';

    try {
      final response = await dio
          .put(url, options: Options(headers: {"Authorization": token}), data: {
        'old_password': oldPassword,
        'new_password': newPassword,
      });

      if (response.statusCode != 200 && response.statusCode != 204) {
        final errorMessage =
            response.data is Map && response.data['message'] != null
                ? response.data['message']
                : 'Server returned status ${response.statusCode}';
        throw Exception('Password change failed. $errorMessage');
      }
    } on DioException catch (e) {
      throw Exception(
          'Failed to change password. ${e.response?.data['message'] ?? 'Please try again.'}');
    } catch (e) {
      throw Exception('An unexpected error occurred changing password.');
    }
  }
}

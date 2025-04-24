import 'package:dio/dio.dart';

class AuthApiService {
  final Dio dio;

  AuthApiService(this.dio);

  Future<String> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.data != null && response.data['token'] is String) {
        return response.data['token'];
      } else {
        throw Exception('Login response did not contain a valid token.');
      }
    } on DioException catch (e) {
      throw Exception(
          'Login failed. ${e.response?.data['message'] ?? 'Please check your credentials.'}');
    } catch (e) {
      throw Exception('An unexpected error occurred during login.');
    }
  }

  Future getCurrentUser(token) async {
    try {
      final response = await dio.get(
        '/auth/checkuser',
        options: Options(headers: {"Authorization": '$token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data["user"];
      } else {
        throw Exception('Failed to parse user data.');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode != 401) {
        throw Exception(
            'Failed to fetch user details. ${e.response?.data['message'] ?? 'Please try again.'}');
      }
      throw Exception('Authentication error fetching user details.');
    } catch (e) {
      throw Exception('An unexpected error occurred fetching user details.');
    }
  }
}

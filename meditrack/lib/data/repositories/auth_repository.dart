import 'package:meditrack/data/services/auth_api_service.dart';
import 'package:meditrack/models/user.dart';

class AuthRepository {
  final AuthApiService _authApiService;

  AuthRepository(this._authApiService);

  Future<String> login(String email, String password) async {
    return await _authApiService.login(email, password);
  }

  Future<User> getCurrentUser(String token) async {
    // return await _authApiService.getCurrentUser(token);
    final userjson = await _authApiService.getCurrentUser(token);
    return User.fromJson(userjson as Map<String, dynamic>);
  }
}

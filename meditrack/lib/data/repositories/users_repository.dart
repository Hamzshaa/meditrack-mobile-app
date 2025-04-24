import 'package:meditrack/data/services/users_api_service.dart';
import 'package:meditrack/models/user.dart';

class UsersRepository {
  final UsersApiService _usersApiService;

  UsersRepository(this._usersApiService);

  Future<User> updateUserProfile({
    required int userId,
    required Map<String, dynamic> profileData,
    required String token,
  }) async {
    final userJson = await _usersApiService.updateUserProfile(
      userId: userId,
      profileData: profileData,
      token: token,
    );

    return User.fromJson(userJson as Map<String, dynamic>);
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required int userId,
    required String token,
  }) async {
    await _usersApiService.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        userId: userId,
        token: token);
  }
}

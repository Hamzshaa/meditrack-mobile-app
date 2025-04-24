import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:meditrack/models/user.dart';
import 'package:meditrack/data/repositories/users_repository.dart';
import 'package:meditrack/data/services/users_api_service.dart';
import 'package:meditrack/providers/dio_provider.dart';
import 'package:meditrack/providers/auth_provider.dart';
import 'package:meditrack/data/repositories/auth_repository.dart';

part 'user_provider.g.dart';

@riverpod
UsersApiService usersApiService(UsersApiServiceRef ref) {
  final dio = ref.watch(dioProvider);
  return UsersApiService(dio);
}

@riverpod
UsersRepository usersRepository(UsersRepositoryRef ref) {
  final apiService = ref.watch(usersApiServiceProvider);
  return UsersRepository(apiService);
}

@riverpod
class CurrentUserNotifier extends _$CurrentUserNotifier {
  AuthRepository _getAuthRepo() => ref.read(authRepositoryProvider);
  AuthNotifier _getAuthNotifier() => ref.read(authNotifierProvider.notifier);

  @override
  Future<User?> build() async {
    final tokenAsyncValue = ref.watch(authNotifierProvider);
    final token = tokenAsyncValue.valueOrNull;

    if (token != null && token.isNotEmpty) {
      try {
        final user = await _getAuthRepo().getCurrentUser(token);
        return user;
        // ignore: unused_catch_stack
      } catch (e, st) {
        // Trigger logout in AuthNotifier if token is invalid
        Future(() => _getAuthNotifier().logout());
        return null;
      }
    } else {
      return null;
    }
  }

  void updateUserData(User updatedUser) {
    final currentData = state.valueOrNull;

    if (currentData != null && currentData.user_id == updatedUser.user_id) {
      state = AsyncValue.data(updatedUser);
    } else {}
  }

  Future<void> refreshUserData() async {
    state = const AsyncValue.loading();
    final token = _getAuthNotifier().getCurrentToken();

    if (token != null && token.isNotEmpty) {
      try {
        final user = await _getAuthRepo().getCurrentUser(token);
        state = AsyncValue.data(user);
      } catch (e, st) {
        state = AsyncValue.error(e, st);
      }
    } else {
      state = const AsyncValue.data(null);
    }
  }
}

@riverpod
class ProfileUpdate extends _$ProfileUpdate {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<bool> updateUserProfile({
    required Map<String, dynamic> profileData,
  }) async {
    state = const AsyncValue.loading();

    final usersRepo = ref.read(usersRepositoryProvider);
    final currentUserNotifier = ref.read(currentUserNotifierProvider.notifier);
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final currentUser = ref.read(currentUserNotifierProvider).valueOrNull;
    final token = authNotifier.getCurrentToken();

    if (currentUser == null || token == null) {
      const error = AuthException("User not logged in or token missing.");
      state = AsyncValue.error(error, StackTrace.current);
      return false;
    }
    final userId = currentUser.user_id;

    try {
      final User updatedUser = await usersRepo.updateUserProfile(
        userId: userId,
        profileData: profileData,
        token: token,
      );

      currentUserNotifier.updateUserData(updatedUser);

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

@riverpod
class PasswordChange extends _$PasswordChange {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    state = const AsyncValue.loading();

    // Dependencies
    final usersRepo = ref.read(usersRepositoryProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final currentUser = ref.read(currentUserNotifierProvider).valueOrNull;
    final token = authNotifier.getCurrentToken();

    if (currentUser == null || token == null) {
      const error = AuthException("User not logged in or token missing.");
      state = AsyncValue.error(error, StackTrace.current);
      return false;
    }
    final userId = currentUser.user_id;

    try {
      await usersRepo.changePassword(
        userId: userId,
        oldPassword: oldPassword,
        newPassword: newPassword,
        token: token,
      );
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

@riverpod
User? currentUser(CurrentUserRef ref) {
  return ref.watch(currentUserNotifierProvider).valueOrNull;
}

@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  return ref.watch(currentUserNotifierProvider).maybeWhen(
        data: (user) => user != null,
        orElse: () => false,
      );
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override
  String toString() => message;
}

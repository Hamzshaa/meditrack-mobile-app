import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meditrack/data/repositories/auth_repository.dart';
import 'package:meditrack/data/services/auth_api_service.dart';
import 'package:meditrack/providers/dio_provider.dart';

part 'auth_provider.g.dart';

@riverpod
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) async {
  return SharedPreferences.getInstance();
}

@riverpod
AuthApiService authApiService(AuthApiServiceRef ref) {
  final dio = ref.watch(dioProvider);
  return AuthApiService(dio);
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final apiService = ref.watch(authApiServiceProvider);
  return AuthRepository(apiService);
}

const String _tokenKey = 'auth_token';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  late SharedPreferences _prefs;
  late AuthRepository _authRepository;

  Future<void> _init() async {
    _prefs = await ref.watch(sharedPreferencesProvider.future);
    _authRepository = ref.watch(authRepositoryProvider);
  }

  @override
  Future<String?> build() async {
    await _init();
    final storedToken = _prefs.getString(_tokenKey);
    return storedToken;
  }

  Future<void> login(String email, String password) async {
    await _init();
    state = const AsyncValue.loading();
    try {
      final token = await _authRepository.login(email, password);
      await _prefs.setString(_tokenKey, token);
      state = AsyncValue.data(token);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    await _init();
    state = const AsyncValue.loading();
    try {
      await _prefs.remove(_tokenKey);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      await _prefs.remove(_tokenKey);
      state = const AsyncValue.data(null);
      state = AsyncValue.error(e, st);
    }
  }

  String? getCurrentToken() {
    try {
      return _prefs.getString(_tokenKey);
    } catch (e) {
      return null;
    }
  }
}

@riverpod
String? authToken(ref) {
  return ref.watch(authNotifierProvider).valueOrNull;
}

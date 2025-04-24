import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:meditrack/data/services/admin_api_service.dart';
import 'package:meditrack/data/repositories/admin_repository.dart';
import 'package:meditrack/models/admin_overview_data.dart';
import 'package:meditrack/providers/auth_provider.dart';
import 'package:meditrack/providers/dio_provider.dart';

part 'admin_provider.g.dart';

@riverpod
AdminApiService adminApiService(AdminApiServiceRef ref) {
  final dio = ref.watch(dioProvider);
  return AdminApiService(dio);
}

@riverpod
AdminRepository adminRepository(AdminRepositoryRef ref) {
  final service = ref.watch(adminApiServiceProvider);
  return AdminRepository(service);
}

String _getTokenOrThrow(Ref ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.maybeWhen(
    data: (token) {
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token is missing. Please log in.');
      }
      return token;
    },
    orElse: () =>
        throw Exception('Authentication state is not ready or invalid.'),
  );
}

@riverpod
Future<AdminOverviewData> adminOverview(AdminOverviewRef ref) async {
  ref.keepAlive();

  ref.watch(authNotifierProvider);

  final token = _getTokenOrThrow(ref);

  final repository = ref.watch(adminRepositoryProvider);

  try {
    final data = await repository.fetchAdminOverview(token: token);
    return data;
  } catch (e) {
    rethrow;
  }
}

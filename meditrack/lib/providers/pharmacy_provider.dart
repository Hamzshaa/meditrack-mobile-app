import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:meditrack/models/pharmacy_overview_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:meditrack/providers/auth_provider.dart';
import 'package:meditrack/data/services/pharmacy_api_service.dart';
import 'package:meditrack/data/repositories/pharmacy_repository.dart';
import 'package:meditrack/models/pharmacy.dart';
import 'dio_provider.dart';

part 'pharmacy_provider.g.dart';

@riverpod
PharmacyApiService pharmacyApiService(PharmacyApiServiceRef ref) {
  final dio = ref.watch(dioProvider);
  return PharmacyApiService(dio);
}

@riverpod
PharmacyRepository pharmacyRepository(PharmacyRepositoryRef ref) {
  final apiService = ref.watch(pharmacyApiServiceProvider);
  return PharmacyRepository(apiService);
}

String _getTokenOrThrow(ref) {
  final tokenAsyncValue = ref.watch(authNotifierProvider);

  if (tokenAsyncValue is AsyncData<String?>) {
    final String? token = tokenAsyncValue.value;
    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is null or empty. Please log in.');
    }
    return token;
  } else if (tokenAsyncValue is AsyncLoading) {
    throw Exception('Authentication token is still loading.');
  } else if (tokenAsyncValue is AsyncError) {
    throw Exception(
        'Error loading authentication token: ${tokenAsyncValue.error}');
  } else {
    throw Exception('Unexpected authentication state.');
  }
}

@riverpod
class PharmacyDetails extends _$PharmacyDetails {
  @override
  FutureOr<Pharmacy> build(int pharmacyId) async {
    final token = _getTokenOrThrow(ref);
    final pharmacyRepo = ref.watch(pharmacyRepositoryProvider);

    final link = ref.keepAlive();
    final timer = Timer(const Duration(seconds: 30), () {
      link.close();
    });
    ref.onDispose(() => timer.cancel());

    final pharmacy = await pharmacyRepo.getPharmacyById(
      pharmacyId: pharmacyId,
      token: token,
    );
    return pharmacy;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      ref.invalidateSelf();
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> delete() async {
    final token = _getTokenOrThrow(ref);
    final pharmacyRepo = ref.read(pharmacyRepositoryProvider);
    try {
      await pharmacyRepo.deletePharmacy(
        pharmacyId: pharmacyId,
        token: token,
      );
      ref.invalidate(pharmacyListProvider);
    } catch (e) {
      rethrow;
    }
  }
}

@riverpod
class PharmacyList extends _$PharmacyList {
  @override
  FutureOr<List<Pharmacy>> build() async {
    final token = _getTokenOrThrow(ref);
    final link = ref.keepAlive();
    final timer = Timer(const Duration(minutes: 1), () {
      link.close();
    });
    ref.onDispose(() => timer.cancel());
    final pharmacyRepo = ref.watch(pharmacyRepositoryProvider);
    return pharmacyRepo.getAllPharmacies(token: token);
  }

  Future<void> refreshList() async {
    state = const AsyncLoading();
    try {
      ref.invalidateSelf();
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> addPharmacy({
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
  }) async {
    final token = _getTokenOrThrow(ref);
    final pharmacyRepo = ref.read(pharmacyRepositoryProvider);
    try {
      await pharmacyRepo.createPharmacy(
        managerFirstName: managerFirstName,
        managerLastName: managerLastName,
        managerEmail: managerEmail,
        managerPhone: managerPhone,
        pharmacyName: pharmacyName,
        address: address,
        latitude: latitude,
        longitude: longitude,
        pharmacyEmail: pharmacyEmail,
        pharmacyPhone: pharmacyPhone,
        images: images,
        token: token,
      );
      ref.invalidateSelf();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePharmacy(
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
  }) async {
    final token = _getTokenOrThrow(ref);
    final pharmacyRepo = ref.read(pharmacyRepositoryProvider);
    try {
      await pharmacyRepo.updatePharmacy(
        pharmacyId,
        managerFirstName: managerFirstName,
        managerLastName: managerLastName,
        managerEmail: managerEmail,
        managerPhone: managerPhone,
        pharmacyName: pharmacyName,
        address: address,
        latitude: latitude,
        longitude: longitude,
        pharmacyEmail: pharmacyEmail,
        pharmacyPhone: pharmacyPhone,
        images: images,
        token: token,
      );
      ref.invalidateSelf();
      ref.invalidate(pharmacyDetailsProvider(pharmacyId));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePharmacy(int pharmacyId) async {
    final token = _getTokenOrThrow(ref);
    final pharmacyRepo = ref.read(pharmacyRepositoryProvider);
    try {
      await pharmacyRepo.deletePharmacy(
        pharmacyId: pharmacyId,
        token: token,
      );
      ref.invalidateSelf();
      ref.invalidate(pharmacyDetailsProvider(pharmacyId));
    } catch (e) {
      rethrow;
    }
  }
}

@riverpod
Future<PharmacyOverviewData> pharmacyOverview(PharmacyOverviewRef ref) async {
  ref.keepAlive();

  ref.watch(authNotifierProvider);

  final token = _getTokenOrThrow(ref);

  final repository = ref.watch(pharmacyRepositoryProvider);

  try {
    final data = await repository.fetchPharmacyOverview(token: token);
    return data;
  } catch (e) {
    rethrow;
  }
}

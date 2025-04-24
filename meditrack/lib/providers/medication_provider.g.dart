// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$medicationApiServiceHash() =>
    r'e2d916d4af2d15bbcaebb70d1200550cb81258c3';

/// See also [medicationApiService].
@ProviderFor(medicationApiService)
final medicationApiServiceProvider =
    AutoDisposeProvider<MedicationApiService>.internal(
  medicationApiService,
  name: r'medicationApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$medicationApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MedicationApiServiceRef = AutoDisposeProviderRef<MedicationApiService>;
String _$medicationRepositoryHash() =>
    r'7a003fa1812e7b85e7b1bdff1345150a56c688c2';

/// See also [medicationRepository].
@ProviderFor(medicationRepository)
final medicationRepositoryProvider =
    AutoDisposeProvider<MedicationRepository>.internal(
  medicationRepository,
  name: r'medicationRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$medicationRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MedicationRepositoryRef = AutoDisposeProviderRef<MedicationRepository>;
String _$medicationCategoryApiServiceHash() =>
    r'e9036d046a1d5c6a00842a27c28b0a67359365a6';

/// See also [medicationCategoryApiService].
@ProviderFor(medicationCategoryApiService)
final medicationCategoryApiServiceProvider =
    AutoDisposeProvider<MedicationCategoryApiService>.internal(
  medicationCategoryApiService,
  name: r'medicationCategoryApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$medicationCategoryApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MedicationCategoryApiServiceRef
    = AutoDisposeProviderRef<MedicationCategoryApiService>;
String _$medicationCategoryRepositoryHash() =>
    r'3503db074dddc979bac58dc501dd430f55b3115c';

/// See also [medicationCategoryRepository].
@ProviderFor(medicationCategoryRepository)
final medicationCategoryRepositoryProvider =
    AutoDisposeProvider<MedicationCategoryRepository>.internal(
  medicationCategoryRepository,
  name: r'medicationCategoryRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$medicationCategoryRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MedicationCategoryRepositoryRef
    = AutoDisposeProviderRef<MedicationCategoryRepository>;
String _$medicationsNotifierHash() =>
    r'e92b8b4be7f6e14973662e694f274a10cd70c1f9';

/// See also [MedicationsNotifier].
@ProviderFor(MedicationsNotifier)
final medicationsNotifierProvider = AutoDisposeAsyncNotifierProvider<
    MedicationsNotifier, List<Medication>>.internal(
  MedicationsNotifier.new,
  name: r'medicationsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$medicationsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MedicationsNotifier = AutoDisposeAsyncNotifier<List<Medication>>;
String _$pharmacyMedicationsNotifierHash() =>
    r'ccd93f363c88e4ef06118e851baf3faabfe2e276';

/// See also [PharmacyMedicationsNotifier].
@ProviderFor(PharmacyMedicationsNotifier)
final pharmacyMedicationsNotifierProvider = AutoDisposeAsyncNotifierProvider<
    PharmacyMedicationsNotifier, List<Medication>>.internal(
  PharmacyMedicationsNotifier.new,
  name: r'pharmacyMedicationsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pharmacyMedicationsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PharmacyMedicationsNotifier
    = AutoDisposeAsyncNotifier<List<Medication>>;
String _$medicationCategoriesNotifierHash() =>
    r'00589b987fbccf456822538b3124fe046b72430d';

/// See also [MedicationCategoriesNotifier].
@ProviderFor(MedicationCategoriesNotifier)
final medicationCategoriesNotifierProvider = AutoDisposeAsyncNotifierProvider<
    MedicationCategoriesNotifier, List<MedicationCategory>>.internal(
  MedicationCategoriesNotifier.new,
  name: r'medicationCategoriesNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$medicationCategoriesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MedicationCategoriesNotifier
    = AutoDisposeAsyncNotifier<List<MedicationCategory>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

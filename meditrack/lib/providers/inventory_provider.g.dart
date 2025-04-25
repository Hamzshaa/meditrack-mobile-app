// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$inventoryApiServiceHash() =>
    r'e91e2a673133643bd0c67d2e93bd25f94f290857';

/// See also [inventoryApiService].
@ProviderFor(inventoryApiService)
final inventoryApiServiceProvider =
    AutoDisposeProvider<InventoryApiService>.internal(
  inventoryApiService,
  name: r'inventoryApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inventoryApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef InventoryApiServiceRef = AutoDisposeProviderRef<InventoryApiService>;
String _$inventoryRepositoryHash() =>
    r'4bfa25439779ed0b2b95006c55cdef4c940edfb0';

/// See also [inventoryRepository].
@ProviderFor(inventoryRepository)
final inventoryRepositoryProvider =
    AutoDisposeProvider<InventoryRepository>.internal(
  inventoryRepository,
  name: r'inventoryRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inventoryRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef InventoryRepositoryRef = AutoDisposeProviderRef<InventoryRepository>;
String _$expiringMedicationsHash() =>
    r'c1384b6d34c45e474116150df035977a07104251';

/// See also [expiringMedications].
@ProviderFor(expiringMedications)
final expiringMedicationsProvider =
    AutoDisposeFutureProvider<ExpiringMedications>.internal(
  expiringMedications,
  name: r'expiringMedicationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expiringMedicationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ExpiringMedicationsRef
    = AutoDisposeFutureProviderRef<ExpiringMedications>;
String _$inventoryNotifierHash() => r'89d4004f472cd39baac4abcbd706463604177260';

/// See also [InventoryNotifier].
@ProviderFor(InventoryNotifier)
final inventoryNotifierProvider = AutoDisposeAsyncNotifierProvider<
    InventoryNotifier, List<Inventory>>.internal(
  InventoryNotifier.new,
  name: r'inventoryNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inventoryNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$InventoryNotifier = AutoDisposeAsyncNotifier<List<Inventory>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

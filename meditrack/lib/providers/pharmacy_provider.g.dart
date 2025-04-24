// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pharmacy_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pharmacyApiServiceHash() =>
    r'2ff029b2e3b24af8aeafc82868e1fbac7a784acc';

/// See also [pharmacyApiService].
@ProviderFor(pharmacyApiService)
final pharmacyApiServiceProvider =
    AutoDisposeProvider<PharmacyApiService>.internal(
  pharmacyApiService,
  name: r'pharmacyApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pharmacyApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PharmacyApiServiceRef = AutoDisposeProviderRef<PharmacyApiService>;
String _$pharmacyRepositoryHash() =>
    r'388d99812e92ce7577bf92b2a4c61cd386791248';

/// See also [pharmacyRepository].
@ProviderFor(pharmacyRepository)
final pharmacyRepositoryProvider =
    AutoDisposeProvider<PharmacyRepository>.internal(
  pharmacyRepository,
  name: r'pharmacyRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pharmacyRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PharmacyRepositoryRef = AutoDisposeProviderRef<PharmacyRepository>;
String _$pharmacyOverviewHash() => r'f545341ecc90ef6308d87d6bbce56054aa436e28';

/// See also [pharmacyOverview].
@ProviderFor(pharmacyOverview)
final pharmacyOverviewProvider =
    AutoDisposeFutureProvider<PharmacyOverviewData>.internal(
  pharmacyOverview,
  name: r'pharmacyOverviewProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pharmacyOverviewHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PharmacyOverviewRef
    = AutoDisposeFutureProviderRef<PharmacyOverviewData>;
String _$pharmacyDetailsHash() => r'f6160337807c0b80d63efd7c88de4173aefe979f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$PharmacyDetails
    extends BuildlessAutoDisposeAsyncNotifier<Pharmacy> {
  late final int pharmacyId;

  FutureOr<Pharmacy> build(
    int pharmacyId,
  );
}

/// See also [PharmacyDetails].
@ProviderFor(PharmacyDetails)
const pharmacyDetailsProvider = PharmacyDetailsFamily();

/// See also [PharmacyDetails].
class PharmacyDetailsFamily extends Family<AsyncValue<Pharmacy>> {
  /// See also [PharmacyDetails].
  const PharmacyDetailsFamily();

  /// See also [PharmacyDetails].
  PharmacyDetailsProvider call(
    int pharmacyId,
  ) {
    return PharmacyDetailsProvider(
      pharmacyId,
    );
  }

  @override
  PharmacyDetailsProvider getProviderOverride(
    covariant PharmacyDetailsProvider provider,
  ) {
    return call(
      provider.pharmacyId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'pharmacyDetailsProvider';
}

/// See also [PharmacyDetails].
class PharmacyDetailsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<PharmacyDetails, Pharmacy> {
  /// See also [PharmacyDetails].
  PharmacyDetailsProvider(
    int pharmacyId,
  ) : this._internal(
          () => PharmacyDetails()..pharmacyId = pharmacyId,
          from: pharmacyDetailsProvider,
          name: r'pharmacyDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pharmacyDetailsHash,
          dependencies: PharmacyDetailsFamily._dependencies,
          allTransitiveDependencies:
              PharmacyDetailsFamily._allTransitiveDependencies,
          pharmacyId: pharmacyId,
        );

  PharmacyDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pharmacyId,
  }) : super.internal();

  final int pharmacyId;

  @override
  FutureOr<Pharmacy> runNotifierBuild(
    covariant PharmacyDetails notifier,
  ) {
    return notifier.build(
      pharmacyId,
    );
  }

  @override
  Override overrideWith(PharmacyDetails Function() create) {
    return ProviderOverride(
      origin: this,
      override: PharmacyDetailsProvider._internal(
        () => create()..pharmacyId = pharmacyId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pharmacyId: pharmacyId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<PharmacyDetails, Pharmacy>
      createElement() {
    return _PharmacyDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PharmacyDetailsProvider && other.pharmacyId == pharmacyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pharmacyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PharmacyDetailsRef on AutoDisposeAsyncNotifierProviderRef<Pharmacy> {
  /// The parameter `pharmacyId` of this provider.
  int get pharmacyId;
}

class _PharmacyDetailsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PharmacyDetails, Pharmacy>
    with PharmacyDetailsRef {
  _PharmacyDetailsProviderElement(super.provider);

  @override
  int get pharmacyId => (origin as PharmacyDetailsProvider).pharmacyId;
}

String _$pharmacyListHash() => r'ff1e58773a6952ff866dd0a1c93975f0baf55946';

/// See also [PharmacyList].
@ProviderFor(PharmacyList)
final pharmacyListProvider =
    AutoDisposeAsyncNotifierProvider<PharmacyList, List<Pharmacy>>.internal(
  PharmacyList.new,
  name: r'pharmacyListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$pharmacyListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PharmacyList = AutoDisposeAsyncNotifier<List<Pharmacy>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

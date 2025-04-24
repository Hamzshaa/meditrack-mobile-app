// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$usersApiServiceHash() => r'87be1d217312bfc3213a001f63b67f6b7186bc5a';

/// See also [usersApiService].
@ProviderFor(usersApiService)
final usersApiServiceProvider = AutoDisposeProvider<UsersApiService>.internal(
  usersApiService,
  name: r'usersApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$usersApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UsersApiServiceRef = AutoDisposeProviderRef<UsersApiService>;
String _$usersRepositoryHash() => r'54ea9a7f41d7867563abf0abff71ec419e508167';

/// See also [usersRepository].
@ProviderFor(usersRepository)
final usersRepositoryProvider = AutoDisposeProvider<UsersRepository>.internal(
  usersRepository,
  name: r'usersRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$usersRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UsersRepositoryRef = AutoDisposeProviderRef<UsersRepository>;
String _$currentUserHash() => r'0ece0c16d5b5d5b403412932cfc21b9e8a755b53';

/// See also [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = AutoDisposeProvider<User?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentUserRef = AutoDisposeProviderRef<User?>;
String _$isAuthenticatedHash() => r'57f19878b8b0e4e85155e56d901cca21f56c4a77';

/// See also [isAuthenticated].
@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = AutoDisposeProvider<bool>.internal(
  isAuthenticated,
  name: r'isAuthenticatedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isAuthenticatedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsAuthenticatedRef = AutoDisposeProviderRef<bool>;
String _$currentUserNotifierHash() =>
    r'efd7e27a07c6c679749bba59c70ffa4a002f2679';

/// See also [CurrentUserNotifier].
@ProviderFor(CurrentUserNotifier)
final currentUserNotifierProvider =
    AutoDisposeAsyncNotifierProvider<CurrentUserNotifier, User?>.internal(
  CurrentUserNotifier.new,
  name: r'currentUserNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentUserNotifier = AutoDisposeAsyncNotifier<User?>;
String _$profileUpdateHash() => r'21b740796c7dad132eb78f9ab01edcf2ed03e1bf';

/// See also [ProfileUpdate].
@ProviderFor(ProfileUpdate)
final profileUpdateProvider =
    AutoDisposeAsyncNotifierProvider<ProfileUpdate, void>.internal(
  ProfileUpdate.new,
  name: r'profileUpdateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileUpdateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProfileUpdate = AutoDisposeAsyncNotifier<void>;
String _$passwordChangeHash() => r'b9fc69ed4385bac85cb41ae74dfa6aee1a89869d';

/// See also [PasswordChange].
@ProviderFor(PasswordChange)
final passwordChangeProvider =
    AutoDisposeAsyncNotifierProvider<PasswordChange, void>.internal(
  PasswordChange.new,
  name: r'passwordChangeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$passwordChangeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PasswordChange = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passing_args_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$passingArgsNotifierHash() =>
    r'c95fb6cad7afc1d3b99ca5ceaea44b673a86e912';

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

abstract class _$PassingArgsNotifier
    extends BuildlessAutoDisposeAsyncNotifier<CursorPagingData<SampleItem>> {
  late final String id;

  FutureOr<CursorPagingData<SampleItem>> build({
    required String id,
  });
}

/// See also [PassingArgsNotifier].
@ProviderFor(PassingArgsNotifier)
const passingArgsNotifierProvider = PassingArgsNotifierFamily();

/// See also [PassingArgsNotifier].
class PassingArgsNotifierFamily
    extends Family<AsyncValue<CursorPagingData<SampleItem>>> {
  /// See also [PassingArgsNotifier].
  const PassingArgsNotifierFamily();

  /// See also [PassingArgsNotifier].
  PassingArgsNotifierProvider call({
    required String id,
  }) {
    return PassingArgsNotifierProvider(
      id: id,
    );
  }

  @override
  PassingArgsNotifierProvider getProviderOverride(
    covariant PassingArgsNotifierProvider provider,
  ) {
    return call(
      id: provider.id,
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
  String? get name => r'passingArgsNotifierProvider';
}

/// See also [PassingArgsNotifier].
class PassingArgsNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    PassingArgsNotifier, CursorPagingData<SampleItem>> {
  /// See also [PassingArgsNotifier].
  PassingArgsNotifierProvider({
    required String id,
  }) : this._internal(
          () => PassingArgsNotifier()..id = id,
          from: passingArgsNotifierProvider,
          name: r'passingArgsNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$passingArgsNotifierHash,
          dependencies: PassingArgsNotifierFamily._dependencies,
          allTransitiveDependencies:
              PassingArgsNotifierFamily._allTransitiveDependencies,
          id: id,
        );

  PassingArgsNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  FutureOr<CursorPagingData<SampleItem>> runNotifierBuild(
    covariant PassingArgsNotifier notifier,
  ) {
    return notifier.build(
      id: id,
    );
  }

  @override
  Override overrideWith(PassingArgsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: PassingArgsNotifierProvider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<PassingArgsNotifier,
      CursorPagingData<SampleItem>> createElement() {
    return _PassingArgsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PassingArgsNotifierProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PassingArgsNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<CursorPagingData<SampleItem>> {
  /// The parameter `id` of this provider.
  String get id;
}

class _PassingArgsNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PassingArgsNotifier,
        CursorPagingData<SampleItem>> with PassingArgsNotifierRef {
  _PassingArgsNotifierProviderElement(super.provider);

  @override
  String get id => (origin as PassingArgsNotifierProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

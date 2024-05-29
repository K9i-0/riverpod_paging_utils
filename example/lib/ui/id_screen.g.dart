// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'id_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$idNotifierHash() => r'91c95ce77b18c23ad587a925e2df28905a89d96d';

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

abstract class _$IdNotifier
    extends BuildlessAutoDisposeAsyncNotifier<CursorPagingData<SampleItem>> {
  late final String id;

  FutureOr<CursorPagingData<SampleItem>> build({
    required String id,
  });
}

/// See also [IdNotifier].
@ProviderFor(IdNotifier)
const idNotifierProvider = IdNotifierFamily();

/// See also [IdNotifier].
class IdNotifierFamily
    extends Family<AsyncValue<CursorPagingData<SampleItem>>> {
  /// See also [IdNotifier].
  const IdNotifierFamily();

  /// See also [IdNotifier].
  IdNotifierProvider call({
    required String id,
  }) {
    return IdNotifierProvider(
      id: id,
    );
  }

  @override
  IdNotifierProvider getProviderOverride(
    covariant IdNotifierProvider provider,
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
  String? get name => r'idNotifierProvider';
}

/// See also [IdNotifier].
class IdNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    IdNotifier, CursorPagingData<SampleItem>> {
  /// See also [IdNotifier].
  IdNotifierProvider({
    required String id,
  }) : this._internal(
          () => IdNotifier()..id = id,
          from: idNotifierProvider,
          name: r'idNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$idNotifierHash,
          dependencies: IdNotifierFamily._dependencies,
          allTransitiveDependencies:
              IdNotifierFamily._allTransitiveDependencies,
          id: id,
        );

  IdNotifierProvider._internal(
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
    covariant IdNotifier notifier,
  ) {
    return notifier.build(
      id: id,
    );
  }

  @override
  Override overrideWith(IdNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: IdNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<IdNotifier,
      CursorPagingData<SampleItem>> createElement() {
    return _IdNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IdNotifierProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IdNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<CursorPagingData<SampleItem>> {
  /// The parameter `id` of this provider.
  String get id;
}

class _IdNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<IdNotifier,
        CursorPagingData<SampleItem>> with IdNotifierRef {
  _IdNotifierProviderElement(super.provider);

  @override
  String get id => (origin as IdNotifierProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

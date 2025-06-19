// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main3.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sampleNotifierHash() => r'baca230cf54023ea30431c4ab714753e6b53d155';

/// A Riverpod provider that mixes in [CursorPagingNotifierMixin].
/// This provider handles the pagination logic for fetching [SampleItem] data using cursor-based pagination.
///
/// Copied from [SampleNotifier].
@ProviderFor(SampleNotifier)
final sampleNotifierProvider = AutoDisposeAsyncNotifierProvider<SampleNotifier,
    CursorPagingData<SampleItem>>.internal(
  SampleNotifier.new,
  name: r'sampleNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sampleNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SampleNotifier
    = AutoDisposeAsyncNotifier<CursorPagingData<SampleItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

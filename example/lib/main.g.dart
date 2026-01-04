// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A Riverpod provider that mixes in [CursorPagingNotifierMixin].

@ProviderFor(SampleNotifier)
const sampleProvider = SampleNotifierProvider._();

/// A Riverpod provider that mixes in [CursorPagingNotifierMixin].
final class SampleNotifierProvider
    extends
        $AsyncNotifierProvider<SampleNotifier, CursorPagingData<SampleItem>> {
  /// A Riverpod provider that mixes in [CursorPagingNotifierMixin].
  const SampleNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sampleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sampleNotifierHash();

  @$internal
  @override
  SampleNotifier create() => SampleNotifier();
}

String _$sampleNotifierHash() => r'9b79e30e0e85e61102691f95a9d23525de90cb98';

/// A Riverpod provider that mixes in [CursorPagingNotifierMixin].

abstract class _$SampleNotifier
    extends $AsyncNotifier<CursorPagingData<SampleItem>> {
  FutureOr<CursorPagingData<SampleItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<CursorPagingData<SampleItem>>,
              CursorPagingData<SampleItem>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<CursorPagingData<SampleItem>>,
                CursorPagingData<SampleItem>
              >,
              AsyncValue<CursorPagingData<SampleItem>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

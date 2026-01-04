// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'second_page_error_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SecondPageErrorNotifier)
const secondPageErrorProvider = SecondPageErrorNotifierProvider._();

final class SecondPageErrorNotifierProvider
    extends
        $AsyncNotifierProvider<
          SecondPageErrorNotifier,
          CursorPagingData<SampleItem>
        > {
  const SecondPageErrorNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secondPageErrorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secondPageErrorNotifierHash();

  @$internal
  @override
  SecondPageErrorNotifier create() => SecondPageErrorNotifier();
}

String _$secondPageErrorNotifierHash() =>
    r'f199f9b3b68a0e3d073ec5418a03db3e034f7637';

abstract class _$SecondPageErrorNotifier
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

@ProviderFor(ShowSecondPageErrorNotifier)
const showSecondPageErrorProvider = ShowSecondPageErrorNotifierProvider._();

final class ShowSecondPageErrorNotifierProvider
    extends $NotifierProvider<ShowSecondPageErrorNotifier, bool> {
  const ShowSecondPageErrorNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showSecondPageErrorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showSecondPageErrorNotifierHash();

  @$internal
  @override
  ShowSecondPageErrorNotifier create() => ShowSecondPageErrorNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showSecondPageErrorNotifierHash() =>
    r'c627f562d49c93f1604d142c6526cd822074f7f2';

abstract class _$ShowSecondPageErrorNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

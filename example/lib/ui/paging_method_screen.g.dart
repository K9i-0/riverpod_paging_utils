// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paging_method_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PageBasedNotifier)
const pageBasedProvider = PageBasedNotifierProvider._();

final class PageBasedNotifierProvider
    extends
        $AsyncNotifierProvider<PageBasedNotifier, PagePagingData<SampleItem>> {
  const PageBasedNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pageBasedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pageBasedNotifierHash();

  @$internal
  @override
  PageBasedNotifier create() => PageBasedNotifier();
}

String _$pageBasedNotifierHash() => r'2ba947fde488589855620edc7535d77dc69f067e';

abstract class _$PageBasedNotifier
    extends $AsyncNotifier<PagePagingData<SampleItem>> {
  FutureOr<PagePagingData<SampleItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PagePagingData<SampleItem>>,
              PagePagingData<SampleItem>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PagePagingData<SampleItem>>,
                PagePagingData<SampleItem>
              >,
              AsyncValue<PagePagingData<SampleItem>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(OffsetBasedNotifier)
const offsetBasedProvider = OffsetBasedNotifierProvider._();

final class OffsetBasedNotifierProvider
    extends
        $AsyncNotifierProvider<
          OffsetBasedNotifier,
          OffsetPagingData<SampleItem>
        > {
  const OffsetBasedNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offsetBasedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offsetBasedNotifierHash();

  @$internal
  @override
  OffsetBasedNotifier create() => OffsetBasedNotifier();
}

String _$offsetBasedNotifierHash() =>
    r'd463c8f5c0c658f46a5459fb2a560587ff83ee1f';

abstract class _$OffsetBasedNotifier
    extends $AsyncNotifier<OffsetPagingData<SampleItem>> {
  FutureOr<OffsetPagingData<SampleItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<OffsetPagingData<SampleItem>>,
              OffsetPagingData<SampleItem>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<OffsetPagingData<SampleItem>>,
                OffsetPagingData<SampleItem>
              >,
              AsyncValue<OffsetPagingData<SampleItem>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(CursorBasedNotifier)
const cursorBasedProvider = CursorBasedNotifierProvider._();

final class CursorBasedNotifierProvider
    extends
        $AsyncNotifierProvider<
          CursorBasedNotifier,
          CursorPagingData<SampleItem>
        > {
  const CursorBasedNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cursorBasedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cursorBasedNotifierHash();

  @$internal
  @override
  CursorBasedNotifier create() => CursorBasedNotifier();
}

String _$cursorBasedNotifierHash() =>
    r'558358c8a67bff5d73e5e809fab838b148c6bc35';

abstract class _$CursorBasedNotifier
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

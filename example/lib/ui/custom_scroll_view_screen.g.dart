// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_scroll_view_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CustomScrollViewNotifier)
const customScrollViewProvider = CustomScrollViewNotifierProvider._();

final class CustomScrollViewNotifierProvider
    extends
        $AsyncNotifierProvider<
          CustomScrollViewNotifier,
          CursorPagingData<SampleItem>
        > {
  const CustomScrollViewNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customScrollViewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customScrollViewNotifierHash();

  @$internal
  @override
  CustomScrollViewNotifier create() => CustomScrollViewNotifier();
}

String _$customScrollViewNotifierHash() =>
    r'8ccf00d745094b4519b1e5c891e35c4e83f067d6';

abstract class _$CustomScrollViewNotifier
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

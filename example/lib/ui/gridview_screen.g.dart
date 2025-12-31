// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gridview_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GridViewNotifier)
const gridViewProvider = GridViewNotifierProvider._();

final class GridViewNotifierProvider
    extends
        $AsyncNotifierProvider<GridViewNotifier, CursorPagingData<SampleItem>> {
  const GridViewNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gridViewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gridViewNotifierHash();

  @$internal
  @override
  GridViewNotifier create() => GridViewNotifier();
}

String _$gridViewNotifierHash() => r'625b0c14c75c9d52742552b037ab5cfd4bbf76a8';

abstract class _$GridViewNotifier
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

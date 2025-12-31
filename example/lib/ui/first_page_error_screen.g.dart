// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'first_page_error_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FirstPageErrorNotifier)
const firstPageErrorProvider = FirstPageErrorNotifierProvider._();

final class FirstPageErrorNotifierProvider
    extends
        $AsyncNotifierProvider<
          FirstPageErrorNotifier,
          CursorPagingData<SampleItem>
        > {
  const FirstPageErrorNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firstPageErrorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firstPageErrorNotifierHash();

  @$internal
  @override
  FirstPageErrorNotifier create() => FirstPageErrorNotifier();
}

String _$firstPageErrorNotifierHash() =>
    r'fc07f03e251eb290c695881aeb33861af41a90bd';

abstract class _$FirstPageErrorNotifier
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

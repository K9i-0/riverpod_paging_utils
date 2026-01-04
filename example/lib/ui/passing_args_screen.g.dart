// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passing_args_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PassingArgsNotifier)
const passingArgsProvider = PassingArgsNotifierFamily._();

final class PassingArgsNotifierProvider
    extends
        $AsyncNotifierProvider<
          PassingArgsNotifier,
          CursorPagingData<SampleItem>
        > {
  const PassingArgsNotifierProvider._({
    required PassingArgsNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'passingArgsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$passingArgsNotifierHash();

  @override
  String toString() {
    return r'passingArgsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PassingArgsNotifier create() => PassingArgsNotifier();

  @override
  bool operator ==(Object other) {
    return other is PassingArgsNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$passingArgsNotifierHash() =>
    r'c95fb6cad7afc1d3b99ca5ceaea44b673a86e912';

final class PassingArgsNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          PassingArgsNotifier,
          AsyncValue<CursorPagingData<SampleItem>>,
          CursorPagingData<SampleItem>,
          FutureOr<CursorPagingData<SampleItem>>,
          String
        > {
  const PassingArgsNotifierFamily._()
    : super(
        retry: null,
        name: r'passingArgsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PassingArgsNotifierProvider call({required String id}) =>
      PassingArgsNotifierProvider._(argument: id, from: this);

  @override
  String toString() => r'passingArgsProvider';
}

abstract class _$PassingArgsNotifier
    extends $AsyncNotifier<CursorPagingData<SampleItem>> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  FutureOr<CursorPagingData<SampleItem>> build({required String id});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(id: _$args);
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sampleRepository)
const sampleRepositoryProvider = SampleRepositoryProvider._();

final class SampleRepositoryProvider
    extends
        $FunctionalProvider<
          SampleRepository,
          SampleRepository,
          SampleRepository
        >
    with $Provider<SampleRepository> {
  const SampleRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sampleRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sampleRepositoryHash();

  @$internal
  @override
  $ProviderElement<SampleRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SampleRepository create(Ref ref) {
    return sampleRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SampleRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SampleRepository>(value),
    );
  }
}

String _$sampleRepositoryHash() => r'14de127af2aa55d37c7a84a4dc4796e5afb7fd7f';

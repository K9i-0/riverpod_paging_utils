import 'package:freezed_annotation/freezed_annotation.dart';

part 'sample_item.freezed.dart';

@freezed
abstract class SampleItem with _$SampleItem {
  const factory SampleItem({
    required String id,
    required String name,
  }) = _SampleItem;
}

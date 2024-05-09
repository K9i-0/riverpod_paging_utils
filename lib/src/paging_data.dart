import 'package:freezed_annotation/freezed_annotation.dart';

part 'paging_data.freezed.dart';

abstract class PagingData<T> {
  List<T> get items;
  bool get hasMore;
}

@freezed
class PageBasedPagingData<T>
    with _$PageBasedPagingData<T>
    implements PagingData<T> {
  const factory PageBasedPagingData({
    required List<T> items,
    required bool hasMore,
    required int page,
  }) = _PageBasedPagingData;
}

@freezed
class OffsetBasedPagingData<T>
    with _$OffsetBasedPagingData<T>
    implements PagingData<T> {
  const factory OffsetBasedPagingData({
    required List<T> items,
    required bool hasMore,
    required int offset,
  }) = _OffsetBasedPagingData;
}

@freezed
class CursorBasedPagingData<T>
    with _$CursorBasedPagingData<T>
    implements PagingData<T> {
  const factory CursorBasedPagingData({
    required List<T> items,
    required bool hasMore,
    required String? nextCursor,
  }) = _CursorBasedPagingData;
}

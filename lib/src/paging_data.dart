import 'package:freezed_annotation/freezed_annotation.dart';

part 'paging_data.freezed.dart';

abstract class PagingData<T> {
  List<T> get items;
  bool get hasMore;
}

@freezed
class PagePagingData<T> with _$PagePagingData<T> implements PagingData<T> {
  const factory PagePagingData({
    required List<T> items,
    required bool hasMore,
    required int page,
  }) = _PagePagingData;
}

@freezed
class OffsetPagingData<T> with _$OffsetPagingData<T> implements PagingData<T> {
  const factory OffsetPagingData({
    required List<T> items,
    required bool hasMore,
    required int offset,
  }) = _OffsetPagingData;
}

@freezed
class CursorPagingData<T> with _$CursorPagingData<T> implements PagingData<T> {
  const factory CursorPagingData({
    required List<T> items,
    required bool hasMore,
    required String? nextCursor,
  }) = _CursorPagingData;
}

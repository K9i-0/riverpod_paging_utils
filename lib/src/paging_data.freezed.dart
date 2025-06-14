// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paging_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PagePagingData<T> {
  List<T> get items;
  bool get hasMore;
  int get page;

  /// Create a copy of PagePagingData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PagePagingDataCopyWith<T, PagePagingData<T>> get copyWith =>
      _$PagePagingDataCopyWithImpl<T, PagePagingData<T>>(
          this as PagePagingData<T>, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PagePagingData<T> &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.page, page) || other.page == page));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(items), hasMore, page);

  @override
  String toString() {
    return 'PagePagingData<$T>(items: $items, hasMore: $hasMore, page: $page)';
  }
}

/// @nodoc
abstract mixin class $PagePagingDataCopyWith<T, $Res> {
  factory $PagePagingDataCopyWith(
          PagePagingData<T> value, $Res Function(PagePagingData<T>) _then) =
      _$PagePagingDataCopyWithImpl;
  @useResult
  $Res call({List<T> items, bool hasMore, int page});
}

/// @nodoc
class _$PagePagingDataCopyWithImpl<T, $Res>
    implements $PagePagingDataCopyWith<T, $Res> {
  _$PagePagingDataCopyWithImpl(this._self, this._then);

  final PagePagingData<T> _self;
  final $Res Function(PagePagingData<T>) _then;

  /// Create a copy of PagePagingData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? hasMore = null,
    Object? page = null,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _PagePagingData<T> extends PagePagingData<T> {
  const _PagePagingData(
      {required final List<T> items, required this.hasMore, required this.page})
      : _items = items,
        super._();

  final List<T> _items;
  @override
  List<T> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final bool hasMore;
  @override
  final int page;

  /// Create a copy of PagePagingData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PagePagingDataCopyWith<T, _PagePagingData<T>> get copyWith =>
      __$PagePagingDataCopyWithImpl<T, _PagePagingData<T>>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PagePagingData<T> &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.page, page) || other.page == page));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), hasMore, page);

  @override
  String toString() {
    return 'PagePagingData<$T>(items: $items, hasMore: $hasMore, page: $page)';
  }
}

/// @nodoc
abstract mixin class _$PagePagingDataCopyWith<T, $Res>
    implements $PagePagingDataCopyWith<T, $Res> {
  factory _$PagePagingDataCopyWith(
          _PagePagingData<T> value, $Res Function(_PagePagingData<T>) _then) =
      __$PagePagingDataCopyWithImpl;
  @override
  @useResult
  $Res call({List<T> items, bool hasMore, int page});
}

/// @nodoc
class __$PagePagingDataCopyWithImpl<T, $Res>
    implements _$PagePagingDataCopyWith<T, $Res> {
  __$PagePagingDataCopyWithImpl(this._self, this._then);

  final _PagePagingData<T> _self;
  final $Res Function(_PagePagingData<T>) _then;

  /// Create a copy of PagePagingData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? hasMore = null,
    Object? page = null,
  }) {
    return _then(_PagePagingData<T>(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$OffsetPagingData<T> {
  List<T> get items;
  bool get hasMore;
  int get offset;

  /// Create a copy of OffsetPagingData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OffsetPagingDataCopyWith<T, OffsetPagingData<T>> get copyWith =>
      _$OffsetPagingDataCopyWithImpl<T, OffsetPagingData<T>>(
          this as OffsetPagingData<T>, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OffsetPagingData<T> &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.offset, offset) || other.offset == offset));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(items), hasMore, offset);

  @override
  String toString() {
    return 'OffsetPagingData<$T>(items: $items, hasMore: $hasMore, offset: $offset)';
  }
}

/// @nodoc
abstract mixin class $OffsetPagingDataCopyWith<T, $Res> {
  factory $OffsetPagingDataCopyWith(
          OffsetPagingData<T> value, $Res Function(OffsetPagingData<T>) _then) =
      _$OffsetPagingDataCopyWithImpl;
  @useResult
  $Res call({List<T> items, bool hasMore, int offset});
}

/// @nodoc
class _$OffsetPagingDataCopyWithImpl<T, $Res>
    implements $OffsetPagingDataCopyWith<T, $Res> {
  _$OffsetPagingDataCopyWithImpl(this._self, this._then);

  final OffsetPagingData<T> _self;
  final $Res Function(OffsetPagingData<T>) _then;

  /// Create a copy of OffsetPagingData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? hasMore = null,
    Object? offset = null,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      offset: null == offset
          ? _self.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _OffsetPagingData<T> extends OffsetPagingData<T> {
  const _OffsetPagingData(
      {required final List<T> items,
      required this.hasMore,
      required this.offset})
      : _items = items,
        super._();

  final List<T> _items;
  @override
  List<T> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final bool hasMore;
  @override
  final int offset;

  /// Create a copy of OffsetPagingData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OffsetPagingDataCopyWith<T, _OffsetPagingData<T>> get copyWith =>
      __$OffsetPagingDataCopyWithImpl<T, _OffsetPagingData<T>>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OffsetPagingData<T> &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.offset, offset) || other.offset == offset));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_items), hasMore, offset);

  @override
  String toString() {
    return 'OffsetPagingData<$T>(items: $items, hasMore: $hasMore, offset: $offset)';
  }
}

/// @nodoc
abstract mixin class _$OffsetPagingDataCopyWith<T, $Res>
    implements $OffsetPagingDataCopyWith<T, $Res> {
  factory _$OffsetPagingDataCopyWith(_OffsetPagingData<T> value,
          $Res Function(_OffsetPagingData<T>) _then) =
      __$OffsetPagingDataCopyWithImpl;
  @override
  @useResult
  $Res call({List<T> items, bool hasMore, int offset});
}

/// @nodoc
class __$OffsetPagingDataCopyWithImpl<T, $Res>
    implements _$OffsetPagingDataCopyWith<T, $Res> {
  __$OffsetPagingDataCopyWithImpl(this._self, this._then);

  final _OffsetPagingData<T> _self;
  final $Res Function(_OffsetPagingData<T>) _then;

  /// Create a copy of OffsetPagingData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? hasMore = null,
    Object? offset = null,
  }) {
    return _then(_OffsetPagingData<T>(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      offset: null == offset
          ? _self.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$CursorPagingData<T> {
  List<T> get items;
  bool get hasMore;
  String? get nextCursor;

  /// Create a copy of CursorPagingData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CursorPagingDataCopyWith<T, CursorPagingData<T>> get copyWith =>
      _$CursorPagingDataCopyWithImpl<T, CursorPagingData<T>>(
          this as CursorPagingData<T>, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CursorPagingData<T> &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(items), hasMore, nextCursor);

  @override
  String toString() {
    return 'CursorPagingData<$T>(items: $items, hasMore: $hasMore, nextCursor: $nextCursor)';
  }
}

/// @nodoc
abstract mixin class $CursorPagingDataCopyWith<T, $Res> {
  factory $CursorPagingDataCopyWith(
          CursorPagingData<T> value, $Res Function(CursorPagingData<T>) _then) =
      _$CursorPagingDataCopyWithImpl;
  @useResult
  $Res call({List<T> items, bool hasMore, String? nextCursor});
}

/// @nodoc
class _$CursorPagingDataCopyWithImpl<T, $Res>
    implements $CursorPagingDataCopyWith<T, $Res> {
  _$CursorPagingDataCopyWithImpl(this._self, this._then);

  final CursorPagingData<T> _self;
  final $Res Function(CursorPagingData<T>) _then;

  /// Create a copy of CursorPagingData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? hasMore = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _CursorPagingData<T> extends CursorPagingData<T> {
  const _CursorPagingData(
      {required final List<T> items,
      required this.hasMore,
      required this.nextCursor})
      : _items = items,
        super._();

  final List<T> _items;
  @override
  List<T> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final bool hasMore;
  @override
  final String? nextCursor;

  /// Create a copy of CursorPagingData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CursorPagingDataCopyWith<T, _CursorPagingData<T>> get copyWith =>
      __$CursorPagingDataCopyWithImpl<T, _CursorPagingData<T>>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CursorPagingData<T> &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_items), hasMore, nextCursor);

  @override
  String toString() {
    return 'CursorPagingData<$T>(items: $items, hasMore: $hasMore, nextCursor: $nextCursor)';
  }
}

/// @nodoc
abstract mixin class _$CursorPagingDataCopyWith<T, $Res>
    implements $CursorPagingDataCopyWith<T, $Res> {
  factory _$CursorPagingDataCopyWith(_CursorPagingData<T> value,
          $Res Function(_CursorPagingData<T>) _then) =
      __$CursorPagingDataCopyWithImpl;
  @override
  @useResult
  $Res call({List<T> items, bool hasMore, String? nextCursor});
}

/// @nodoc
class __$CursorPagingDataCopyWithImpl<T, $Res>
    implements _$CursorPagingDataCopyWith<T, $Res> {
  __$CursorPagingDataCopyWithImpl(this._self, this._then);

  final _CursorPagingData<T> _self;
  final $Res Function(_CursorPagingData<T>) _then;

  /// Create a copy of CursorPagingData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? hasMore = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_CursorPagingData<T>(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on

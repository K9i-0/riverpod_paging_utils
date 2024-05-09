// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paging_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PageBasedPagingData<T> {
  List<T> get items => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PageBasedPagingDataCopyWith<T, PageBasedPagingData<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PageBasedPagingDataCopyWith<T, $Res> {
  factory $PageBasedPagingDataCopyWith(PageBasedPagingData<T> value,
          $Res Function(PageBasedPagingData<T>) then) =
      _$PageBasedPagingDataCopyWithImpl<T, $Res, PageBasedPagingData<T>>;
  @useResult
  $Res call({List<T> items, bool hasMore, int page});
}

/// @nodoc
class _$PageBasedPagingDataCopyWithImpl<T, $Res,
        $Val extends PageBasedPagingData<T>>
    implements $PageBasedPagingDataCopyWith<T, $Res> {
  _$PageBasedPagingDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? hasMore = null,
    Object? page = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PageBasedPagingDataImplCopyWith<T, $Res>
    implements $PageBasedPagingDataCopyWith<T, $Res> {
  factory _$$PageBasedPagingDataImplCopyWith(_$PageBasedPagingDataImpl<T> value,
          $Res Function(_$PageBasedPagingDataImpl<T>) then) =
      __$$PageBasedPagingDataImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({List<T> items, bool hasMore, int page});
}

/// @nodoc
class __$$PageBasedPagingDataImplCopyWithImpl<T, $Res>
    extends _$PageBasedPagingDataCopyWithImpl<T, $Res,
        _$PageBasedPagingDataImpl<T>>
    implements _$$PageBasedPagingDataImplCopyWith<T, $Res> {
  __$$PageBasedPagingDataImplCopyWithImpl(_$PageBasedPagingDataImpl<T> _value,
      $Res Function(_$PageBasedPagingDataImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? hasMore = null,
    Object? page = null,
  }) {
    return _then(_$PageBasedPagingDataImpl<T>(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$PageBasedPagingDataImpl<T> implements _PageBasedPagingData<T> {
  const _$PageBasedPagingDataImpl(
      {required final List<T> items, required this.hasMore, required this.page})
      : _items = items;

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

  @override
  String toString() {
    return 'PageBasedPagingData<$T>(items: $items, hasMore: $hasMore, page: $page)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageBasedPagingDataImpl<T> &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.page, page) || other.page == page));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), hasMore, page);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PageBasedPagingDataImplCopyWith<T, _$PageBasedPagingDataImpl<T>>
      get copyWith => __$$PageBasedPagingDataImplCopyWithImpl<T,
          _$PageBasedPagingDataImpl<T>>(this, _$identity);
}

abstract class _PageBasedPagingData<T> implements PageBasedPagingData<T> {
  const factory _PageBasedPagingData(
      {required final List<T> items,
      required final bool hasMore,
      required final int page}) = _$PageBasedPagingDataImpl<T>;

  @override
  List<T> get items;
  @override
  bool get hasMore;
  @override
  int get page;
  @override
  @JsonKey(ignore: true)
  _$$PageBasedPagingDataImplCopyWith<T, _$PageBasedPagingDataImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OffsetBasedPagingData<T> {
  List<T> get items => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  int get offset => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OffsetBasedPagingDataCopyWith<T, OffsetBasedPagingData<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OffsetBasedPagingDataCopyWith<T, $Res> {
  factory $OffsetBasedPagingDataCopyWith(OffsetBasedPagingData<T> value,
          $Res Function(OffsetBasedPagingData<T>) then) =
      _$OffsetBasedPagingDataCopyWithImpl<T, $Res, OffsetBasedPagingData<T>>;
  @useResult
  $Res call({List<T> items, bool hasMore, int offset});
}

/// @nodoc
class _$OffsetBasedPagingDataCopyWithImpl<T, $Res,
        $Val extends OffsetBasedPagingData<T>>
    implements $OffsetBasedPagingDataCopyWith<T, $Res> {
  _$OffsetBasedPagingDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? hasMore = null,
    Object? offset = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OffsetBasedPagingDataImplCopyWith<T, $Res>
    implements $OffsetBasedPagingDataCopyWith<T, $Res> {
  factory _$$OffsetBasedPagingDataImplCopyWith(
          _$OffsetBasedPagingDataImpl<T> value,
          $Res Function(_$OffsetBasedPagingDataImpl<T>) then) =
      __$$OffsetBasedPagingDataImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({List<T> items, bool hasMore, int offset});
}

/// @nodoc
class __$$OffsetBasedPagingDataImplCopyWithImpl<T, $Res>
    extends _$OffsetBasedPagingDataCopyWithImpl<T, $Res,
        _$OffsetBasedPagingDataImpl<T>>
    implements _$$OffsetBasedPagingDataImplCopyWith<T, $Res> {
  __$$OffsetBasedPagingDataImplCopyWithImpl(
      _$OffsetBasedPagingDataImpl<T> _value,
      $Res Function(_$OffsetBasedPagingDataImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? hasMore = null,
    Object? offset = null,
  }) {
    return _then(_$OffsetBasedPagingDataImpl<T>(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$OffsetBasedPagingDataImpl<T> implements _OffsetBasedPagingData<T> {
  const _$OffsetBasedPagingDataImpl(
      {required final List<T> items,
      required this.hasMore,
      required this.offset})
      : _items = items;

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

  @override
  String toString() {
    return 'OffsetBasedPagingData<$T>(items: $items, hasMore: $hasMore, offset: $offset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OffsetBasedPagingDataImpl<T> &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.offset, offset) || other.offset == offset));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_items), hasMore, offset);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OffsetBasedPagingDataImplCopyWith<T, _$OffsetBasedPagingDataImpl<T>>
      get copyWith => __$$OffsetBasedPagingDataImplCopyWithImpl<T,
          _$OffsetBasedPagingDataImpl<T>>(this, _$identity);
}

abstract class _OffsetBasedPagingData<T> implements OffsetBasedPagingData<T> {
  const factory _OffsetBasedPagingData(
      {required final List<T> items,
      required final bool hasMore,
      required final int offset}) = _$OffsetBasedPagingDataImpl<T>;

  @override
  List<T> get items;
  @override
  bool get hasMore;
  @override
  int get offset;
  @override
  @JsonKey(ignore: true)
  _$$OffsetBasedPagingDataImplCopyWith<T, _$OffsetBasedPagingDataImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CursorBasedPagingData<T> {
  List<T> get items => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  String? get nextCursor => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CursorBasedPagingDataCopyWith<T, CursorBasedPagingData<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CursorBasedPagingDataCopyWith<T, $Res> {
  factory $CursorBasedPagingDataCopyWith(CursorBasedPagingData<T> value,
          $Res Function(CursorBasedPagingData<T>) then) =
      _$CursorBasedPagingDataCopyWithImpl<T, $Res, CursorBasedPagingData<T>>;
  @useResult
  $Res call({List<T> items, bool hasMore, String? nextCursor});
}

/// @nodoc
class _$CursorBasedPagingDataCopyWithImpl<T, $Res,
        $Val extends CursorBasedPagingData<T>>
    implements $CursorBasedPagingDataCopyWith<T, $Res> {
  _$CursorBasedPagingDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? hasMore = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CursorBasedPagingDataImplCopyWith<T, $Res>
    implements $CursorBasedPagingDataCopyWith<T, $Res> {
  factory _$$CursorBasedPagingDataImplCopyWith(
          _$CursorBasedPagingDataImpl<T> value,
          $Res Function(_$CursorBasedPagingDataImpl<T>) then) =
      __$$CursorBasedPagingDataImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({List<T> items, bool hasMore, String? nextCursor});
}

/// @nodoc
class __$$CursorBasedPagingDataImplCopyWithImpl<T, $Res>
    extends _$CursorBasedPagingDataCopyWithImpl<T, $Res,
        _$CursorBasedPagingDataImpl<T>>
    implements _$$CursorBasedPagingDataImplCopyWith<T, $Res> {
  __$$CursorBasedPagingDataImplCopyWithImpl(
      _$CursorBasedPagingDataImpl<T> _value,
      $Res Function(_$CursorBasedPagingDataImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? hasMore = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_$CursorBasedPagingDataImpl<T>(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CursorBasedPagingDataImpl<T> implements _CursorBasedPagingData<T> {
  const _$CursorBasedPagingDataImpl(
      {required final List<T> items,
      required this.hasMore,
      required this.nextCursor})
      : _items = items;

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

  @override
  String toString() {
    return 'CursorBasedPagingData<$T>(items: $items, hasMore: $hasMore, nextCursor: $nextCursor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CursorBasedPagingDataImpl<T> &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_items), hasMore, nextCursor);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CursorBasedPagingDataImplCopyWith<T, _$CursorBasedPagingDataImpl<T>>
      get copyWith => __$$CursorBasedPagingDataImplCopyWithImpl<T,
          _$CursorBasedPagingDataImpl<T>>(this, _$identity);
}

abstract class _CursorBasedPagingData<T> implements CursorBasedPagingData<T> {
  const factory _CursorBasedPagingData(
      {required final List<T> items,
      required final bool hasMore,
      required final String? nextCursor}) = _$CursorBasedPagingDataImpl<T>;

  @override
  List<T> get items;
  @override
  bool get hasMore;
  @override
  String? get nextCursor;
  @override
  @JsonKey(ignore: true)
  _$$CursorBasedPagingDataImplCopyWith<T, _$CursorBasedPagingDataImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

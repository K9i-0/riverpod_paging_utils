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
mixin _$PagePagingData<T> {
  List<T> get items => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PagePagingDataCopyWith<T, PagePagingData<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PagePagingDataCopyWith<T, $Res> {
  factory $PagePagingDataCopyWith(
          PagePagingData<T> value, $Res Function(PagePagingData<T>) then) =
      _$PagePagingDataCopyWithImpl<T, $Res, PagePagingData<T>>;
  @useResult
  $Res call({List<T> items, bool hasMore, int page});
}

/// @nodoc
class _$PagePagingDataCopyWithImpl<T, $Res, $Val extends PagePagingData<T>>
    implements $PagePagingDataCopyWith<T, $Res> {
  _$PagePagingDataCopyWithImpl(this._value, this._then);

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
abstract class _$$PagePagingDataImplCopyWith<T, $Res>
    implements $PagePagingDataCopyWith<T, $Res> {
  factory _$$PagePagingDataImplCopyWith(_$PagePagingDataImpl<T> value,
          $Res Function(_$PagePagingDataImpl<T>) then) =
      __$$PagePagingDataImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({List<T> items, bool hasMore, int page});
}

/// @nodoc
class __$$PagePagingDataImplCopyWithImpl<T, $Res>
    extends _$PagePagingDataCopyWithImpl<T, $Res, _$PagePagingDataImpl<T>>
    implements _$$PagePagingDataImplCopyWith<T, $Res> {
  __$$PagePagingDataImplCopyWithImpl(_$PagePagingDataImpl<T> _value,
      $Res Function(_$PagePagingDataImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? hasMore = null,
    Object? page = null,
  }) {
    return _then(_$PagePagingDataImpl<T>(
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

class _$PagePagingDataImpl<T> implements _PagePagingData<T> {
  const _$PagePagingDataImpl(
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
    return 'PagePagingData<$T>(items: $items, hasMore: $hasMore, page: $page)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PagePagingDataImpl<T> &&
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
  _$$PagePagingDataImplCopyWith<T, _$PagePagingDataImpl<T>> get copyWith =>
      __$$PagePagingDataImplCopyWithImpl<T, _$PagePagingDataImpl<T>>(
          this, _$identity);
}

abstract class _PagePagingData<T> implements PagePagingData<T> {
  const factory _PagePagingData(
      {required final List<T> items,
      required final bool hasMore,
      required final int page}) = _$PagePagingDataImpl<T>;

  @override
  List<T> get items;
  @override
  bool get hasMore;
  @override
  int get page;
  @override
  @JsonKey(ignore: true)
  _$$PagePagingDataImplCopyWith<T, _$PagePagingDataImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OffsetPagingData<T> {
  List<T> get items => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  int get offset => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OffsetPagingDataCopyWith<T, OffsetPagingData<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OffsetPagingDataCopyWith<T, $Res> {
  factory $OffsetPagingDataCopyWith(
          OffsetPagingData<T> value, $Res Function(OffsetPagingData<T>) then) =
      _$OffsetPagingDataCopyWithImpl<T, $Res, OffsetPagingData<T>>;
  @useResult
  $Res call({List<T> items, bool hasMore, int offset});
}

/// @nodoc
class _$OffsetPagingDataCopyWithImpl<T, $Res, $Val extends OffsetPagingData<T>>
    implements $OffsetPagingDataCopyWith<T, $Res> {
  _$OffsetPagingDataCopyWithImpl(this._value, this._then);

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
abstract class _$$OffsetPagingDataImplCopyWith<T, $Res>
    implements $OffsetPagingDataCopyWith<T, $Res> {
  factory _$$OffsetPagingDataImplCopyWith(_$OffsetPagingDataImpl<T> value,
          $Res Function(_$OffsetPagingDataImpl<T>) then) =
      __$$OffsetPagingDataImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({List<T> items, bool hasMore, int offset});
}

/// @nodoc
class __$$OffsetPagingDataImplCopyWithImpl<T, $Res>
    extends _$OffsetPagingDataCopyWithImpl<T, $Res, _$OffsetPagingDataImpl<T>>
    implements _$$OffsetPagingDataImplCopyWith<T, $Res> {
  __$$OffsetPagingDataImplCopyWithImpl(_$OffsetPagingDataImpl<T> _value,
      $Res Function(_$OffsetPagingDataImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? hasMore = null,
    Object? offset = null,
  }) {
    return _then(_$OffsetPagingDataImpl<T>(
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

class _$OffsetPagingDataImpl<T> implements _OffsetPagingData<T> {
  const _$OffsetPagingDataImpl(
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
    return 'OffsetPagingData<$T>(items: $items, hasMore: $hasMore, offset: $offset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OffsetPagingDataImpl<T> &&
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
  _$$OffsetPagingDataImplCopyWith<T, _$OffsetPagingDataImpl<T>> get copyWith =>
      __$$OffsetPagingDataImplCopyWithImpl<T, _$OffsetPagingDataImpl<T>>(
          this, _$identity);
}

abstract class _OffsetPagingData<T> implements OffsetPagingData<T> {
  const factory _OffsetPagingData(
      {required final List<T> items,
      required final bool hasMore,
      required final int offset}) = _$OffsetPagingDataImpl<T>;

  @override
  List<T> get items;
  @override
  bool get hasMore;
  @override
  int get offset;
  @override
  @JsonKey(ignore: true)
  _$$OffsetPagingDataImplCopyWith<T, _$OffsetPagingDataImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CursorPagingData<T> {
  List<T> get items => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  String? get nextCursor => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CursorPagingDataCopyWith<T, CursorPagingData<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CursorPagingDataCopyWith<T, $Res> {
  factory $CursorPagingDataCopyWith(
          CursorPagingData<T> value, $Res Function(CursorPagingData<T>) then) =
      _$CursorPagingDataCopyWithImpl<T, $Res, CursorPagingData<T>>;
  @useResult
  $Res call({List<T> items, bool hasMore, String? nextCursor});
}

/// @nodoc
class _$CursorPagingDataCopyWithImpl<T, $Res, $Val extends CursorPagingData<T>>
    implements $CursorPagingDataCopyWith<T, $Res> {
  _$CursorPagingDataCopyWithImpl(this._value, this._then);

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
abstract class _$$CursorPagingDataImplCopyWith<T, $Res>
    implements $CursorPagingDataCopyWith<T, $Res> {
  factory _$$CursorPagingDataImplCopyWith(_$CursorPagingDataImpl<T> value,
          $Res Function(_$CursorPagingDataImpl<T>) then) =
      __$$CursorPagingDataImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({List<T> items, bool hasMore, String? nextCursor});
}

/// @nodoc
class __$$CursorPagingDataImplCopyWithImpl<T, $Res>
    extends _$CursorPagingDataCopyWithImpl<T, $Res, _$CursorPagingDataImpl<T>>
    implements _$$CursorPagingDataImplCopyWith<T, $Res> {
  __$$CursorPagingDataImplCopyWithImpl(_$CursorPagingDataImpl<T> _value,
      $Res Function(_$CursorPagingDataImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? hasMore = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_$CursorPagingDataImpl<T>(
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

class _$CursorPagingDataImpl<T> implements _CursorPagingData<T> {
  const _$CursorPagingDataImpl(
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
    return 'CursorPagingData<$T>(items: $items, hasMore: $hasMore, nextCursor: $nextCursor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CursorPagingDataImpl<T> &&
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
  _$$CursorPagingDataImplCopyWith<T, _$CursorPagingDataImpl<T>> get copyWith =>
      __$$CursorPagingDataImplCopyWithImpl<T, _$CursorPagingDataImpl<T>>(
          this, _$identity);
}

abstract class _CursorPagingData<T> implements CursorPagingData<T> {
  const factory _CursorPagingData(
      {required final List<T> items,
      required final bool hasMore,
      required final String? nextCursor}) = _$CursorPagingDataImpl<T>;

  @override
  List<T> get items;
  @override
  bool get hasMore;
  @override
  String? get nextCursor;
  @override
  @JsonKey(ignore: true)
  _$$CursorPagingDataImplCopyWith<T, _$CursorPagingDataImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

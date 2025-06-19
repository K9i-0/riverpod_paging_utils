// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sample_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SampleItem {
  String get id;
  String get name;

  /// Create a copy of SampleItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SampleItemCopyWith<SampleItem> get copyWith =>
      _$SampleItemCopyWithImpl<SampleItem>(this as SampleItem, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SampleItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @override
  String toString() {
    return 'SampleItem(id: $id, name: $name)';
  }
}

/// @nodoc
abstract mixin class $SampleItemCopyWith<$Res> {
  factory $SampleItemCopyWith(
          SampleItem value, $Res Function(SampleItem) _then) =
      _$SampleItemCopyWithImpl;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$SampleItemCopyWithImpl<$Res> implements $SampleItemCopyWith<$Res> {
  _$SampleItemCopyWithImpl(this._self, this._then);

  final SampleItem _self;
  final $Res Function(SampleItem) _then;

  /// Create a copy of SampleItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _SampleItem implements SampleItem {
  const _SampleItem({required this.id, required this.name});

  @override
  final String id;
  @override
  final String name;

  /// Create a copy of SampleItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SampleItemCopyWith<_SampleItem> get copyWith =>
      __$SampleItemCopyWithImpl<_SampleItem>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SampleItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @override
  String toString() {
    return 'SampleItem(id: $id, name: $name)';
  }
}

/// @nodoc
abstract mixin class _$SampleItemCopyWith<$Res>
    implements $SampleItemCopyWith<$Res> {
  factory _$SampleItemCopyWith(
          _SampleItem value, $Res Function(_SampleItem) _then) =
      __$SampleItemCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$SampleItemCopyWithImpl<$Res> implements _$SampleItemCopyWith<$Res> {
  __$SampleItemCopyWithImpl(this._self, this._then);

  final _SampleItem _self;
  final $Res Function(_SampleItem) _then;

  /// Create a copy of SampleItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_SampleItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on

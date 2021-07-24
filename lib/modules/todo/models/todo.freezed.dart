// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'todo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
Todo _$TodoFromJson(Map<String, dynamic> json) {
  return _Todo.fromJson(json);
}

/// @nodoc
class _$TodoTearOff {
  const _$TodoTearOff();

// ignore: unused_element
  _Todo call(
      {String id,
      String userId,
      @required bool done,
      @required String time,
      @required String content,
      @required bool important}) {
    return _Todo(
      id: id,
      userId: userId,
      done: done,
      time: time,
      content: content,
      important: important,
    );
  }

// ignore: unused_element
  Todo fromJson(Map<String, Object> json) {
    return Todo.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $Todo = _$TodoTearOff();

/// @nodoc
mixin _$Todo {
  String get id;
  String get userId;
  bool get done;
  String get time;
  String get content;
  bool get important;

  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $TodoCopyWith<Todo> get copyWith;
}

/// @nodoc
abstract class $TodoCopyWith<$Res> {
  factory $TodoCopyWith(Todo value, $Res Function(Todo) then) =
      _$TodoCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String userId,
      bool done,
      String time,
      String content,
      bool important});
}

/// @nodoc
class _$TodoCopyWithImpl<$Res> implements $TodoCopyWith<$Res> {
  _$TodoCopyWithImpl(this._value, this._then);

  final Todo _value;
  // ignore: unused_field
  final $Res Function(Todo) _then;

  @override
  $Res call({
    Object id = freezed,
    Object userId = freezed,
    Object done = freezed,
    Object time = freezed,
    Object content = freezed,
    Object important = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as String,
      userId: userId == freezed ? _value.userId : userId as String,
      done: done == freezed ? _value.done : done as bool,
      time: time == freezed ? _value.time : time as String,
      content: content == freezed ? _value.content : content as String,
      important: important == freezed ? _value.important : important as bool,
    ));
  }
}

/// @nodoc
abstract class _$TodoCopyWith<$Res> implements $TodoCopyWith<$Res> {
  factory _$TodoCopyWith(_Todo value, $Res Function(_Todo) then) =
      __$TodoCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String userId,
      bool done,
      String time,
      String content,
      bool important});
}

/// @nodoc
class __$TodoCopyWithImpl<$Res> extends _$TodoCopyWithImpl<$Res>
    implements _$TodoCopyWith<$Res> {
  __$TodoCopyWithImpl(_Todo _value, $Res Function(_Todo) _then)
      : super(_value, (v) => _then(v as _Todo));

  @override
  _Todo get _value => super._value as _Todo;

  @override
  $Res call({
    Object id = freezed,
    Object userId = freezed,
    Object done = freezed,
    Object time = freezed,
    Object content = freezed,
    Object important = freezed,
  }) {
    return _then(_Todo(
      id: id == freezed ? _value.id : id as String,
      userId: userId == freezed ? _value.userId : userId as String,
      done: done == freezed ? _value.done : done as bool,
      time: time == freezed ? _value.time : time as String,
      content: content == freezed ? _value.content : content as String,
      important: important == freezed ? _value.important : important as bool,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_Todo implements _Todo {
  const _$_Todo(
      {this.id,
      this.userId,
      @required this.done,
      @required this.time,
      @required this.content,
      @required this.important})
      : assert(done != null),
        assert(time != null),
        assert(content != null),
        assert(important != null);

  factory _$_Todo.fromJson(Map<String, dynamic> json) =>
      _$_$_TodoFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final bool done;
  @override
  final String time;
  @override
  final String content;
  @override
  final bool important;

  @override
  String toString() {
    return 'Todo(id: $id, userId: $userId, done: $done, time: $time, content: $content, important: $important)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Todo &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.done, done) ||
                const DeepCollectionEquality().equals(other.done, done)) &&
            (identical(other.time, time) ||
                const DeepCollectionEquality().equals(other.time, time)) &&
            (identical(other.content, content) ||
                const DeepCollectionEquality()
                    .equals(other.content, content)) &&
            (identical(other.important, important) ||
                const DeepCollectionEquality()
                    .equals(other.important, important)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(done) ^
      const DeepCollectionEquality().hash(time) ^
      const DeepCollectionEquality().hash(content) ^
      const DeepCollectionEquality().hash(important);

  @JsonKey(ignore: true)
  @override
  _$TodoCopyWith<_Todo> get copyWith =>
      __$TodoCopyWithImpl<_Todo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_TodoToJson(this);
  }
}

abstract class _Todo implements Todo {
  const factory _Todo(
      {String id,
      String userId,
      @required bool done,
      @required String time,
      @required String content,
      @required bool important}) = _$_Todo;

  factory _Todo.fromJson(Map<String, dynamic> json) = _$_Todo.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  bool get done;
  @override
  String get time;
  @override
  String get content;
  @override
  bool get important;
  @override
  @JsonKey(ignore: true)
  _$TodoCopyWith<_Todo> get copyWith;
}

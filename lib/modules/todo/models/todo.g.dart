// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Todo _$_$_TodoFromJson(Map<String, dynamic> json) {
  return _$_Todo(
    id: json['id'] as String,
    userId: json['userId'] as String,
    done: json['done'] as bool,
    time: json['time'] as String,
    content: json['content'] as String,
    important: json['important'] as bool,
  );
}

Map<String, dynamic> _$_$_TodoToJson(_$_Todo instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'done': instance.done,
      'time': instance.time,
      'content': instance.content,
      'important': instance.important,
    };

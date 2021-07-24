// To parse this JSON data, do
//
//     final todo = todoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'todo.freezed.dart';
part 'todo.g.dart';

List<Todo> todoFromJson(String str) => List<Todo>.from(json.decode(str).map((x) => Todo.fromJson(x)));

String todoToJson(List<Todo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@freezed
abstract class Todo with _$Todo {
    const factory Todo({
        String id,
        String userId,
        @required bool done,
        @required String time,
        @required String content,
        @required bool important,
    }) = _Todo;

    factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}

// To parse this JSON data, do
//
//     final note = noteFromJson(jsonString);

import 'dart:convert';

List<Note> noteFromJson(String str) => List<Note>.from(json.decode(str).map((x) => Note.fromJson(x)));

String noteToJson(List<Note> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Note {
    Note({
        this.id,
        this.content,
        this.createdAt,
        this.userId,
        this.drawingPoints,
    });

    String id;
    String userId;
    String content;
    String createdAt;
    List<DrawingPoint> drawingPoints;

    Note copyWith({
        String id,
        String content,
        String userId,
        String createdAt,
        List<DrawingPoint> drawingPoints,
    }) => 
        Note(
            id: id ?? this.id,
            content: content ?? this.content,
            userId: userId ?? this.userId,
            createdAt: createdAt ?? this.createdAt,
            drawingPoints: drawingPoints ?? this.drawingPoints,
        );

    factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json["id"] == null ? null : json["id"],
        content: json["content"] == null ? null : json["content"],
        userId: json["userId"] == null ? null : json["userId"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        drawingPoints: json["drawing_points"] == null ? null : List<DrawingPoint>.from(json["drawing_points"].map((x) => DrawingPoint.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "content": content == null ? null : content,
        "userId": userId == null ? null : userId,
        "created_at": createdAt == null ? null : createdAt,
        "drawing_points": drawingPoints == null ? null : List<dynamic>.from(drawingPoints.map((x) => x.toJson())),
    };
}

class DrawingPoint {
    DrawingPoint({
        this.paint,
        this.points,
    });

    Paint paint;
    Points points;

    DrawingPoint copyWith({
        Paint paint,
        Points points,
    }) => 
        DrawingPoint(
            paint: paint ?? this.paint,
            points: points ?? this.points,
        );

    factory DrawingPoint.fromJson(Map<String, dynamic> json) => DrawingPoint(
        paint: json["paint"] == null ? null : Paint.fromJson(json["paint"]),
        points: json["points"] == null ? null : Points.fromJson(json["points"]),
    );

    Map<String, dynamic> toJson() => {
        "paint": paint == null ? null : paint.toJson(),
        "points": points == null ? null : points.toJson(),
    };
}

class Paint {
    Paint({
        this.color,
        this.strokeWidth,
    });

    String color;
    double strokeWidth;

    Paint copyWith({
        String color,
        double strokeWidth,
    }) => 
        Paint(
            color: color ?? this.color,
            strokeWidth: strokeWidth ?? this.strokeWidth,
        );

    factory Paint.fromJson(Map<String, dynamic> json) => Paint(
        color: json["color"] == null ? null : json["color"],
        strokeWidth: json["stroke_width"] == null ? null : json["stroke_width"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "color": color == null ? null : color,
        "stroke_width": strokeWidth == null ? null : strokeWidth,
    };
}

class Points {
    Points({
        this.x,
        this.y,
    });

    double x;
    double y;

    Points copyWith({
        double x,
        double y,
    }) => 
        Points(
            x: x ?? this.x,
            y: y ?? this.y,
        );

    factory Points.fromJson(Map<String, dynamic> json) => Points(
        x: json["x"] == null ? null : json["x"].toDouble(),
        y: json["y"] == null ? null : json["y"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "x": x == null ? null : x,
        "y": y == null ? null : y,
    };
}

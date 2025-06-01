// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ui';

import 'package:task_manager_client/core/utils.dart';

class TaskModel {
  final String id;
  final String uid;
  final String title;
  final Color color;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime dueAt;
  final int isSynced;
  TaskModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.color,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.dueAt,
    required this.isSynced,
  });

  TaskModel copyWith({
    String? id,
    String? uid,
    String? title,
    Color? color,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueAt,
    int? isSynced,
  }) {
    return TaskModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      color: color ?? this.color,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueAt: dueAt ?? this.dueAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'title': title,
      'color': rgbToHex(color),
      'description': description,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'dueAt': dueAt.millisecondsSinceEpoch,
      'isSynced': isSynced,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? "",
      uid: map['uid'] ?? "",
      title: map['title'] ?? "",
      color: hexToRgb(map['color']),
      description: map['description'] ?? "",
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      dueAt: DateTime.parse(map['dueAt']),
      isSynced: map['isSynced'] ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TaskModel(id: $id, uid: $uid, title: $title, color: $color, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, dueAt: $dueAt, isSynced: $isSynced)';
  }

  @override
  bool operator ==(covariant TaskModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uid == uid &&
        other.title == title &&
        other.color == color &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.dueAt == dueAt &&
        other.isSynced == isSynced;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uid.hashCode ^
        title.hashCode ^
        color.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        dueAt.hashCode ^
        isSynced.hashCode;
  }
}

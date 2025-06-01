import 'dart:ui';
import 'dart:convert';
import 'package:task_manager_client/core/utils.dart';

class TaskModel {
  final String id;
  final String uid;
  final Color color;
  final String title;
  final int isSynced;
  final DateTime dueAt;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  TaskModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.color,
    required this.dueAt,
    required this.isSynced,
    required this.createdAt,
    required this.updatedAt,
    required this.description,
  });

  TaskModel copyWith({
    String? id,
    String? uid,
    Color? color,
    String? title,
    int? isSynced,
    DateTime? dueAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? description,
  }) {
    return TaskModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      color: color ?? this.color,
      dueAt: dueAt ?? this.dueAt,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'title': title,
      'isSynced': isSynced,
      'description': description,
      'hexColor': rgbToHex(color),
      'dueAt': dueAt.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? "",
      uid: map['uid'] ?? "",
      title: map['title'] ?? "",
      isSynced: map['isSynced'] ?? 1,
      color: hexToRgb(map['hexColor']),
      dueAt: DateTime.parse(map['dueAt']),
      description: map['description'] ?? "",
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
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

    return (other.id == id &&
        other.uid == uid &&
        other.title == title &&
        other.color == color &&
        other.dueAt == dueAt &&
        other.isSynced == isSynced &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.description == description);
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

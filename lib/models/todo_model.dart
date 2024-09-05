import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String id;
  String title;
  bool isDone;
  bool isDeleted;
  DateTime createdAt;
  DateTime deletedAt;
  DateTime doneAt;

  Todo({
    required this.id,
    required this.title,
    required this.isDone,
    required this.isDeleted,
    required this.createdAt,
    required this.deletedAt,
    required this.doneAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] ?? 'id',
      title: json['title'] ?? 'title',
      isDone: json['isDone'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      createdAt: ((json['createdAt'] ?? Timestamp(0, 0)) as Timestamp).toDate(),
      deletedAt: ((json['deletedAt'] ?? Timestamp(0, 0)) as Timestamp).toDate(),
      doneAt: ((json['doneAt'] ?? Timestamp(0, 0)) as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'deletedAt': deletedAt,
      'doneAt': doneAt,
    };
  }
}

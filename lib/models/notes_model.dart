import 'package:cloud_firestore/cloud_firestore.dart';

class NotesModel {
  String id;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  String folder;
  bool isDeleted;

  NotesModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.folder,
    required this.isDeleted,
  });

  factory NotesModel.fromJson(Map<String, dynamic> json) {
    return NotesModel(
      id: json['id'] ?? 'id',
      title: json['title'] ?? 'title',
      content: json['content'] ?? 'content',
      createdAt: ((json['createdAt'] ?? Timestamp(0, 0)) as Timestamp).toDate(),
      updatedAt: ((json['updatedAt'] ?? Timestamp(0, 0)) as Timestamp).toDate(),
      folder: json['folder'] ?? 'folder',
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'folder': folder,
      'isDeleted': isDeleted,
    };
  }
}

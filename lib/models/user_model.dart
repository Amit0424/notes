import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name;
  String email;
  DateTime createdAt;
  List<String> folders;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.folders,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 'id',
      name: json['name'] ?? 'name',
      email: json['email'] ?? 'email',
      createdAt: ((json['createdAt'] ?? Timestamp(0, 0)) as Timestamp).toDate(),
      folders: List<String>.from(json['folders'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'createdAt': createdAt,
      'folders': folders,
    };
  }
}

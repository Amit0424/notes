import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/main.dart';

import '../../../common/auth.dart';
import '../../../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel _user = UserModel(
    name: 'name',
    email: 'email',
    createdAt: DateTime.now(),
    folders: ['all'],
    id: 'id',
  );

  UserModel get user => _user;

  getUserData() async {
    await fireStore.collection('notesMaker').doc(Auth.uid).get().then((value) {
      _user = UserModel.fromJson(value.data()!);
      listenUserData();
    }).catchError((error) {
      log('Error: $error');
    });
    notifyListeners();
  }

  listenUserData() {
    fireStore
        .collection('notesMaker')
        .doc(Auth.uid)
        .snapshots()
        .listen((event) {
      _user = UserModel.fromJson(event.data()!);
      notifyListeners();
    });
  }

  deleteFolder(int index) async {
    await fireStore.collection('notesMaker').doc(Auth.uid).update({
      'folders': FieldValue.arrayRemove([_user.folders[index]]),
    }).then((value) {
      log('Folder deleted');
    }).catchError((error) {
      log('Error: $error');
    });
  }
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/main.dart';

import '../../../common/auth.dart';
import '../../../models/notes_model.dart';

class NotesProvider with ChangeNotifier {
  final TextEditingController _noteController = TextEditingController();
  final List<NotesModel> _notes = [];
  int _selectedFolder = 0;

  int get selectedFolder => _selectedFolder;

  List<NotesModel> get notes => _notes;

  selectedFolderIndex(int index) {
    _selectedFolder = index;
    notifyListeners();
  }

  getNotes() async {
    await fireStore
        .collection('notesMaker')
        .doc(Auth.uid)
        .collection('notes')
        .doc('all')
        .get()
        .then((value) {
      if (value.exists && value.data() != null) {
        performActionAfterGettingNotes(value);
      }
      listenNotes();
    }).catchError((error) {
      log('Error in getting notes: $error');
    });
  }

  listenNotes() {
    fireStore
        .collection('notesMaker')
        .doc(Auth.uid)
        .collection('notes')
        .doc('all')
        .snapshots()
        .listen((event) {
      if (event.exists && event.data() != null) {
        performActionAfterGettingNotes(event);
      }
    }).onError((error) {
      log('Error in listening notes: $error');
    });
  }

  performActionAfterGettingNotes(DocumentSnapshot<Map<String, dynamic>> value) {
    _notes.clear();
    final Map<String, dynamic> data = value.data() as Map<String, dynamic>;
    data.forEach((key, value) {
      _notes.add(NotesModel.fromJson(value));
    });
    _notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    notifyListeners();
  }

  addNote({
    required String title,
    required DateTime dateTime,
    required BuildContext context,
  }) async {
    final String id = fireStore.collection('notesMaker').doc().id;
    await fireStore
        .collection('notesMaker')
        .doc(Auth.uid)
        .collection('notes')
        .doc('all')
        .update({
      id: {
        'id': id,
        'title': title,
        'content': _noteController.text,
        'createdAt': dateTime,
        'updatedAt': dateTime,
        'deletedAt': dateTime,
        'category': 'all',
        'deleted': false,
      }
    }).then((value) {
      Navigator.pop(context);
      _noteController.clear();
      notifyListeners();
    }).catchError((error) {
      log('Error in adding note: $error');
    });
  }

  updateNote({
    required String title,
    required DateTime dateTime,
    required BuildContext context,
    required String id,
    required DateTime createdAt,
  }) async {
    await fireStore
        .collection('notesMaker')
        .doc(Auth.uid)
        .collection('notes')
        .doc('all')
        .update({
      id: {
        'id': id,
        'title': title,
        'content': _noteController.text,
        'createdAt': createdAt,
        'updatedAt': dateTime,
        'deletedAt': dateTime,
        'category': 'all',
        'deleted': false,
      }
    }).then((value) {
      Navigator.pop(context);
      _noteController.clear();
      notifyListeners();
    }).catchError((error) {
      log('Error in updating note: $error');
    });
  }

  TextEditingController get noteController => _noteController;

  notify() {
    notifyListeners();
  }
}

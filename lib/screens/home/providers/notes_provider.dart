import 'package:flutter/material.dart';

import '../../../models/notes_model.dart';

class NotesProvider with ChangeNotifier {
  final List<NotesModel> _notes = [];
  int _selectedFolder = 0;

  int get selectedFolder => _selectedFolder;
  List<NotesModel> get notes => _notes;

  selectedFolderIndex(int index) {
    _selectedFolder = index;
    notifyListeners();
  }
}

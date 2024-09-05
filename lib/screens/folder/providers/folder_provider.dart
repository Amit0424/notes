import 'package:flutter/material.dart';

class FolderProvider with ChangeNotifier {
  final List<int> _selectedFolderForDeletion = [];
  bool isDeletionActive = false;

  void setSelectFolderForDeletion(int index) {
    if (_selectedFolderForDeletion.contains(index)) {
      _selectedFolderForDeletion.remove(index);
    } else {
      _selectedFolderForDeletion.add(index);
    }
    if (_selectedFolderForDeletion.isEmpty) {
      deactivateDeletion();
    }
    notifyListeners();
  }

  void clearSelectedFolderForDeletion() {
    _selectedFolderForDeletion.clear();
    notifyListeners();
  }

  void selectAllFoldersForDeletion(int length) {
    _selectedFolderForDeletion.clear();
    for (int i = 0; i < length; i++) {
      _selectedFolderForDeletion.add(i);
    }
    notifyListeners();
  }

  void activateDeletion() {
    isDeletionActive = true;
    notifyListeners();
  }

  void deactivateDeletion() {
    isDeletionActive = false;
    _selectedFolderForDeletion.clear();
    notifyListeners();
  }

  List<int> get selectedFolderForDeletion => _selectedFolderForDeletion;
}

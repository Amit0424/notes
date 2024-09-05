import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/common/auth.dart';
import 'package:notes/main.dart';

import '../../../models/todo_model.dart';

class TodosProvider with ChangeNotifier {
  List<Todo> _todos = [];
  List<Todo> _doneTodos = [];

  getTodos() async {
    log('getTodos');
    await fireStore
        .collection('notesMaker')
        .doc(Auth.uid)
        .collection('todos')
        .doc('all')
        .get()
        .then((event) {
      performActionAfterFetchingTodos(event);
      listenTodo();
    }).catchError((error) {
      log('Error in getTodos: $error');
    });
  }

  listenTodo() {
    fireStore
        .collection('notesMaker')
        .doc(Auth.uid)
        .collection('todos')
        .doc('all')
        .snapshots()
        .listen((event) {
      performActionAfterFetchingTodos(event);
    }).onError((error) {
      log('Error in listenTodo: $error');
    });
  }

  performActionAfterFetchingTodos(
      DocumentSnapshot<Map<String, dynamic>> event) {
    _todos.clear();
    _doneTodos.clear();
    final todos = event.data();
    _todos = todos!.entries.map((e) => Todo.fromJson(e.value)).toList();
    _todos.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    _todos = _todos.where((element) => !element.isDeleted).toList();
    _doneTodos = _todos.where((element) => element.isDone).toList();
    _doneTodos.sort((a, b) => b.doneAt.compareTo(a.doneAt));
    _doneTodos = _doneTodos.where((element) => !element.isDeleted).toList();
    _todos = _todos.where((element) => !element.isDone).toList();
    Future.delayed(const Duration(milliseconds: 500), () {
      notify();
    });
  }

  List<Todo> get todos => _todos;

  List<Todo> get doneTodos => _doneTodos;

  addTodo({
    required String title,
    required BuildContext context,
  }) async {
    Navigator.pop(context);
    final id = FirebaseFirestore.instance.collection('notesMaker').doc().id;
    final todo = Todo(
      id: id,
      title: title,
      isDone: false,
      isDeleted: false,
      createdAt: DateTime.now(),
      deletedAt: DateTime.now(),
      doneAt: DateTime.now(),
    );
    _todos.add(todo);
    notify();
    await fireStore
        .collection('notesMaker')
        .doc(Auth.uid)
        .collection('todos')
        .doc('all')
        .update({
      id: {
        'id': id,
        'title': title,
        'isDone': false,
        'isDeleted': false,
        'createdAt': DateTime.now(),
        'deletedAt': DateTime.now(),
        'doneAt': DateTime.now(),
      }
    }).catchError((error) {
      _todos.remove(todo);
      notify();
      log('Error in addTodo: $error');
    });
  }

  updateTodo({
    required String id,
    required String title,
    required BuildContext context,
  }) async {
    Navigator.pop(context);
    final todo = _todos.firstWhere((element) => element.id == id);
    final modifiedTodo = Todo(
      id: todo.id,
      title: title,
      isDone: todo.isDone,
      isDeleted: todo.isDeleted,
      createdAt: todo.createdAt,
      deletedAt: todo.deletedAt,
      doneAt: todo.doneAt,
    );
    _todos.remove(todo);
    _todos.add(modifiedTodo);
    _todos.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    notify();
    await fireStore
        .collection('notesMaker')
        .doc(Auth.uid)
        .collection('todos')
        .doc('all')
        .update({
      id: {
        'id': id,
        'title': title,
        'isDone': todo.isDone,
        'isDeleted': todo.isDeleted,
        'createdAt': todo.createdAt,
        'deletedAt': todo.deletedAt,
        'doneAt': todo.doneAt,
      }
    }).catchError((error) {
      _todos.remove(modifiedTodo);
      _todos.add(todo);
      _todos.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      notify();
      log('Error in updateTodo: $error');
    });
  }

  makeTodoDone({required Todo todo}) async {
    await fireStore
        .collection('notesMaker')
        .doc(Auth.uid)
        .collection('todos')
        .doc('all')
        .update({
      todo.id: {
        'id': todo.id,
        'title': todo.title,
        'isDone': true,
        'isDeleted': todo.isDeleted,
        'createdAt': todo.createdAt,
        'deletedAt': todo.deletedAt,
        'doneAt': DateTime.now(),
      },
    }).catchError((error) {
      log('Error in makeTodoDone: $error');
    });
  }

  makeTodoUndone({required Todo todo}) async {
    final modifiedTodo = Todo(
        id: todo.id,
        title: todo.title,
        isDone: false,
        isDeleted: todo.isDeleted,
        createdAt: todo.createdAt,
        deletedAt: todo.deletedAt,
        doneAt: todo.doneAt);
    _doneTodos.remove(todo);
    _todos.add(modifiedTodo);
    _todos.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    notify();
    await fireStore
        .collection('notesMaker')
        .doc(Auth.uid)
        .collection('todos')
        .doc('all')
        .update({
      todo.id: {
        'id': todo.id,
        'title': todo.title,
        'isDone': false,
        'isDeleted': todo.isDeleted,
        'createdAt': todo.createdAt,
        'deletedAt': todo.deletedAt,
        'doneAt': todo.doneAt,
      },
    }).catchError((error) {
      _doneTodos.add(todo);
      _todos.remove(modifiedTodo);
      _doneTodos.sort((a, b) => b.doneAt.compareTo(a.doneAt));
      notify();
      log('Error in makeTodoUndone: $error');
    });
  }

  deleteTodo({
    required Todo todo,
  }) async {
    if (todo.isDone) _doneTodos.remove(todo);
    if (!todo.isDone) _todos.remove(todo);
    notify();
    await fireStore
        .collection('notesMaker')
        .doc(Auth.uid)
        .collection('todos')
        .doc('all')
        .update({
      todo.id: {
        'id': todo.id,
        'title': todo.title,
        'isDone': todo.isDone,
        'isDeleted': true,
        'createdAt': todo.createdAt,
        'deletedAt': DateTime.now(),
        'doneAt': todo.doneAt,
      },
    }).catchError((error) {
      if (todo.isDone) {
        _doneTodos.add(todo);
        _doneTodos.sort((a, b) => b.doneAt.compareTo(a.doneAt));
      }
      if (!todo.isDone) {
        _todos.add(todo);
        _todos.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      }
      notify();
      log('Error in deleteTodo: $error');
    });
  }

  notify() {
    notifyListeners();
  }
}

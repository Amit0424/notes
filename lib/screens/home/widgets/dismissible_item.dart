import 'package:flutter/material.dart';
import 'package:notes/models/todo_model.dart';
import 'package:notes/screens/home/providers/todos_provider.dart';
import 'package:provider/provider.dart';

import 'create_new_todo.dart';

class DismissibleItem extends StatelessWidget {
  const DismissibleItem({super.key, required this.child, required this.todo});

  final Widget child;
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    final TodosProvider todos =
        Provider.of<TodosProvider>(context, listen: false);
    return Dismissible(
      key: Key(todo.id),
      onDismissed: (_) {
        todos.deleteTodo(todo: todo);
      },
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: const Icon(
                Icons.delete_rounded,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) {
                return CreateNewTodo(
                  id: todo.id,
                  title: todo.title,
                );
              });
        },
        child: child,
      ),
    );
  }
}

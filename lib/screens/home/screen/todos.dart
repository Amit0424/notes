import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/screens/home/providers/todos_provider.dart';
import 'package:notes/screens/home/widgets/dismissible_item.dart';
import 'package:provider/provider.dart';

import '../../../common/app_images.dart';
import '../../../common/screen_dimensions.dart';
import '../widgets/todo_item.dart';

class Todos extends StatefulWidget {
  const Todos({super.key});

  @override
  State<Todos> createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Consumer<TodosProvider>(
            builder: (_, todos, __) {
              if (todos.todos.isEmpty && todos.doneTodos.isEmpty) {
                return Center(
                  child: Container(
                    height: getScreenHeight(context) * 0.4,
                    width: getScreenWidth(context) * 0.7,
                    decoration: const BoxDecoration(
                      image:
                          DecorationImage(image: AssetImage(AppImages.empty)),
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, i) {
                  return DismissibleItem(
                      todo: todos.todos[i],
                      child: TodoItem(
                        todo: todos.todos[i],
                        todos: todos,
                      ));
                },
                separatorBuilder: (_, i) => const SizedBox(height: 10),
                itemCount: todos.todos.length,
              );
            },
          ),
        ),
        if (Provider.of<TodosProvider>(context).doneTodos.isNotEmpty &&
            Provider.of<TodosProvider>(context).todos.isNotEmpty)
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        if (Provider.of<TodosProvider>(context).doneTodos.isNotEmpty)
          SliverToBoxAdapter(
            child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                'Completed ${Provider.of<TodosProvider>(context).doneTodos.length}',
                style: const TextStyle(
                  color: Color(0xFF5D5D5D),
                  fontSize: 12,
                ),
              ),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 10)),
        if (Provider.of<TodosProvider>(context).doneTodos.isNotEmpty)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) {
                final todos =
                    Provider.of<TodosProvider>(context, listen: false);
                return Column(
                  children: [
                    DismissibleItem(
                      todo: todos.doneTodos[i],
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F1F1F),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: todos.doneTodos[i].isDone,
                              onChanged: (value) async {
                                await todos.makeTodoUndone(
                                    todo: todos.doneTodos[i]);
                                Fluttertoast.showToast(
                                  msg: "Marked as UnDone",
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                );
                              },
                              activeColor: const Color(0xFF505050),
                              checkColor: Colors.black,
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: getScreenWidth(context) * 0.6,
                              child: AutoSizeText(
                                todos.doneTodos[i].title,
                                style: const TextStyle(
                                  color: Color(0xFF5D5D5D),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
              childCount: Provider.of<TodosProvider>(context).doneTodos.length,
            ),
          ),
      ],
    );
  }
}

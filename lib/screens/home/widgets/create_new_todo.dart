import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:notes/common/app_colors.dart';
import 'package:notes/screens/home/providers/todos_provider.dart';
import 'package:provider/provider.dart';

import '../../../common/screen_dimensions.dart';

class CreateNewTodo extends StatefulWidget {
  const CreateNewTodo({super.key, this.id = '', this.title = ''});

  final String id;
  final String title;

  @override
  State<CreateNewTodo> createState() => _CreateNewTodoState();
}

class _CreateNewTodoState extends State<CreateNewTodo> {
  final TextEditingController _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _todoController.text = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Container(
            height: getScreenHeight(context) * 0.28,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(value: false, onChanged: (_) {}),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: getScreenWidth(context) * 0.7,
                      color: Colors.transparent,
                      child: TextField(
                        controller: _todoController,
                        decoration: const InputDecoration(
                          hintText: 'Tap "Enter" to create subtasks',
                          hintStyle: TextStyle(
                            color: Color(0xFF5D5D5D),
                          ),
                          border: InputBorder.none,
                        ),
                        minLines: 1,
                        maxLines: 6,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        cursorColor: AppColors.primary,
                        onChanged: (value) {
                          if (value.isEmpty || value.length == 1) {
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    if (widget.title.isEmpty) {
                      await Provider.of<TodosProvider>(context, listen: false)
                          .addTodo(
                        title: _todoController.text,
                        context: context,
                      );
                    } else {
                      await Provider.of<TodosProvider>(context, listen: false)
                          .updateTodo(
                        id: widget.id,
                        title: _todoController.text,
                        context: context,
                      );
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: AutoSizeText(
                        "Done",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

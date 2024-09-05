import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/common/app_colors.dart';

import '../../../common/screen_dimensions.dart';
import '../../../models/todo_model.dart';
import '../providers/todos_provider.dart';
import '../utils/multi_line_painter.dart';

class TodoItem extends StatefulWidget {
  const TodoItem({super.key, required this.todo, required this.todos});

  final Todo todo;
  final TodosProvider todos;

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _lineAnimation;
  late bool isDone;

  @override
  void initState() {
    super.initState();
    isDone = widget.todo.isDone;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _lineAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    if (isDone) {
      _controller.value = 1.0;
    } else {
      _controller.value = 0.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Checkbox(
            value: widget.todo.isDone,
            onChanged: (value) async {
              if (value!) {
                _controller.forward();
              }
              await widget.todos.makeTodoDone(todo: widget.todo);
              Fluttertoast.showToast(
                msg: "Marked as Done",
                backgroundColor: Colors.black,
                textColor: Colors.white,
              );
            },
            activeColor: AppColors.primary,
            checkColor: Colors.black,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: getScreenWidth(context) * 0.6,
            child: LayoutBuilder(builder: (context, constraints) {
              return Stack(
                children: [
                  AutoSizeText(
                    widget.todo.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _lineAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: MultiLinePainter(
                          progress: _lineAnimation.value,
                          text: widget.todo.title,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors
                                .transparent, // The color is transparent to hide it.
                          ),
                          maxWidth: constraints.maxWidth,
                        ),
                        child: Container(),
                      );
                    },
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

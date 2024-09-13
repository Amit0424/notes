import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/common/app_colors.dart';
import 'package:provider/provider.dart';

import '../providers/notes_provider.dart';

class CreateNewNote extends StatefulWidget {
  const CreateNewNote(
      {super.key,
      required this.dateTime,
      required this.title,
      required this.content,
      required this.id,
      required this.createdAt});

  final DateTime dateTime;
  final String title;
  final String content;
  final String id;
  final DateTime createdAt;

  @override
  State<CreateNewNote> createState() => _CreateNewNoteState();
}

class _CreateNewNoteState extends State<CreateNewNote> {
  final TextEditingController _titleController = TextEditingController();

  final FocusNode _firstFocusNode = FocusNode();
  final FocusNode _secondFocusNode = FocusNode();
  bool _isTextFieldFocused = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title;
    Provider.of<NotesProvider>(context, listen: false).noteController.text =
        widget.content;
    _secondFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _firstFocusNode.dispose();
    _secondFocusNode.removeListener(_onFocusChange);
    _secondFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_titleController.text.isEmpty) {
      return;
    }
    setState(() {
      _isTextFieldFocused = _secondFocusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final NotesProvider np = Provider.of<NotesProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions:
            _isTextFieldFocused ? _buildFocusedIcons() : _buildDefaultIcons(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              focusNode: _firstFocusNode,
              selectionHeightStyle: BoxHeightStyle.max,
              decoration: const InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(
                  color: Color(0xFF2C2C2C),
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
              ),
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              cursorColor: AppColors.primary,
              keyboardType: TextInputType.text,
              maxLines: null,
              cursorHeight: 35,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
              ),
              onSubmitted: (value) {
                Future.delayed(const Duration(milliseconds: 100), () {
                  FocusScope.of(context).requestFocus(_secondFocusNode);
                });
              },
            ),
            const SizedBox(height: 5),
            Consumer<NotesProvider>(builder: (_, nP, __) {
              return AutoSizeText(
                "${dateTimeToString(widget.dateTime)}    |    ${nP.noteController.text.length} characters",
                style: const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 12,
                ),
              );
            }),
            const SizedBox(height: 20),
            Expanded(
              child: TextField(
                focusNode: _secondFocusNode,
                decoration: const InputDecoration(
                  hintText: 'Start typing',
                  hintStyle: TextStyle(
                    color: Color(0xFF2C2C2C),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                ),
                controller: np.noteController,
                textCapitalization: TextCapitalization.sentences,
                cursorColor: AppColors.primary,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                cursorHeight: 30,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                onChanged: (value) {
                  np.notify();

                  if (value.length <= 1) {
                    setState(() {
                      _isTextFieldFocused = true;
                    });
                  }
                  if (value.isEmpty) {
                    setState(() {
                      _isTextFieldFocused = false;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  dateTimeToString(DateTime dateTime) {
    if (dateTime.year == DateTime.now().year) {
      DateFormat formatter = DateFormat('d MMMM h:mm a');
      return formatter.format(dateTime);
    } else {
      DateFormat formatter = DateFormat('d MMMM yyyy h:mm a');
      return formatter.format(dateTime);
    }
  }

  List<Widget> _buildDefaultIcons() {
    return <Widget>[
      IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.ios_share_rounded,
          color: Colors.white,
        ),
      ),
      IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
      ),
    ];
  }

  List<Widget> _buildFocusedIcons() {
    return <Widget>[
      IconButton(
        onPressed: () async {
          if (Provider.of<NotesProvider>(context, listen: false)
              .noteController
              .text
              .isEmpty) {
            return;
          }
          if (widget.content.isEmpty) {
            await Provider.of<NotesProvider>(context, listen: false).addNote(
              title: _titleController.text,
              dateTime: widget.dateTime,
              context: context,
            );
          } else {
            await Provider.of<NotesProvider>(context, listen: false).updateNote(
              title: _titleController.text,
              dateTime: widget.dateTime,
              context: context,
              id: widget.id,
              createdAt: widget.createdAt,
            );
          }
        },
        icon: const Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
    ];
  }
}

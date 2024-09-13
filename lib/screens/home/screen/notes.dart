import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart' as intl;
import 'package:notes/screens/home/widgets/folder_list.dart';
import 'package:provider/provider.dart';

import '../../../common/app_images.dart';
import '../../../common/screen_dimensions.dart';
import '../providers/notes_provider.dart';
import '../widgets/create_new_note.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const FolderList(),
        SizedBox(
          height: getScreenHeight(context) * 0.03,
        ),
        Consumer<NotesProvider>(builder: (_, np, __) {
          return np.notes.isEmpty
              ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (np.notes.isEmpty)
                        Container(
                          height: getScreenHeight(context) * 0.4,
                          width: getScreenWidth(context) * 0.7,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(AppImages.empty)),
                          ),
                        ),
                    ],
                  ),
                )
              : Expanded(
                  child: MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    itemCount: np.notes.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CreateNewNote(
                                        dateTime: np.notes[index].updatedAt,
                                        title: np.notes[index].title,
                                        content: np.notes[index].content,
                                        id: np.notes[index].id,
                                        createdAt: np.notes[index].createdAt,
                                      )));
                        },
                        child: Tile(
                          index: index,
                          title: np.notes[index].title,
                          content: np.notes[index].content,
                          dateTime: np.notes[index].updatedAt,
                        ),
                      );
                    },
                  ),
                );
        })
      ],
    );
  }
}

class Tile extends StatelessWidget {
  const Tile({
    super.key,
    required this.index,
    required this.title,
    required this.content,
    required this.dateTime,
    this.bottomSpace,
  });

  final int index;
  final String title;
  final String content;
  final double? bottomSpace;
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    log('${_calculateTextHeight(content)}\nContent: $content');
    final child = Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            AutoSizeText(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          if (title.isNotEmpty)
            const SizedBox(
              height: 10,
            ),
          SizedBox(
            height: 96 < _calculateTextHeight(content)
                ? 96
                : _calculateTextHeight(content),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF919191),
              ),
            ),
          ),
          Text(
            formatDateTime(dateTime),
            style: const TextStyle(
              fontSize: 8,
              color: Color(0xFF919191),
            ),
          ),
        ],
      ),
    );

    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
        Container(
          height: bottomSpace,
          color: Colors.green,
        )
      ],
    );
  }

  double _calculateTextHeight(
    String text,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
          text: text,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF919191),
          )),
      textDirection: TextDirection.ltr,
      maxLines: null, // To calculate height for multiple lines
    )..layout(maxWidth: 200);

    return textPainter.size.height + 16;
  }

  String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final yesterdayStart = todayStart.subtract(const Duration(days: 1));

    final dateFormatter = intl.DateFormat('d MMMM');
    final timeFormatter = intl.DateFormat('hh:mm a');

    if (dateTime.isAfter(todayStart)) {
      return 'Today ${timeFormatter.format(dateTime)}';
    } else if (dateTime.isAfter(yesterdayStart)) {
      return 'Yesterday ${timeFormatter.format(dateTime)}';
    }
    // else if (dateTime.year == now.year) {
    //   return '${dateFormatter.format(dateTime)} ${timeFormatter.format(dateTime)}';
    // }
    else {
      return '${dateFormatter.format(dateTime)} ${dateTime.year} ${timeFormatter.format(dateTime)}';
    }
  }
}

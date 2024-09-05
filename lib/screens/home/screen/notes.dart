import 'package:flutter/material.dart';
import 'package:notes/screens/home/widgets/folder_list.dart';
import 'package:provider/provider.dart';

import '../../../common/app_images.dart';
import '../../../common/screen_dimensions.dart';
import '../providers/notes_provider.dart';

class Notes extends StatelessWidget {
  const Notes({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const FolderList(),
        SizedBox(
          height: getScreenHeight(context) * 0.03,
        ),
        const Spacer(),
        if (Provider.of<NotesProvider>(context).notes.isEmpty)
          Container(
            height: getScreenHeight(context) * 0.4,
            width: getScreenWidth(context) * 0.7,
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage(AppImages.empty)),
            ),
          ),
        const Spacer(),
      ],
    );
  }
}

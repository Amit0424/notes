import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../common/app_colors.dart';
import '../../../common/app_vectors.dart';
import '../../../main.dart';
import '../../auth/providers/user_provider.dart';
import '../../folder/screen/folders.dart';
import '../providers/notes_provider.dart';

class FolderList extends StatelessWidget {
  const FolderList({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Consumer<UserProvider>(builder: (_, user, __) {
          return Consumer<NotesProvider>(builder: (_, notes, __) {
            if (user.user.folders.length == 1 && notes.selectedFolder != 0) {
              notes.selectedFolderIndex(0);
            }
            if (user.user.folders.isEmpty) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3E3E3E),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: AutoSizeText(
                      'All',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              );
            }
            return SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: user.user.folders.length,
                itemBuilder: (_, i) {
                  return GestureDetector(
                    onTap: () {
                      notes.selectedFolderIndex(i);
                    },
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: notes.selectedFolder == i
                            ? const Color(0xFF3E3E3E)
                            : const Color(0xFF242424),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: AutoSizeText(
                          capitalizeFirstLetter(user.user.folders[i]),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(
                  width: 10,
                ),
              ),
            );
          });
        }),
        const SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const Folders()));
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF242424),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: SvgPicture.asset(
                AppVectors.folder,
                height: 30,
                width: 30,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:notes/common/app_colors.dart';
import 'package:notes/common/screen_dimensions.dart';
import 'package:notes/main.dart';
import 'package:notes/screens/auth/providers/user_provider.dart';
import 'package:notes/screens/folder/providers/folder_provider.dart';
import 'package:notes/screens/folder/widgets/create_new_folder.dart';
import 'package:notes/screens/home/providers/notes_provider.dart';
import 'package:provider/provider.dart';

class Folders extends StatelessWidget {
  const Folders({super.key});

  @override
  Widget build(BuildContext context) {
    FolderProvider folderProvider = Provider.of<FolderProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Folders",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Consumer<FolderProvider>(builder: (_, folder, __) {
            return folder.isDeletionActive
                ? IconButton(
                    onPressed: () {
                      int length =
                          Provider.of<UserProvider>(context, listen: false)
                              .user
                              .folders
                              .length;
                      if (length == folder.selectedFolderForDeletion.length) {
                        folder.clearSelectedFolderForDeletion();
                      } else {
                        folder.selectAllFoldersForDeletion(length);
                      }
                    },
                    icon: const Icon(
                      Icons.checklist_rtl_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  )
                : const SizedBox();
          }),
        ],
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (value) {
          if (value) {
            return;
          }

          if (folderProvider.isDeletionActive) {
            folderProvider.deactivateDeletion();
          } else {
            Navigator.pop(context);
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                Column(
                  children: [
                    Consumer<UserProvider>(builder: (_, user, __) {
                      return Consumer<NotesProvider>(builder: (_, notes, __) {
                        return Consumer<FolderProvider>(
                            builder: (_, folder, __) {
                          return ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (_, i) {
                                return GestureDetector(
                                  onTap: () {
                                    if (folder.isDeletionActive) {
                                      folder.setSelectFolderForDeletion(i);
                                      return;
                                    }
                                    notes.selectedFolderIndex(i);
                                  },
                                  onLongPress: () {
                                    folder.activateDeletion();
                                    folder.setSelectFolderForDeletion(i);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 10),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF343434),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: notes.selectedFolder == i
                                              ? AppColors.primary
                                              : Colors.transparent,
                                          size: 20,
                                        ),
                                        AutoSizeText(
                                          capitalizeFirstLetter(
                                              user.user.folders[i]),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        if (folder.isDeletionActive &&
                                            folder.selectedFolderForDeletion
                                                .contains(i))
                                          Container(
                                            height: 20,
                                            width: 20,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.primary,
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        if (folder.isDeletionActive &&
                                            !folder.selectedFolderForDeletion
                                                .contains(i))
                                          Container(
                                            height: 20,
                                            width: 20,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFF242424),
                                            ),
                                          ),
                                        if (!folder.isDeletionActive)
                                          Container(
                                            height: 20,
                                            width: 20,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.transparent,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (_, i) {
                                return const SizedBox(
                                  height: 10,
                                );
                              },
                              itemCount: user.user.folders.length);
                        });
                      });
                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (context) {
                              return const CreateNewFolder();
                            });
                      },
                      child: Container(
                        height: getScreenHeight(context) * 0.08,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF343434),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const AutoSizeText(
                              'New Folder',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (folderProvider.isDeletionActive)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        for (int i = 0;
                            i < folderProvider.selectedFolderForDeletion.length;
                            i++) {
                          Provider.of<UserProvider>(context, listen: false)
                              .deleteFolder(Provider.of<FolderProvider>(context,
                                      listen: false)
                                  .selectedFolderForDeletion[i]);
                        }
                        Provider.of<FolderProvider>(context, listen: false)
                            .deactivateDeletion();
                      },
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF242424),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.folder_delete_outlined,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

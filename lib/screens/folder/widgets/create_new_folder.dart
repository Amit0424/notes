import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/common/auth.dart';
import 'package:notes/main.dart';
import 'package:notes/screens/auth/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../common/app_colors.dart';
import '../../../common/screen_dimensions.dart';
import '../../auth/design/text_field_decoration.dart';

class CreateNewFolder extends StatefulWidget {
  const CreateNewFolder({super.key});

  @override
  State<CreateNewFolder> createState() => _CreateNewFolderState();
}

class _CreateNewFolderState extends State<CreateNewFolder> {
  final TextEditingController _folderNameController = TextEditingController();

  @override
  void initState() {
    _folderNameController.text = "Unnamed folder";
    super.initState();
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
                const AutoSizeText(
                  "New Folder",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: _folderNameController,
                    decoration: textFieldDecoration(
                      hintText: "Enter text",
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    cursorColor: Colors.white,
                    onChanged: (value) {
                      if (value.isEmpty || value.length == 1) {
                        setState(() {});
                      }
                    },
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF454545),
                        minimumSize: const Size(160, 50),
                        elevation: 0,
                      ),
                      child: const AutoSizeText(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (Provider.of<UserProvider>(context, listen: false)
                            .user
                            .folders
                            .contains(_folderNameController.text.trim())) {
                          Fluttertoast.showToast(msg: 'Folder already exists');
                          Navigator.pop(context);
                        }
                        if (_folderNameController.text.isEmpty) {
                          return;
                        }
                        if (_folderNameController.text.isNotEmpty) {
                          await fireStore
                              .collection('notesMaker')
                              .doc(Auth.uid)
                              .update({
                            'folders': FieldValue.arrayUnion([
                              _folderNameController.text.trim(),
                            ])
                          }).then((value) {
                            Navigator.pop(context);
                          }).catchError((error) {
                            log('Error: $error');
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _folderNameController.text.isEmpty
                            ? AppColors.primary.withOpacity(0.1)
                            : AppColors.primary,
                        minimumSize: const Size(160, 50),
                        elevation: 0,
                      ),
                      child: const AutoSizeText(
                        'Create',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

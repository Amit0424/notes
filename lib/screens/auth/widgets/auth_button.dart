import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../common/app_colors.dart';
import '../../../common/screen_dimensions.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({super.key, required this.onPressed, required this.title});
  final void Function() onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        minimumSize: Size(
          double.infinity,
          getScreenHeight(context) * 0.04,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 30,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
        ),
        splashFactory: InkRipple.splashFactory,
        overlayColor: Colors.red,
      ),
      child: AutoSizeText(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../common/app_colors.dart';
import '../../../common/app_images.dart';
import '../../../common/screen_dimensions.dart';

class GoogleAuthButton extends StatelessWidget {
  const GoogleAuthButton(
      {super.key, required this.onPressed, required this.title});
  final void Function() onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: Size(
          double.infinity,
          getScreenHeight(context) * 0.04,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 30,
        ),
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Color(0xFFC8C5CB),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
        ),
        splashFactory: InkRipple.splashFactory,
        overlayColor: AppColors.primary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppImages.google,
            height: 25,
            width: 25,
          ),
          const SizedBox(
            width: 10,
          ),
          AutoSizeText(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}

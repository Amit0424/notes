import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../common/app_colors.dart';
import '../../../common/screen_dimensions.dart';

class AuthLastLine extends StatelessWidget {
  const AuthLastLine(
      {super.key,
      required this.question,
      required this.answer,
      required this.onPressed});
  final String question;
  final String answer;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AutoSizeText(
          question,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        SizedBox(
          width: getScreenWidth(context) * 0.01,
        ),
        GestureDetector(
          onTap: onPressed,
          child: AutoSizeText(
            answer,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

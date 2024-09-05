import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../common/app_colors.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            color: AppColors.secondary,
            thickness: 1,
            endIndent: 10,
            indent: 10,
          ),
        ),
        AutoSizeText(
          'Or',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.secondary,
            thickness: 1,
            endIndent: 10,
            indent: 10,
          ),
        ),
      ],
    );
  }
}

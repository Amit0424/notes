import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../common/app_colors.dart';
import '../../../common/screen_dimensions.dart';
import '../design/text_field_decoration.dart';
import '../widgets/auth_button.dart';
import 'create_new_password.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    Text(
                      "Back to Login",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const AutoSizeText(
                "Forgot Password",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: getScreenHeight(context) * 0.01,
                width: double.infinity,
              ),
              const AutoSizeText(
                "Insert your email address to receive a code for creating a new password",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
              SizedBox(
                height: getScreenHeight(context) * 0.04,
                width: double.infinity,
              ),
              const AutoSizeText(
                "Email Address",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: getScreenHeight(context) * 0.02,
                width: double.infinity,
              ),
              TextFormField(
                decoration: textFieldDecoration(hintText: 'johndoe@gmail.com'),
                cursorColor: Colors.white,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: getScreenHeight(context) * 0.04,
                width: double.infinity,
              ),
              AuthButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CreateNewPassword()));
                },
                title: 'Send Code',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

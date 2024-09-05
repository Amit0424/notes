import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:notes/common/screen_dimensions.dart';
import 'package:notes/main.dart';
import 'package:notes/screens/auth/screen/forgot_password.dart';
import 'package:notes/screens/auth/screen/sign_up.dart';
import 'package:notes/screens/auth/widgets/auth_button.dart';
import 'package:notes/screens/auth/widgets/auth_divider.dart';
import 'package:notes/screens/auth/widgets/auth_last_line.dart';
import 'package:notes/screens/auth/widgets/google_auth_button.dart';
import 'package:notes/widgets/loading_widget.dart';

import '../design/text_field_decoration.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool isShowSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        inAsyncCall: isShowSpinner,
        progressIndicator: const LoadingWidget(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: getScreenHeight(context) * 0.08,
                    width: double.infinity,
                  ),
                  const AutoSizeText(
                    "Let's Check In",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: getScreenHeight(context) * 0.005,
                    width: double.infinity,
                  ),
                  const AutoSizeText(
                    "And notes your ideas.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(
                    height: getScreenHeight(context) * 0.03,
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
                    decoration:
                        textFieldDecoration(hintText: 'johndoe@gmail.com'),
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          !value.contains('@') ||
                          !value.contains('.')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: getScreenHeight(context) * 0.04,
                    width: double.infinity,
                  ),
                  const AutoSizeText(
                    "Password",
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
                    decoration:
                        textFieldDecoration(hintText: '••••••••').copyWith(
                      suffixIcon: _passwordController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    onChanged: (value) {
                      if (value.length <= 1) {
                        setState(() {});
                      }
                    },
                    validator: (value) {
                      if (value == null || value.trim().length < 6) {
                        return 'Password must be at least 6 characters long.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: getScreenHeight(context) * 0.01,
                    width: double.infinity,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ForgotPassword()));
                    },
                    child: const AutoSizeText(
                      "Forgot Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                        decorationThickness: 1.1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: getScreenHeight(context) * 0.04,
                    width: double.infinity,
                  ),
                  AuthButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isShowSpinner = true;
                        });
                        await firebaseAuth
                            .signInWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text)
                            .then((value) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AuthService().handleAuth()));
                        }).catchError((error) {
                          log('Error: $error');
                          showSnackBar('Error occurs! Please try again.');
                        });
                      }
                      setState(() {
                        isShowSpinner = false;
                      });
                    },
                    title: 'Login',
                  ),
                  SizedBox(
                    height: getScreenHeight(context) * 0.04,
                    width: double.infinity,
                  ),
                  const AuthDivider(),
                  SizedBox(
                    height: getScreenHeight(context) * 0.04,
                    width: double.infinity,
                  ),
                  GoogleAuthButton(
                    onPressed: () {},
                    title: 'Login with Google',
                  ),
                  const Spacer(),
                  AuthLastLine(
                    question: "Don't have any account?",
                    answer: "Register here",
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => const SignUp()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showSnackBar(String message) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:notes/common/app_colors.dart';
import 'package:notes/common/auth.dart';
import 'package:notes/main.dart';
import 'package:notes/screens/auth/widgets/auth_button.dart';
import 'package:notes/screens/auth/widgets/auth_divider.dart';
import 'package:notes/screens/auth/widgets/auth_last_line.dart';
import 'package:notes/screens/auth/widgets/google_auth_button.dart';

import '../../../common/screen_dimensions.dart';
import '../../../widgets/loading_widget.dart';
import '../design/text_field_decoration.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isRetypePasswordVisible = false;
  bool isBothPasswordsSame = true;
  bool isShowSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        inAsyncCall: isShowSpinner,
        progressIndicator: const LoadingWidget(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => const Login()));
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
                    SizedBox(
                      height: getScreenHeight(context) * 0.04,
                      width: double.infinity,
                    ),
                    const AutoSizeText(
                      "Register",
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
                      "And start taking notes.",
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
                      "Full Name",
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
                      decoration: textFieldDecoration(hintText: 'John Doe'),
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.name,
                      controller: _fullNameController,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
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
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color:
                                isBothPasswordsSame ? Colors.white : Colors.red,
                          ),
                        ),
                      ),
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      obscureText: _isPasswordVisible,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      onChanged: (value) {
                        if (value.length <= 1) {
                          setState(() {});
                        }
                        if (_retypePasswordController.text.isNotEmpty) {
                          if (_passwordController.text !=
                              _retypePasswordController.text) {
                            setState(() {
                              isBothPasswordsSame = false;
                            });
                          } else {
                            setState(() {
                              isBothPasswordsSame = true;
                            });
                          }
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
                      height: getScreenHeight(context) * 0.04,
                      width: double.infinity,
                    ),
                    const AutoSizeText(
                      "Retype Password",
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
                        suffixIcon: _retypePasswordController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isRetypePasswordVisible =
                                        !_isRetypePasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  _isRetypePasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color:
                                isBothPasswordsSame ? Colors.white : Colors.red,
                          ),
                        ),
                      ),
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.visiblePassword,
                      controller: _retypePasswordController,
                      obscureText: _isRetypePasswordVisible,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      onChanged: (value) {
                        if (value.length <= 1) {
                          setState(() {});
                        }
                        if (_retypePasswordController.text.isNotEmpty) {
                          if (_passwordController.text !=
                              _retypePasswordController.text) {
                            setState(() {
                              isBothPasswordsSame = false;
                            });
                          } else {
                            setState(() {
                              isBothPasswordsSame = true;
                            });
                          }
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
                      height: getScreenHeight(context) * 0.04,
                      width: double.infinity,
                    ),
                    AuthButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isShowSpinner = true;
                          });
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text)
                              .then((value) async {
                            if (value.user != null) {
                              await fireStore
                                  .collection('notesMaker')
                                  .doc(Auth.uid)
                                  .set(
                                {
                                  'id': value.user!.uid,
                                  'email': _emailController.text,
                                  'fullName': _fullNameController.text,
                                  'createdAt': DateTime.now(),
                                  'folders': ['all'],
                                  'password': _passwordController.text,
                                },
                              );

                              await fireStore
                                  .collection('notesMaker')
                                  .doc(Auth.uid)
                                  .collection('notes')
                                  .doc('all')
                                  .set({});

                              await fireStore
                                  .collection('notesMaker')
                                  .doc(Auth.uid)
                                  .collection('todos')
                                  .doc('all')
                                  .set({
                                'vzb34mnkj346': {
                                  'id': 'vzb34mnkj346',
                                  'title': 'Welcome to Task!.',
                                  'isDone': false,
                                  'isDeleted': false,
                                  'deletedAt': DateTime.now(),
                                  'createdAt': DateTime.now(),
                                  'doneAt': DateTime.now(),
                                },
                                'ashdjk456falsd': {
                                  'id': 'ashdjk456falsd',
                                  'title':
                                      'To edit a text task, simply tap it.',
                                  'isDone': false,
                                  'isDeleted': false,
                                  'deletedAt': DateTime.now(),
                                  'createdAt': DateTime.now().add(
                                    const Duration(seconds: 1),
                                  ),
                                  'doneAt': DateTime.now(),
                                },
                                'qwerty34k4n534': {
                                  'id': 'qwerty34k4n534',
                                  'title':
                                      'Here you can add text and voice tasks.',
                                  'isDone': false,
                                  'isDeleted': false,
                                  'deletedAt': DateTime.now(),
                                  'createdAt': DateTime.now().add(
                                    const Duration(seconds: 2),
                                  ),
                                  'doneAt': DateTime.now(),
                                },
                                'vzxcvzxcvzxcv': {
                                  'id': 'vzxcvzxcvzxcv',
                                  'title':
                                      "Don't forget to create a Home screen shortcut for Tasks.",
                                  'isDone': false,
                                  'isDeleted': false,
                                  'deletedAt': DateTime.now(),
                                  'createdAt': DateTime.now().add(
                                    const Duration(seconds: 3),
                                  ),
                                  'doneAt': DateTime.now(),
                                },
                              }).then((value) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            AuthService().handleAuth()));
                              }).catchError((error) {
                                log('Error: $error');
                                showSnackBar('Error occurs! Please try again.');
                              });
                            }
                          }).catchError((error) {
                            log('Error: $error');
                            showSnackBar('Error occurs! Please try again.');
                          });
                        }
                        setState(() {
                          isShowSpinner = false;
                        });
                      },
                      title: 'Register',
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
                      title: 'Register with Google',
                    ),
                    SizedBox(
                      height: getScreenHeight(context) * 0.04,
                      width: double.infinity,
                    ),
                    AuthLastLine(
                      question: 'Already have an account?',
                      answer: 'Login here',
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => const Login()));
                      },
                    ),
                  ],
                ),
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

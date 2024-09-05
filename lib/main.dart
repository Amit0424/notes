import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:notes/common/app_colors.dart';
import 'package:notes/common/app_images.dart';
import 'package:notes/screens/auth/providers/user_provider.dart';
import 'package:notes/screens/auth/screen/login.dart';
import 'package:notes/screens/folder/providers/folder_provider.dart';
import 'package:notes/screens/home/providers/notes_provider.dart';
import 'package:notes/screens/home/providers/todos_provider.dart';
import 'package:notes/screens/home/screen/home_screen.dart';
import 'package:notes/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

final firebaseAuth = FirebaseAuth.instance;
final firebaseStorage = FirebaseStorage.instance;
final fireStore = FirebaseFirestore.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<NotesProvider>(create: (_) => NotesProvider()),
        ChangeNotifierProvider<FolderProvider>(create: (_) => FolderProvider()),
        ChangeNotifierProvider<TodosProvider>(create: (_) => TodosProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          fontFamily: 'inter'),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    redirect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          AppImages.logo,
          scale: 5,
        ),
      ),
    );
  }

  Future<void> redirect() async {
    await Future.delayed(const Duration(seconds: 2)).then((value) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => AuthService().handleAuth()));
    });
  }
}

class AuthService {
  //Handles Authentication
  handleAuth() {
    return StreamBuilder(
      stream: firebaseAuth.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return const Login();
          } else {
            return const HomeScreen();
          }
        } else {
          return const Scaffold(
            body: Center(
              child: LoadingWidget(),
            ),
          );
        }
      },
    );
  }
}

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}

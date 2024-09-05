import '../main.dart';

class Auth {
  static final uid = firebaseAuth.currentUser!.uid;
}

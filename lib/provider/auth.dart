import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  // For registering a new user
  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth Auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await Auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;
      await user!.updateProfile(displayName: name);
      await user.reload();
      user = Auth.currentUser;
    } on FirebaseAuthException catch (error) {
      if (error.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (error.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (error) {
      print(error);
    }

    return user;
  }

  // For signing in an user
  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth Auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await Auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (error.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }

    return user;
  }
}

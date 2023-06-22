import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/users_model.dart';

class AuthenticationProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  String _errorEmail = '';
  String get errorEmail => _errorEmail;

  String _errorPassword = '';
  String get errorPasword => _errorPassword;
  void resetFields() {
    _errorEmail = '';
    _errorPassword = '';
    emailController.clear();
    passwordController.clear();
    notifyListeners();
  }

  void validate() {
    _errorEmail = _validateField(emailController, 'Email');
    _errorPassword = _validateField(passwordController, 'Pasword');
    notifyListeners();
  }

  String _validateField(TextEditingController controller, String fieldName) {
    final String value = controller.text.trim();
    if (value.isEmpty) {
      return '$fieldName is required';
    }
    return '';
  }

  Future<void> loginWithEmailPassword() async {
    validate(); // Validate fields before proceeding

    if (_errorEmail.isEmpty && _errorPassword.isEmpty) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        User? user = userCredential.user;

        if (user != null) {
          DateTime? lastSignIn = user.metadata.lastSignInTime;
          DateTime? creationTime = user.metadata.creationTime;

          UserModel customUser = UserModel(
            uid: user.uid,
            email: user.email!,
            displayName: user.displayName!,
            photoURL: user.photoURL!,
            lastSignIn: lastSignIn,
            creationTime: creationTime,
          );

          await _usersCollection.doc(user.uid).set(customUser.toJson());
        }
      } catch (error) {
        // Handle error saat login dengan email dan kata sandi
        debugPrint('Error logging in with email and password: $error');
      }
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        DateTime? lastSignIn = user.metadata.lastSignInTime;
        DateTime? creationTime = user.metadata.creationTime;

        UserModel customUser = UserModel(
          uid: user.uid,
          email: user.email!,
          displayName: user.displayName!,
          photoURL: user.photoURL!,
          lastSignIn: lastSignIn,
          creationTime: creationTime,
        );

        await _usersCollection.doc(user.uid).set(customUser.toJson());
      }
    } catch (error) {
      // Handle error saat login dengan akun Google
      debugPrint('Error logging in with Google: $error');
    }
  }
}

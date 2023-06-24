import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_pos/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../local_storage/local_storage_util.dart';
import '../model/users_model.dart';
import 'product_provider.dart';

class AuthenticationProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late Stream<QuerySnapshot> userDataStream;

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

  Future<UserModel?> getUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.email)
          .get();
      if (userSnapshot.exists) {
        UserModel userData =
            UserModel.fromJson(userSnapshot.data() as Map<String, dynamic>);
        return userData;
      }
    }
    return null;
  }

  UserModel? userModel;

  Future<void> loginWithEmailPassword() async {
    validate();

    if (_errorEmail.isEmpty && _errorPassword.isEmpty) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        User? user = userCredential.user;
        ProductProvider productProvider =
            Provider.of<ProductProvider>(Get.context!, listen: false);

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

          await _usersCollection.doc(user.email).set(customUser.toJson());
          userModel = await getUserData();
          String token = await user.getIdToken();
          LocalStorageUtil.saveUserToken(token);
          await productProvider.getProducts();
          await productProvider.getCategories();

          Navigator.pushReplacementNamed(Get.context!, AppRoutes.home);
        }
      } catch (error) {
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
      ProductProvider productProvider =
          Provider.of<ProductProvider>(Get.context!, listen: false);

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

        await _usersCollection.doc(user.email).set(customUser.toJson());
        userModel = await getUserData();
        LocalStorageUtil.saveUserToken(googleAuth.accessToken!);
        await productProvider.getProducts();
        await productProvider.getCategories();
        Navigator.pushReplacementNamed(Get.context!, AppRoutes.home);
      }
    } catch (error) {
      debugPrint('Error logging in with Google: $error');
    }
  }
}

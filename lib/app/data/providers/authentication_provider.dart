import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_pos/app/data/providers/consumer_provider.dart';
import 'package:flutter_fire_pos/app/data/providers/report_provider.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../routes/app_routes.dart';
import '../local_storage/local_storage_util.dart';
import '../model/users_model.dart';
import 'product_provider.dart';

class AuthenticationProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late UserCredential userCredential;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late Stream<QuerySnapshot> userDataStream;

  bool _value = false;

  bool get value => _value;

  void setValue(bool newValue) {
    _value = newValue;
    notifyListeners();
  }

  int _tabIndex = 0;

  int get tabIndex => _tabIndex;

  void changeTabIndex(index) {
    _tabIndex = index;
    resetFields();
    notifyListeners();
  }

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  String _errorEmail = '';
  String get errorEmail => _errorEmail;
  String _errorName = '';
  String get errorName => _errorName;

  String _errorPassword = '';
  String get errorPasword => _errorPassword;
  void resetFields() {
    _errorEmail = '';
    _errorPassword = '';
    emailController.clear();
    passwordController.clear();
    notifyListeners();
  }

  void validateRegister() {
    _errorEmail = _validateField(emailController, 'Email');
    _errorPassword = _validateField(passwordController, 'Pasword');
    _errorName = _validateField(nameController, 'Name');
    notifyListeners();
  }

  void validateLogin() {
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
        userModel =
            UserModel.fromJson(userSnapshot.data() as Map<String, dynamic>);

        return userModel;
      }
    }
    return null;
  }

  UserModel? userModel;

  Future<void> loginWithEmailPassword() async {
    validateLogin();

    if (_errorEmail.isEmpty && _errorPassword.isEmpty) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      try {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        User? user = userCredential.user;
        ProductProvider productProvider =
            Provider.of<ProductProvider>(Get.context!, listen: false);
        ConsumersProvider consumerProvider =
            Provider.of<ConsumersProvider>(Get.context!, listen: false);
        ReportProvider reportProvider =
            Provider.of<ReportProvider>(Get.context!, listen: false);

        if (user != null) {
          DateTime? lastSignIn = user.metadata.lastSignInTime;
          DateTime? creationTime = user.metadata.creationTime;

          UserModel customUser = UserModel(
            uid: user.uid,
            email: user.email!,
            displayName: user.displayName ?? user.email!,
            photoURL: "",
            lastSignIn: lastSignIn,
            creationTime: creationTime,
          );

          await _usersCollection.doc(user.email).set(customUser.toJson());

          String token = await user.getIdToken();
          LocalStorageUtil.saveUserToken(token);

          await getUserData();
          await consumerProvider.getConsumers();
          await productProvider.getProducts();
          await productProvider.getCategories();
          await reportProvider.getTransactionHistory();
          notifyListeners();
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

      userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
      ProductProvider productProvider =
          Provider.of<ProductProvider>(Get.context!, listen: false);

      ConsumersProvider consumerProvider =
          Provider.of<ConsumersProvider>(Get.context!, listen: false);
      ReportProvider reportProvider =
          Provider.of<ReportProvider>(Get.context!, listen: false);

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

        LocalStorageUtil.saveUserToken(googleAuth.accessToken!);

        await getUserData();
        await consumerProvider.getConsumers();
        await productProvider.getProducts();
        await productProvider.getCategories();
        await reportProvider.getTransactionHistory();
        notifyListeners();
        Navigator.pushReplacementNamed(Get.context!, AppRoutes.home);
      }
    } catch (error) {
      debugPrint('Error logging in with Google: $error');
    }
  }

  Future<void> registerWithEmailPassword() async {
    validateRegister();
    if (_errorEmail.isEmpty && _errorPassword.isEmpty && _errorName.isEmpty) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      String name = nameController.text.trim();

      try {
        userCredential = await _auth.createUserWithEmailAndPassword(
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
            displayName: name,
            photoURL: '',
            lastSignIn: lastSignIn,
            creationTime: creationTime,
          );

          await _usersCollection.doc(user.email).set(customUser.toJson());

          String token = await user.getIdToken();
          LocalStorageUtil.saveUserToken(token);
          await getUserData();

          notifyListeners();
          Navigator.pushReplacementNamed(Get.context!, AppRoutes.home);
        }
      } catch (error) {
        debugPrint('Error registering with email and password: $error');
      }
    }
  }
}

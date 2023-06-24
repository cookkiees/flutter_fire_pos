import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../model/users_model.dart';

class LocalStorageUtil {
  static final GetStorage _storage = GetStorage();

  static void saveUserToken(String token) {
    _storage.write('userToken', token);

    debugPrint("Local Storage : $token");
  }

  static String? getUserToken() {
    return _storage.read('userToken');
  }

  static bool isLogin() {
    return getUserData() != null || getUserToken() != null;
  }

  static void deleteUserToken() {
    GetStorage().remove('userToken');
    debugPrint("Local Storage : $_storage");
  }

  static void saveUserData(UserModel user) {
    _storage.write('userData', user.toJson());

    debugPrint("Local Storage: $_storage");
  }

  static UserModel? getUserData() {
    Map<String, dynamic>? json = _storage.read('userData');
    if (json != null) {
      return UserModel.fromJson(json);
    }
    return null;
  }

  static void deleteUserData() {
    _storage.remove('userData');
    debugPrint("Local Storage: $_storage");
  }
}

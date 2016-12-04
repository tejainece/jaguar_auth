library jaguar_auth.authenticator;

import 'dart:async';
import 'package:jaguar_auth/src/hashers/hasher.dart';

abstract class UserModel {
  String get username;

  String get password;
}

/// Checks password for given username and returns the user if passwords match
abstract class PasswordChecker {
  Future<UserModel> authenticate(String username, String password);
}

/// Checks password for given username and returns the user if passwords match
class WhiteListPasswordChecker implements PasswordChecker {
  final Map<String, UserModel> models;

  final Hasher hasher;

  const WhiteListPasswordChecker(Map<String, UserModel> models, {Hasher hasher})
      : models = models ?? const {},
        hasher = hasher ?? const NoHasher();

  Future<UserModel> authenticate(String username, String password) async {
    if (!models.containsKey(username)) {
      return null;
    }

    UserModel model = models[username];

    if (!hasher.verify(password, model.password)) {
      return null;
    }

    return model;
  }
}

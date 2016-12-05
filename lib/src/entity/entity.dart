library jaguar_auth.authenticator;

import 'dart:async';
import 'package:jaguar_auth/src/hasher/hasher.dart';

abstract class UserModel {
  String get authIndex;

  String get authKeyword;
}

/// Checks password for given username and returns the user if passwords match
abstract class AuthModelManager {
  Future<UserModel> fetchModel(String index);

  Future<UserModel> authenticate(String index, String keyword);
}

/// Checks password for given username and returns the user if passwords match
class WhiteListPasswordChecker implements AuthModelManager {
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

    if (!hasher.verify(password, model.authKeyword)) {
      return null;
    }

    return model;
  }

  Future<UserModel> fetchModel(String index) async {
    if (!models.containsKey(index)) {
      return null;
    }

    return models[index];
  }
}

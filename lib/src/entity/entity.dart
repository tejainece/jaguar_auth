library jaguar_auth.authenticator;

import 'dart:async';
import 'package:jaguar_auth/src/hasher/hasher.dart';

abstract class UserModel {
  String get authName;

  String get authKeyword;

  String get sessionId;
}

/// Checks password for given username and returns the user if passwords match
abstract class AuthModelManager {
  Future<UserModel> fetchModelByAuthName(String authName);

  Future<UserModel> fetchModelBySessionId(String sessionId);

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
    UserModel model = await fetchModelByAuthName(username);

    if (model == null) {
      return null;
    }

    if (!hasher.verify(password, model.authKeyword)) {
      return null;
    }

    return model;
  }

  Future<UserModel> fetchModelByAuthName(String authName) async => models.values
      .firstWhere((model) => model.authName == authName, orElse: () => null);

  Future<UserModel> fetchModelBySessionId(String sessionId) async {
    if (!models.containsKey(sessionId)) {
      return null;
    }

    return models[sessionId];
  }
}

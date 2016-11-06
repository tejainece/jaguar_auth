library jaguar_auth.authenticator;

import 'dart:async';
import "package:crypto/crypto.dart" as Crypto;

/// State representing a successful authentication as a particular [Principal].
class AuthState<P> {
  final P principal;

  /// contains the [Principal] that the actions are being performed on behalf of
  /// if applicable
  final P behalfOf;

  /// true if a session may be established as a result of this authentication
  final bool sessionCreationAllowed;

  /// true if the authentication details may be updated in the session as
  /// a result of this authentication
  final bool sessionUpdateAllowed;

  AuthState(this.principal,
      {this.behalfOf,
      this.sessionCreationAllowed: true,
      this.sessionUpdateAllowed: true});
}

/// Checks password for given username and returns the user if passwords match
abstract class PasswordChecker<UserType> {
  Future<UserType> authenticate(String username, String password);
}

abstract class UserModel {
  String get username;

  String get password;
}

abstract class Hasher {
  String hash(String password);

  /// Verifies the given password with given hash
  bool verify(String pwd, String pwdHash);
}

class NoHasher {
  const NoHasher();

  String hash(String password) {
    return password;
  }

  /// Verifies the given password with given hash
  bool verify(String pwd, String pwdHash) {
    return pwd == pwdHash;
  }
}

/// Password hasher
class MD5Hasher {
  final String salt;

  const MD5Hasher(this.salt);

  String hash(String password) {
    String saltedPassword = password + salt;
    Crypto.Digest digest = Crypto.md5.convert(saltedPassword.codeUnits);
    return new String.fromCharCodes(digest.bytes);
  }

  /// Verifies the given password with given hash for the given salt
  bool verify(String pwd, String pwdHash) {
    return pwd == hash(pwdHash);
  }
}

/// Checks password for given username and returns the user if passwords match
class WhitelistPasswordChecker implements PasswordChecker<UserModel> {
  final Map<String, UserModel> models;

  final Hasher hasher;

  const WhitelistPasswordChecker(Map<String, UserModel> models, {Hasher hasher})
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

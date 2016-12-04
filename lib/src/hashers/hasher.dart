library jaguar_auth.hasher;

import "package:crypto/crypto.dart" as Crypto;

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
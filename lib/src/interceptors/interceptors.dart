library jaguar_auth.interceptors;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar/interceptors.dart';
import 'package:jaguar_auth/src/state/state.dart';
import 'package:jaguar_auth/src/auth_header/auth_header.dart';

part 'user_password.dart';

const kBasicAuthScheme = 'Basic';

@InterceptorClass()
class BasicAuth<UserType> extends Interceptor {
  final PasswordChecker<UserType> checker;

  const BasicAuth(this.checker, {String id}) : super(id: id);

  @InputHeader(HttpHeaders.AUTHORIZATION)
  Future<AuthState<UserType>> pre(String header) async {
    final authHeaderOpt = findAuthHeaderItemByScheme(header, kBasicAuthScheme);

    final credentials = _decodeCredentials(authHeaderOpt);
    final usernamePassword = credentials.split(':');

    if (usernamePassword.length != 2) {
      throw new UnAuthorizedError();
    }

    final String username = usernamePassword[0];
    final String password = usernamePassword[1];

    final subject = await checker.authenticate(username, password);

    if (subject == null) {
      throw new UnAuthorizedError();
    }

    return new AuthState<UserType>(subject);
  }

  String _decodeCredentials(AuthHeaderItem authHeader) {
    try {
      return new String.fromCharCodes(
          const Base64Codec.urlSafe().decode(authHeader.credentials));
    } on FormatException catch (_) {
      return '';
    }
  }
}

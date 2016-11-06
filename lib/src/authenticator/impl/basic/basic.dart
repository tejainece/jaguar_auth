library jaguar_auth.authenticator.impl.basic;

import 'dart:io';
import 'dart:async';
import 'package:jaguar_auth/src/authenticator/authenticator.dart';

const kBasicAuthScheme = 'Basic';

/// Basic Authentication (http://tools.ietf.org/html/rfc2617)
class BasicAuthenticator<P extends AuthSubject> extends Authenticator<P> {
  final UserLookupByUsernamePassword<P> userLookup;

  BasicAuthenticator(this.userLookup) {
  }

  @override
  Future<AuthState<P>> authenticate(HttpRequest request) {
    final authHeaderOpt = authorizationHeader(request, kBasicAuthScheme);
    return authHeaderOpt.map((authHeader) {
      final usernamePasswordStr = _getCredentials(authHeader);

      final usernamePassword = usernamePasswordStr.split(':');

      if (usernamePassword.length != 2) {
        throw new BadRequestException();
      }

      final principalFuture =
      userLookup(usernamePassword[0], usernamePassword[1]);

      return principalFuture.then((principalOption) =>
          principalOption.map((principal) => createAuthState(principal)));
    }).getOrElse(() => new Future(() => const None()));
  }

  String _getCredentials(AuthorizationHeader authHeader) {
    try {
      return new String.fromCharCodes(
          const Base64Codec.urlSafe().decode(authHeader.credentials));
    } on FormatException catch (_) {
      return '';
    }
  }
}
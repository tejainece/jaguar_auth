library jaguar_auth.authenticator.impl.basic;

/* TODO
import 'dart:io';
import 'dart:async';
import 'package:jaguar_auth/src/authenticator/authenticator.dart';

const String SHELF_AUTH_STD_USER_CREDENTIALS =
    'shelf_auth.std.user.credentials';

StdUserCredentials getStdUserCredentials(HttpRequest request) =>
    getPathParameter(request, SHELF_AUTH_STD_USER_CREDENTIALS);

HttpRequest setStdUserCredentials(
    HttpRequest request, StdUserCredentials credentials) =>
    addPathParameters(request, {SHELF_AUTH_STD_USER_CREDENTIALS: credentials});

class StdUserCredentials {
  final String username;
  final String password;

  StdUserCredentials(this.username, this.password);

  StdUserCredentials.build({this.username, this.password});

  StdUserCredentials.fromJson(Map json)
      : username = json['username'],
        password = json['password'];
}

/// An [Authenticator] for standard username password form style login.
/// There are two ways to use this
///
/// 1. submit a `application/x-www-form-urlencoded` encoded body where the
/// username and password form fields must be called `username` and `password`
/// respectively.
/// 1. add Middleware before the authenicator that extracts the username and
/// password from the request (somehow) and use the `setStdUserCredentials`
/// to add them to the context
class UsernamePasswordAuthenticator<P extends AuthSubject>
    extends Authenticator<P> {
  final UserLookupByUsernamePassword<P> userLookup;

  UsernamePasswordAuthenticator(this.userLookup) {
  }

  @override
  Future<AuthState<P>> authenticate(HttpRequest request) {
    final credentialsFuture = _extractCredentials(request);

    final principalFuture = credentialsFuture.then((credentials) =>
        userLookup(credentials.username, credentials.password));

    return principalFuture.then((principalOption) => principalOption
        .map((principal) => createAuthState(principal))
        .orElse(() => throw new UnauthorizedException()));
  }

  Future<StdUserCredentials> _extractCredentials(HttpRequest request) {
    final contextCredentials = getStdUserCredentials(request);
    final credentialsFuture = new Future.sync(() => contextCredentials != null
        ? contextCredentials
        : _extractFormCredentials(request));

    return credentialsFuture.then((credentials) {
      if (credentials == null || credentials.username == null) {
        throw new UnauthorizedException();
      }

      return credentials;
    });
  }

  Future<StdUserCredentials> _extractFormCredentials(HttpRequest request) {
    final contentTypeStr = request.headers[HttpHeaders.CONTENT_TYPE];
    if (contentTypeStr != null) {
      final contentType = ContentType.parse(contentTypeStr);

      if (contentType.mimeType == "application/x-www-form-urlencoded") {
        return request.readAsString().then(
            (s) => new StdUserCredentials.fromJson(Uri.splitQueryString(s)));
      }
    }

    return new Future.value(null);
  }
}
*/
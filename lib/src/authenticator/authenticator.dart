library jaguar_auth.authenticator;

import 'dart:io';
import 'dart:async';

import 'package:jaguar_auth/src/state/state.dart';

export 'package:jaguar_auth/src/state/state.dart' show AuthState, AuthSubject;

/// Authenticator interface
abstract class Authenticator<P extends AuthSubject> {
  /// Authenticates the request returning a Future with one of three outcomes:
  Future<AuthState<P>> authenticate(HttpRequest request);

  AuthState<P> createAuthState(principal) {
    //TODO sessionCreationAllowed and sessionUpdateAllowed
    return new AuthState(principal);
  }
}

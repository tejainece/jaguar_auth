library jaguar_auth.authenticator;

/// Someone or system that can be authenticated
abstract class AuthSubject {
  String get name;
}

/// State representing a successful authentication as a particular [Principal].
class AuthState<P extends AuthSubject> {
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

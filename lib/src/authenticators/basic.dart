part of jaguar_auth.authenticators;

class WrapBasicAuth implements RouteWrapper<BasicAuth> {
  final AuthModelManager modelManager;

  final String sessionIdKey;

  final String id;

  final Map<Symbol, MakeParam> makeParams;

  const WrapBasicAuth({this.sessionIdKey: 'id', this.modelManager, this.id, this.makeParams});

  BasicAuth createInterceptor() => new BasicAuth(this.modelManager, sessionIdKey: this.sessionIdKey);
}

class BasicAuth extends Interceptor {
  final AuthModelManager modelManager;

  final String sessionIdKey;

  final bool manageSession;

  @Input(SessionInterceptor)
  BasicAuth(this.modelManager,
      {this.sessionIdKey: 'id', this.manageSession: true});

  @InputHeader(HttpHeaders.AUTHORIZATION)
  @Input(SessionInterceptor)
  Future<UserModel> pre(String header, SessionManager sessionManager) async {
    AuthHeaderItem basic =
        new AuthHeaderItem.fromHeaderBySchema(header, kBasicAuthScheme);

    if (basic == null) {
      throw new UnAuthorizedError();
    }

    final credentials = _decodeCredentials(basic);
    final usernamePassword = credentials.split(':');

    if (usernamePassword.length != 2) {
      throw new UnAuthorizedError();
    }

    final String username = usernamePassword[0];
    final String password = usernamePassword[1];

    final subject = await modelManager.authenticate(username, password);

    if (subject == null) {
      throw new UnAuthorizedError();
    }

    if (manageSession is bool && manageSession) {
      sessionManager.updateSession({sessionIdKey: subject.sessionId});
    }

    return subject;
  }

  String _decodeCredentials(AuthHeaderItem authHeader) {
    try {
      return new String.fromCharCodes(
          const Base64Codec.urlSafe().decode(authHeader.credentials));
    } on FormatException catch (_) {
      return '';
    }
  }

  static const kBasicAuthScheme = 'Basic';
}

part of jaguar_auth.authenticators;

class WrapUsernamePasswordJsonAuth
    implements RouteWrapper<UsernamePasswordJsonAuth> {
  final AuthModelManager modelManager;

  final String id;

  final Map<Symbol, MakeParam> makeParams;

  const WrapUsernamePasswordJsonAuth(
      {this.modelManager, this.id, this.makeParams});

  UsernamePasswordJsonAuth createInterceptor() =>
      new UsernamePasswordJsonAuth(this.modelManager);
}

/// An [Authenticator] for standard username password login using ajax requests.
/// It expects a `application/json` encoded body where the
/// username and password fields must be called `username` and `password`
/// respectively.
class UsernamePasswordJsonAuth extends Interceptor {
  final AuthModelManager modelManager;

  final String sessionIdKey;

  final bool manageSession;

  UsernamePasswordJsonAuth(this.modelManager,
      {this.sessionIdKey: 'id', this.manageSession: true});

  @Input(SessionInterceptor)
  Future<UserModel> pre(HttpRequest req, SessionManager sessionManager) async {
    DecodeJsonMap jsonDecoder = new DecodeJsonMap();
    Map<String, dynamic> jsonBody = await jsonDecoder.pre(req);

    if (jsonBody == null) {
      throw new UnAuthorizedError();
    }

    final String username = jsonBody['username'];
    final String password = jsonBody['password'];

    if (username is! String) {
      throw new UnAuthorizedError();
    }

    if (password is! String) {
      throw new UnAuthorizedError();
    }

    final subject = await modelManager.authenticate(username, password);

    if (subject == null) {
      throw new UnAuthorizedError();
    }

    if (manageSession is bool && manageSession) {
      sessionManager.updateSession({sessionIdKey: subject.sessionId});
    }

    return subject;
  }
}

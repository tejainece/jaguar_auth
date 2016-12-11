part of jaguar_auth.authenticators;

class WrapUsernamePasswordAuth implements RouteWrapper<UsernamePasswordAuth> {
  final AuthModelManager modelManager;

  final String id;

  final Map<Symbol, MakeParam> makeParams;

  const WrapUsernamePasswordAuth({this.modelManager, this.id, this.makeParams});

  UsernamePasswordAuth createInterceptor() =>
      new UsernamePasswordAuth(this.modelManager);
}

/// An [Authenticator] for standard username password form style login.
/// It expects a `application/x-www-form-urlencoded` encoded body where the
/// username and password form fields must be called `username` and `password`
/// respectively.
class UsernamePasswordAuth extends Interceptor {
  final AuthModelManager modelManager;

  final String sessionIdKey;

  final bool manageSession;

  UsernamePasswordAuth(this.modelManager,
      {this.sessionIdKey: 'id', this.manageSession: true});

  @Input(SessionInterceptor)
  Future<UserModel> pre(HttpRequest req, SessionManager sessionManager) async {
    DecodeUrlEncodedForm bodyDecoder = new DecodeUrlEncodedForm();
    Map<String, String> form = await bodyDecoder.pre(req);

    if (form is! Map<String, String>) {
      throw new UnAuthorizedError();
    }

    final String username = form['username'];
    final String password = form['password'];

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

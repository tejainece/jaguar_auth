part of jaguar_auth.authenticators;

/// An [Authenticator] for standard username password login using ajax requests.
/// It expects a `application/json` encoded body where the
/// username and password fields must be called `username` and `password`
/// respectively.
class UsernamePasswordJsonAuth extends Interceptor {
  final AuthModelManager modelManager;

  const UsernamePasswordJsonAuth(
      {this.modelManager, String id, Map<Symbol, MakeParam> makeParams})
      : super(id: id, makeParams: makeParams);

  @DecodeJsonMap()
  @Input(SessionInterceptor)
  Future<UserModel> pre(
      Map<String, dynamic> jsonBody, SessionManager sessionManager) async {
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

    //TODO request session manager to create session?

    return subject;
  }
}

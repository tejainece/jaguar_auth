part of jaguar_auth.authenticators;

/// An [Authenticator] for standard username password form style login.
/// It expects a `application/x-www-form-urlencoded` encoded body where the
/// username and password form fields must be called `username` and `password`
/// respectively.
class UsernamePasswordAuth extends Interceptor {
  final AuthModelManager modelManager;

  const UsernamePasswordAuth(
      {this.modelManager, String id, Map<Symbol, MakeParam> makeParams})
      : super(id: id, makeParams: makeParams);

  @DecodeUrlEncodedForm()
  @Input(SessionInterceptor)
  Future<UserModel> pre(
      Map<String, String> form, SessionManager sessionManager) async {
    final String username = form['username'];
    final String password = form['password'];

    final subject = await modelManager.authenticate(username, password);

    if (subject == null) {
      throw new UnAuthorizedError();
    }

    //TODO request session manager to create session?

    return subject;
  }
}

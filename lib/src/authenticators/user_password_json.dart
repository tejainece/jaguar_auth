part of jaguar_auth.authenticators;

/// An [Authenticator] for standard username password login using ajax requests.
/// It expects a `application/json` encoded body where the
/// username and password fields must be called `username` and `password`
/// respectively.
class UsernamePasswordJsonAuth extends Interceptor {
  final PasswordChecker checker;

  const UsernamePasswordJsonAuth(
      {this.checker, String id, Map<Symbol, Type> params})
      : super(id: id, params: params);

  @DecodeJsonMap()
  Future<UserModel> pre(Map<String, dynamic> jsonBody) async {
    final String username = jsonBody['username'];
    final String password = jsonBody['password'];

    if(username is! String) {
      throw new UnAuthorizedError();
    }

    if(password is! String) {
      throw new UnAuthorizedError();
    }

    final subject = await checker.authenticate(username, password);

    if (subject == null) {
      throw new UnAuthorizedError();
    }

    return subject;
  }
}

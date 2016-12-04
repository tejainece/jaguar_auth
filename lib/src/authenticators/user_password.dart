part of jaguar_auth.authenticators;

/// An [Authenticator] for standard username password form style login.
/// It expects a `application/x-www-form-urlencoded` encoded body where the
/// username and password form fields must be called `username` and `password`
/// respectively.
class UsernamePasswordAuth extends Interceptor {
  final PasswordChecker checker;

  const UsernamePasswordAuth(
      {this.checker, String id, Map<Symbol, Type> params})
      : super(id: id, params: params);

  @DecodeUrlEncodedForm()
  Future<UserModel> pre(Map<String, String> form) async {
    final String username = form['username'];
    final String password = form['password'];

    final subject = await checker.authenticate(username, password);

    if (subject == null) {
      throw new UnAuthorizedError();
    }

    return subject;
  }
}

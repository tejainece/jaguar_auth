part of jaguar_auth.interceptors;

/// An [Authenticator] for standard username password form style login.
/// There are two ways to use this
///
/// 1. submit a `application/x-www-form-urlencoded` encoded body where the
/// username and password form fields must be called `username` and `password`
/// respectively.
/// 1. add Middleware before the authenicator that extracts the username and
/// password from the request (somehow) and use the `setStdUserCredentials`
/// to add them to the context
@InterceptorClass()
class UsernamePasswordAuth<UserType> extends Interceptor {
  final PasswordChecker<UserType> checker;

  const UsernamePasswordAuth(this.checker, {String id}) : super(id: id);

  @DecodeUrlEncodedForm()
  Future<AuthState<UserType>> pre(Map<String, String> form) async {
    final String username = form['username'];
    final String password = form['password'];

    final subject = await checker.authenticate(username, password);

    if (subject == null) {
      throw new UnAuthorizedError();
    }

    return new AuthState<UserType>(subject);
  }
}

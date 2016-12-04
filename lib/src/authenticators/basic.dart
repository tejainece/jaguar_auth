part of jaguar_auth.authenticators;

const kBasicAuthScheme = 'Basic';

class BasicAuth extends Interceptor {
  final PasswordChecker checker;

  const BasicAuth({this.checker, String id, Map<Symbol, Type> params})
      : super(id: id, params: params);

  @InputHeader(HttpHeaders.AUTHORIZATION)
  Future<UserModel> pre(String header) async {
    final basic =
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

    final subject = await checker.authenticate(username, password);

    if (subject == null) {
      throw new UnAuthorizedError();
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
}

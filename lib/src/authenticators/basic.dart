part of jaguar_auth.authenticators;

class BasicAuth extends Interceptor {
  final AuthModelManager modelManager;

  @Input(SessionInterceptor)
  const BasicAuth({this.modelManager, String id, Map<Symbol, MakeParam> params})
      : super(id: id, params: params);

  @InputHeader(HttpHeaders.AUTHORIZATION)
  @Input(SessionInterceptor)
  Future<UserModel> pre(String header, SessionManager sessionManager) async {
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

    final subject = await modelManager.authenticate(username, password);

    if (subject == null) {
      throw new UnAuthorizedError();
    }

    //TODO request session manager to create session?

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

part of jaguar_auth.session;

class JwtAuthHeaderSessionManager implements SessionManager {
  /// JWT provider
  final JwtInfo info;

  /// List of expected audience
  final List<String> audience;

  final Map<String, dynamic> _value = {};

  final Map<String, String> _writeVals = {};

  JwtAuthHeaderSessionManager(this.info, this.audience);

  String getValue(String key) => _value[key];

  Future<Null> updateSession(Map<String, String> values) async {
    _writeVals.addAll(values);
  }

  /// Parses session from request
  Future<Null> parseRequest(HttpRequest request) async {
    JwtHelper helper = new JwtHelper(info);

    List<String> authHeaderStr = request.headers[HttpHeaders.AUTHORIZATION];
    if (authHeaderStr is! List || authHeaderStr.isEmpty) request;

    AuthHeaderItem jwtToken =
        new AuthHeaderItem.fromHeaderBySchema(authHeaderStr.first, 'Bearer');

    //Validate token
    if (jwtToken is! AuthHeaderItem ||
        !helper.isTokenValid(jwtToken.credentials, audience)) {
      throw new UnAuthorizedError();
    }

    //Decode and provide token
    Map map = helper.decodeToken(jwtToken.credentials).claimSet.toJson();
    _value.addAll(map);
  }

  Future<Response> updateResponse(HttpRequest request, Response resp) async {
    JwtHelper helper = new JwtHelper(info);

    final signatureContext =
        new JwaSymmetricKeySignatureContext(info.tokenSecret);
    final jwt = new JsonWebToken.jws(claimSet, signatureContext);

    return resp;
  }
}

part of jaguar_auth.session;

class CookieSessionManager implements SessionManager {
  CookieSessionManager();

  final Map<String, String> _cookies = {};

  final List<Cookie> _writeVals = [];

  String getValue(String key) => _cookies[key];

  /// Invalidate any existing session and create a new one
  Future<Null> updateSession(Map<String, String> values) async {
    values.forEach((String key, String val) {
      _writeVals.add(new Cookie(key, val));
    });
  }

  Future<Null> addResponseCookie(Cookie cook) async {
    _writeVals.add(cook);
  }

  /// Parses session from request
  Future<Null> parseRequest(HttpRequest request) async {
    request.cookies.forEach((cook) {
      _cookies[cook.name] = cook.value;
    });
  }

  Future<Response> updateResponse(HttpRequest request, Response resp) async {
    resp.cookies.addAll(_writeVals);
    return resp;
  }
}
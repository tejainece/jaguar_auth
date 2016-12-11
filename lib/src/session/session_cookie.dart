part of jaguar_auth.session;

class CookieSessionManager implements SessionManager {
  final String cookieName;

  CookieSessionManager([this.cookieName = 'session']);

  final Map<String, String> _inValues = {};

  final Map<String, String> _outValues = {};

  bool _shouldUpdate = false;

  String getInValue(String key) => _inValues[key];

  /// Invalidate any existing session and create a new one
  Future<Null> updateSession(Map<String, String> values) async {
    _shouldUpdate = true;
    _outValues.addAll(values);
  }

  /// Parses session from request
  Future<Null> parseRequest(HttpRequest request) async {
    for (Cookie cook in request.cookies) {
      if (cook.name == cookieName) {
        dynamic valueMap = _decode(cook.value);
        if (valueMap is Map<String, String>) {
          _inValues.addAll(valueMap);
        }
        break;
      }
    }
  }

  Future<Response> updateResponse(HttpRequest request, Response resp) async {
    if (_shouldUpdate) {
      Cookie cook = new Cookie(cookieName, _encode());
      resp.cookies.add(cook);
    }
    return resp;
  }

  String _encode() {
    String str = JSON.encode(_outValues);
    //TODO encrypt
    return const Base64Codec.urlSafe().encode(str.codeUnits);
  }

  dynamic _decode(String data) {
    String str =
        new String.fromCharCodes(const Base64Codec.urlSafe().decode(data));
    //TODO decrypt
    return JSON.decode(str);
  }
}

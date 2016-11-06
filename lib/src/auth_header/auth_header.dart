library jaguar_auth.auth_header;

import 'dart:io' show HttpHeaders;

/// Represents an item in Authorisation header
class AuthHeaderItem {
  /// Authorisation scheme
  final String authScheme;

  /// Authorisation credentials
  final String credentials;

  AuthHeaderItem(this.authScheme, this.credentials);

  String toString() => '${authScheme} ${credentials}';

  /// Value returned by this function shall be added to request headers
  Map<String, String> toAuthorizationHeader() =>
      {HttpHeaders.AUTHORIZATION: toString()};
}

/// Splits Authorisation header into items
List<String> _splitAuthHeader(message) {
  final authHeadersString = message.headers[HttpHeaders.AUTHORIZATION];
  return authHeadersString == null ? [] : authHeadersString.split(',');
}

/// Finds Authorisation header item in the given [header] by given [sceme]
AuthHeaderItem findAuthHeaderItemByScheme(String header, String sceme) =>
    authHeaderToAuthItems(header)[sceme];

/// Creates and returns a Map of scheme to [AuthHeaderItem] from given [header]
Map<String, AuthHeaderItem> authHeaderToAuthItems(String header) {
  List<String> authHeaders = _splitAuthHeader(header);

  final map = <String, AuthHeaderItem>{};

  authHeaders.forEach((String headerStr) {
    final List<String> parts = header.split(' ');

    if (parts.length != 2) {
      return;
    }

    map[parts[0]] = new AuthHeaderItem(parts[0], parts[1]);
  });

  return map;
}

/// Adds new authorisation item [newItem] to the authorisation header [header]
String addAuthHeaderItemToAuthHeader(String header, AuthHeaderItem newItem,
    {bool omitIfAuthSchemeAlreadyInHeader: true}) {
  final items = authHeaderToAuthItems(header);

  if (omitIfAuthSchemeAlreadyInHeader &&
      items.containsKey(newItem.authScheme)) {
    return header;
  } else {
    items[newItem.authScheme] = newItem;

    return items.values.map((h) => h.toString()).join(',');
  }
}

String removeAuthSchemeFromAuthHeader(String header, String scheme) {
  final items = authHeaderToAuthItems(header);

  if (items.isEmpty || !items.containsKey(scheme)) {
    return header;
  }

  items.remove(scheme);

  return items.values.map((h) => h.toString()).join(',');
}

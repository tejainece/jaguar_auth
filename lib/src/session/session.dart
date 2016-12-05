library jaguar_auth.session;

import 'dart:io';
import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:auth_header/auth_header.dart';
import 'package:jaguar_jwt_auth/jwt_auth.dart';
import 'package:dart_jwt/dart_jwt.dart';

part 'session_auth_header.dart';
part 'session_cookie.dart';

abstract class SessionManager {
  String getValue(String key);

  /// Invalidate any existing session and create a new one
  Future<Null> updateSession(Map<String, String> values);

  /// Parses session from request
  Future<Null> parseRequest(HttpRequest request);

  /// Writes response
  Future<Response> updateResponse(HttpRequest request, Response resp);
}

class SessionInterceptor extends Interceptor {
  final SessionManager sessionManager;

  const SessionInterceptor(
      {this.sessionManager, String id, Map<Symbol, MakeParam> makeParams})
      : super(id: id, makeParams: makeParams);

  Future<SessionManager> pre(HttpRequest req) async {
    await sessionManager.parseRequest(req);
    return sessionManager;
  }

  @InputRouteResponse()
  Future<Response> post(HttpRequest req, Response resp) async {
    //TODO create session?
    return await sessionManager.updateResponse(req, resp);
  }
}

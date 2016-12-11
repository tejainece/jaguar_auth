library jaguar_auth.session;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:jaguar/jaguar.dart';
import 'package:auth_header/auth_header.dart';
import 'package:jaguar_jwt_auth/jwt_auth.dart';
import 'package:dart_jwt/dart_jwt.dart';

part 'session_auth_header.dart';
part 'session_cookie.dart';

abstract class SessionManager {
  String getInValue(String key);

  /// Invalidate any existing session and create a new one
  Future<Null> updateSession(Map<String, String> values);

  /// Parses session from request
  Future<Null> parseRequest(HttpRequest request);

  /// Writes response
  Future<Response> updateResponse(HttpRequest request, Response resp);
}

class WrapSessionInterceptor implements RouteWrapper<SessionInterceptor> {
  final SessionManager sessionManager;

  final String id;

  final Map<Symbol, MakeParam> makeParams;

  const WrapSessionInterceptor({this.sessionManager, this.id, this.makeParams});

  SessionInterceptor createInterceptor() =>
      new SessionInterceptor(this.sessionManager);
}

class SessionInterceptor extends Interceptor {
  final SessionManager sessionManager;

  SessionInterceptor(this.sessionManager);

  Future<SessionManager> pre(HttpRequest req) async {
    await sessionManager.parseRequest(req);
    return sessionManager;
  }

  @InputRouteResponse()
  Future<Response> post(HttpRequest req, Response resp) async {
    return await sessionManager.updateResponse(req, resp);
  }
}

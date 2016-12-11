library jaguar_auth.authoriser;

import 'dart:io';
import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_auth/src/entity/entity.dart';
import 'package:jaguar_session/jaguar_session.dart';

class WrapUserAuthoriser implements RouteWrapper<UserAuthoriser> {
  final AuthModelManager modelManager;

  final String sessionIdKey;

  final String id;

  final Map<Symbol, MakeParam> makeParams;

  const WrapUserAuthoriser({this.sessionIdKey: 'id', this.modelManager, this.id, this.makeParams});

  UserAuthoriser createInterceptor() => new UserAuthoriser(modelManager, sessionIdKey: sessionIdKey);
}

class UserAuthoriser extends Interceptor {
  final AuthModelManager modelManager;

  final String sessionIdKey;

  UserAuthoriser(this.modelManager, {this.sessionIdKey: 'id'});

  @Input(SessionInterceptor)
  Future<UserModel> pre(HttpRequest req, SessionManager sessionManager) async {
    await sessionManager.validate();

    String id = sessionManager.getInValue(sessionIdKey);
    if (id is! String || id.isEmpty) {
      throw new UnAuthorizedError();
    }

    UserModel subject = await modelManager.fetchModelBySessionId(id);

    if (subject == null) {
      throw new UnAuthorizedError();
    }

    return subject;
  }

  @InputRouteResponse()
  @Input(SessionInterceptor)
  Future<Response> post(
      HttpRequest req, Response resp, SessionManager sessionManager) async {
    return await sessionManager.updateResponse(req, resp);
  }
}

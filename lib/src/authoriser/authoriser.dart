library jaguar_auth.authoriser;

import 'dart:io';
import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar/interceptors.dart';
import 'package:jaguar_auth/src/entity/entity.dart';
import 'package:jaguar_auth/src/session/session.dart';

class Authoriser extends Interceptor {
  final AuthModelManager modelManager;

  final SessionManager sessionManager;

  final String authIndexId;

  const Authoriser(
      {this.authIndexId: 'id',
      this.modelManager,
      this.sessionManager,
      String id})
      : super(id: id);

  @DecodeUrlEncodedForm()
  Future<UserModel> pre(HttpRequest req) async {
    await sessionManager.parseRequest(req);

    String id = sessionManager.getValue(authIndexId);
    if (id is! String || id.isEmpty) {
      throw new UnAuthorizedError();
    }

    UserModel subject = await modelManager.fetchModel(id);

    if (subject == null) {
      throw new UnAuthorizedError();
    }

    return subject;
  }

  @InputRouteResponse()
  Future<Response> post(HttpRequest req, Response resp) async {
    return await sessionManager.updateResponse(req, resp);
  }
}

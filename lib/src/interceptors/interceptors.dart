library jaguar_auth.interceptors;

import 'dart:io';
import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_auth/src/authenticator/impl/basic/basic.dart';

AuthorizationHeader authorizationHeader(
    HttpRequest request, String authScheme) {
  return authorizationHeaders(request).firstWhere(
      (authHeader) => authHeader.authScheme == authScheme,
      orElse: () => null);
}

@InterceptorClass()
class BasicAuth extends Interceptor {
  const BasicAuth({String id}): super(id: id);

  @InputHeader()
  Future pre() async {

  }
}
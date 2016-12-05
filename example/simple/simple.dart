library jwt_auth.example.simple;

import 'dart:async';
import 'dart:io';

import 'package:jaguar/jaguar.dart';

import 'routes/routes.dart';

part 'simple.g.dart';

@Api()
class Bibliotek extends _$JaguarBibliotek implements RequestHandler {
  @Group()
  final AuthManager auth = new AuthManager();

  @Group()
  final StudentRoutes student = new StudentRoutes();
}

void main() {
  Bibliotek api = new Bibliotek();

  Configuration config = new Configuration();
  config.addApi(api);

  serve(config);
}

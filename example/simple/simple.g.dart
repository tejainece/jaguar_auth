// GENERATED CODE - DO NOT MODIFY BY HAND

part of jwt_auth.example.simple;

// **************************************************************************
// Generator: ApiGenerator
// Target: class Bibliotek
// **************************************************************************

abstract class _$JaguarBibliotek implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[];

  AuthManager get auth;
  StudentRoutes get student;

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    if (await auth.handleRequest(request)) {
      return true;
    }

    if (await student.handleRequest(request)) {
      return true;
    }

    return false;
  }
}

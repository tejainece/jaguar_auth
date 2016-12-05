// GENERATED CODE - DO NOT MODIFY BY HAND

part of jwt_auth.example.simple.routes;

// **************************************************************************
// Generator: RouteGroupGenerator
// Target: class AuthManager
// **************************************************************************

abstract class _$JaguarAuthManager implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Post(path: '/login'),
    const Post(path: '/logout')
  ];

  void login();

  void logout();

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    PathParams pathParams = new PathParams();
    bool match = false;

//Handler for login
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      SessionInterceptor iSessionInterceptor = new SessionInterceptor(
        makeParams: const <Symbol, MakeParam>{
          #sessionManager: const MakeParamFromMethod(#sessionManager)
        },
        sessionManager: sessionManager(),
      );
      SessionManager rSessionInterceptor = await iSessionInterceptor.pre(
        request,
      );
      BasicAuth iBasicAuth = new BasicAuth(
        modelManager: kModelManager,
      );
      await iBasicAuth.pre(
        request.headers.value('authorization'),
        rSessionInterceptor,
      );
      login();
      rRouteResponse = await iSessionInterceptor.post(
        request,
        rRouteResponse,
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for logout
    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      logout();
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

    return false;
  }
}

// **************************************************************************
// Generator: RouteGroupGenerator
// Target: class StudentRoutes
// **************************************************************************

abstract class _$JaguarStudentRoutes implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(path: '/book/all'),
    const Get(path: '/book/:id')
  ];

  String getAllBooks();

  String getBook(String id);

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    PathParams pathParams = new PathParams();
    bool match = false;

//Handler for getAllBooks
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      Authoriser iAuthoriser = new Authoriser();
      await iAuthoriser.pre(
        request,
      );
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = getAllBooks();
      rRouteResponse = await iAuthoriser.post(
        request,
        rRouteResponse,
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for getBook
    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      Authoriser iAuthoriser = new Authoriser();
      await iAuthoriser.pre(
        request,
      );
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = getBook(
        (pathParams.getField('id')),
      );
      rRouteResponse = await iAuthoriser.post(
        request,
        rRouteResponse,
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

    return false;
  }
}

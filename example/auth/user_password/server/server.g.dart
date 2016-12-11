// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.basic_auth.server;

// **************************************************************************
// Generator: ApiGenerator
// Target: class LibraryApi
// **************************************************************************

abstract class _$JaguarLibraryApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[];

  AuthRoutes get auth;
  StudentRoutes get student;

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    prefix += '/api';
    if (await auth.handleRequest(request, prefix: prefix)) {
      return true;
    }

    if (await student.handleRequest(request, prefix: prefix)) {
      return true;
    }

    return false;
  }
}

// **************************************************************************
// Generator: RouteGroupGenerator
// Target: class AuthRoutes
// **************************************************************************

abstract class _$JaguarAuthRoutes implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Post(path: '/login'),
    const Post(path: '/logout')
  ];

  void login(HttpRequest req);

  CookieSessionManager sessionManager();

  void logout();

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    PathParams pathParams = new PathParams();
    bool match = false;

//Handler for login
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      SessionInterceptor iSessionInterceptor = new WrapSessionInterceptor(
        makeParams: const <Symbol, MakeParam>{
          #sessionManager: const MakeParamFromMethod(#sessionManager)
        },
        sessionManager: sessionManager(),
      )
          .createInterceptor();
      SessionManager rSessionInterceptor = await iSessionInterceptor.pre(
        request,
      );
      UsernamePasswordAuth iUsernamePasswordAuth = new WrapUsernamePasswordAuth(
        modelManager: kModelManager,
      )
          .createInterceptor();
      await iUsernamePasswordAuth.pre(
        request,
        rSessionInterceptor,
      );
      login(
        request,
      );
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
      SessionInterceptor iSessionInterceptor = new WrapSessionInterceptor(
        makeParams: const <Symbol, MakeParam>{
          #sessionManager: const MakeParamFromMethod(#sessionManager)
        },
        sessionManager: sessionManager(),
      )
          .createInterceptor();
      await iSessionInterceptor.pre(
        request,
      );
      logout();
      rRouteResponse = await iSessionInterceptor.post(
        request,
        rRouteResponse,
      );
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
    const Get(path: '/all'),
    const Get(path: '/:id', headers: const {'sample-header': 'sample-value'})
  ];

  Response<String> getAllBooks();

  CookieSessionManager sessionManager();

  String getBook(String id);

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    prefix += '/book';
    PathParams pathParams = new PathParams();
    bool match = false;

//Handler for getAllBooks
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      SessionInterceptor iSessionInterceptor = new WrapSessionInterceptor(
        makeParams: const <Symbol, MakeParam>{
          #sessionManager: const MakeParamFromMethod(#sessionManager)
        },
        sessionManager: sessionManager(),
      )
          .createInterceptor();
      SessionManager rSessionInterceptor = await iSessionInterceptor.pre(
        request,
      );
      UserAuthoriser iUserAuthoriser = new WrapUserAuthoriser(
        modelManager: kModelManager,
      )
          .createInterceptor();
      await iUserAuthoriser.pre(
        request,
        rSessionInterceptor,
      );
      rRouteResponse = getAllBooks();
      rRouteResponse = await iUserAuthoriser.post(
        request,
        rRouteResponse,
        rSessionInterceptor,
      );
      rRouteResponse = await iSessionInterceptor.post(
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
      SessionInterceptor iSessionInterceptor = new WrapSessionInterceptor(
        makeParams: const <Symbol, MakeParam>{
          #sessionManager: const MakeParamFromMethod(#sessionManager)
        },
        sessionManager: sessionManager(),
      )
          .createInterceptor();
      SessionManager rSessionInterceptor = await iSessionInterceptor.pre(
        request,
      );
      UserAuthoriser iUserAuthoriser = new WrapUserAuthoriser(
        modelManager: kModelManager,
      )
          .createInterceptor();
      await iUserAuthoriser.pre(
        request,
        rSessionInterceptor,
      );
      rRouteResponse.statusCode = 200;
      rRouteResponse.headers['sample-header'] = 'sample-value';
      rRouteResponse.value = getBook(
        (pathParams.getField('id')),
      );
      rRouteResponse = await iUserAuthoriser.post(
        request,
        rRouteResponse,
        rSessionInterceptor,
      );
      rRouteResponse = await iSessionInterceptor.post(
        request,
        rRouteResponse,
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

    return false;
  }
}

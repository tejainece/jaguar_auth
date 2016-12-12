part of example.basic_auth.server;

/// Collection of routes students can also access
@RouteGroup(path: '/book')
@WrapSessionInterceptor(makeParams: const <Symbol, MakeParam>{
  #sessionManager: const MakeParamFromMethod(#sessionManager)
})
@WrapUserAuthoriser(modelManager: kModelManager)
class StudentRoutes extends _$JaguarStudentRoutes implements RequestHandler {
  @Get(path: '/all')
  Response<String> getAllBooks() {
    List<Map> ret = _books.values.map((Book book) => book.toMap()).toList();

    Response<String> resp = new Response<String>(JSON.encode(ret));
    resp.cookies.add(new Cookie('sample-cookie', 'sample-cookie-value'));
    return resp;
  }

  @Get(path: '/:id', headers: const {'sample-header': 'sample-value'})
  String getBook(String id) {
    Book book = _books[id];
    return book.toJson();
  }

  CookieSessionManager sessionManager() => new CookieSessionManager();
}

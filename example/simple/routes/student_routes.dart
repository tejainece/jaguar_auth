part of jwt_auth.example.simple.routes;

/// Collection of routes students can also access
@RouteGroup()
@Authoriser()
class StudentRoutes extends _$JaguarStudentRoutes implements RequestHandler {
  @Get(path: '/book/all')
  String getAllBooks() {
    List<Map> ret = _books.values.map((Book book) => book.toMap()).toList();
    return JSON.encode(ret);
  }

  @Get(path: '/book/:id')
  String getBook(String id) {
    Book book = _books[id];
    return book.toJson();
  }
}

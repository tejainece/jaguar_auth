library example.basic_auth.server;

import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:jaguar/jaguar.dart';
import 'package:jaguar_auth/jaguar_auth.dart';

import '../../../models/book/book.dart';

part 'auth_routes.dart';
part 'student_routes.dart';
part 'server.g.dart';

final Map<String, Book> _books = {
  '0': new Book.make('0', 'Book0', 'Author0'),
  '1': new Book.make('1', 'Book1', 'Author1'),
  '2': new Book.make('2', 'Book2', 'Author2'),
};

@Api(path: '/api')
class LibraryApi extends Object
    with _$JaguarLibraryApi
    implements RequestHandler {
  @Group()
  final AuthRoutes auth = new AuthRoutes();

  @Group()
  final StudentRoutes student = new StudentRoutes();
}

server() async {
  LibraryApi api = new LibraryApi();

  Configuration configuration = new Configuration();
  configuration.addApi(api);

  await serve(configuration);
}

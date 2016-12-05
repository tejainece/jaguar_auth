library jwt_auth.example.simple.routes;

import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:jaguar/jaguar.dart';
import 'package:jaguar_auth/jaguar_auth.dart';

import '../../models/book/book.dart';

part 'auth_routes.dart';
part 'student_routes.dart';
part 'routes.g.dart';

final Map<String, Book> _books = {};

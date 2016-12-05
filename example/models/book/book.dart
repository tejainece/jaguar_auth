library jwt_auth.example.models;

import 'dart:convert';
import 'package:jaguar/jaguar.dart';

/// Model for Book
class Book {
  /// Id of the book
  String id;

  /// Name of the book
  String name;

  /// Authors of the book
  List<String> authors;

  Book.FromQueryParam(QueryParams params) {
    fromMap({'name': params.name, 'authors': params.authors});
  }

  /// Converts to Map
  Map toMap() => {
        'name': name,
        'authors': authors.toList(),
      };

  // Converts to JSON
  String toJson() {
    return JSON.encode(toMap());
  }

  /// Builds from JSON
  void fromJson(String json) {
    dynamic map = JSON.decode(json);

    if (map is Map) {
      fromMap(map);
    }
  }

  /// Builds from Map
  void fromMap(Map map) {
    if (map['name'] is String) {
      name = map['name'];
    }

    if (map['authors'] is List) {
      List value = map['authors'];

      if (value.every((el) => el is String)) {
        authors = value;
      }
    }
  }

  void validate() {
    if (id is! String) {
      //TODO
    }

    if (id.isEmpty) {
      //TODO
    }

    if (name is! String) {
      //TODO
    }

    if (name.isEmpty) {
      //TODO
    }

    if (authors is! List<String>) {
      //TODO
    }

    if (!authors.every((el) => el is String)) {
      //TODO
    }
  }
}

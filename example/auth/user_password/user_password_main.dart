library example.auth.user_password;

import 'dart:io';
import 'client/client.dart';
import 'server/server.dart';

main() async {
  await server();

  await client();

  exit(0);
}

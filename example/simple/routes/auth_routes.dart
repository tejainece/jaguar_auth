part of jwt_auth.example.simple.routes;

class User implements UserModel {
  final String username;

  final String password;

  const User(this.username, this.password);

  String get authIndex => username;

  String get authKeyword => password;
}

const Map<String, User> kUsers = const {
  'teja': const User('teja', 'word'),
  'kleak': const User('kleak', 'pass'),
};

const WhiteListPasswordChecker kModelManager =
    const WhiteListPasswordChecker(kUsers);

/// This route group contains login and logout routes
@RouteGroup()
class AuthManager extends _$JaguarAuthManager {
  @Post(path: '/login')
  @SessionInterceptor(makeParams: const <Symbol, MakeParam>{
    #sessionManager: const MakeParamFromMethod(#sessionManager)
  })
  @BasicAuth(modelManager: kModelManager)
  void login() {}

  @Post(path: '/logout')
  void logout() {}

  CookieSessionManager sessionManager() => new CookieSessionManager();
}

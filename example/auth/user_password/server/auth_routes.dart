part of example.basic_auth.server;

class User implements UserModel {
  final String id;

  final String username;

  final String password;

  const User(this.id, this.username, this.password);

  String get authName => username;

  String get authKeyword => password;

  String get sessionId => id;
}

const Map<String, User> kUsers = const {
  '0': const User('0', 'teja', 'word'),
  '1': const User('1', 'kleak', 'pass'),
};

const WhiteListPasswordChecker kModelManager =
    const WhiteListPasswordChecker(kUsers);

/// This route group contains login and logout routes
@RouteGroup()
@WrapSessionInterceptor(makeParams: const <Symbol, MakeParam>{
  #sessionManager: const MakeParamFromMethod(#sessionManager)
})
class AuthRoutes extends _$JaguarAuthRoutes {
  @Post(path: '/login')
  @WrapUsernamePasswordAuth(modelManager: kModelManager)
  void login(HttpRequest req) {}

  @Post(path: '/logout')
  void logout() {
    //TODO logout
  }

  CookieSessionManager sessionManager() => new CookieSessionManager();
}

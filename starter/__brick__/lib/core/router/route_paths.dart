abstract final class RoutePaths {
  {{#include_auth}}
  static const signIn = '/sign-in';
  {{/include_auth}}
  static const home = '/home';
  static const settings = '/settings';
}

abstract final class RouteNames {
  {{#include_auth}}
  static const signIn = 'signIn';
  {{/include_auth}}
  static const home = 'home';
  static const settings = 'settings';
}

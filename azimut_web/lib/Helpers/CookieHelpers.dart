import 'package:web/web.dart' as web;

class CookieHelpers {
  static void SetToken(String token) {
    web.window.sessionStorage.setItem('token', token);
  }

  static String GetToken() =>
      web.window.sessionStorage.getItem('token') ?? "null";

  static bool HasToken() {
    final token = GetToken().trim();
    return token.isNotEmpty && token != 'null';
  }

  static void RemoveToken() => web.window.sessionStorage.removeItem('token');
}



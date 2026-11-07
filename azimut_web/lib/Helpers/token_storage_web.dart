import 'package:web/web.dart' as web;

const _tokenKey = 'token';

String? readToken() =>
    web.window.sessionStorage.getItem(_tokenKey) ??
    web.window.localStorage.getItem(_tokenKey);

void writeToken(String token, {required bool persistent}) {
  clearToken();
  final storage = persistent
      ? web.window.localStorage
      : web.window.sessionStorage;
  storage.setItem(_tokenKey, token);
}

void clearToken() {
  web.window.sessionStorage.removeItem(_tokenKey);
  web.window.localStorage.removeItem(_tokenKey);
}

import 'dart:convert';

import 'token_storage.dart'
    if (dart.library.js_interop) 'token_storage_web.dart'
    as storage;

class CookieHelpers {
  static void SetToken(String token, {bool persistent = false}) =>
      storage.writeToken(token, persistent: persistent);

  static String GetToken() => storage.readToken() ?? 'null';

  static bool HasToken() {
    final parts = GetToken().split('.');
    if (parts.length != 3) return false;
    try {
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      if (payload case {'exp': final num expiry}) {
        if (expiry * 1000 > DateTime.now().millisecondsSinceEpoch) return true;
      }
    } on FormatException {
      // Discard malformed tokens saved in browser storage.
    }
    RemoveToken();
    return false;
  }

  static void RemoveToken() => storage.clearToken();
}

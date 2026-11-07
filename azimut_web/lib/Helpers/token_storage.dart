String? _token;

String? readToken() => _token;

void writeToken(String token, {required bool persistent}) => _token = token;

void clearToken() => _token = null;

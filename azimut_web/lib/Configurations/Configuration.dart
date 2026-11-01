import 'package:dio/dio.dart';

class Configuration {
  static DataSource productionSource = DataSource("localhost", "5237");
  static DataSource localSource = DataSource("localhost", "5237");
  static String get baseUrl {
    const configuredUrl = String.fromEnvironment('API_BASE_URL');
    return configuredUrl.isEmpty
        ? localSource.baseUrl
        : Uri.base.resolve(configuredUrl).toString();
  }

  static List<Controllers> controllers =  [
    Controllers('login', '/api/Auth/login'),
    Controllers('register', '/api/Auth/register'),
  ];
}

class DataSource {
  String host;
  String port;

  DataSource(this.host, this.port);

  String get baseUrl => 'http://$host:$port';

  Controllers getController(String name) {
    return Configuration.controllers.singleWhere((x) => x.name == name);
  }
}

class Controllers {
  String name;
  String path;

  Controllers(this.name, this.path);
}

class ApiClient {
  final Dio dio = Dio(BaseOptions(baseUrl: Configuration.baseUrl));
}



enum Environment { local, dev, prod }

abstract class AppEnvironment {
  static late String scheme;
  static late String baseApiUrl;
  static late int port;
  static late Environment _environment;
  static Environment get environment => _environment;

  static setupEnv(Environment env) {
    _environment = env;
    switch (env) {
      case Environment.local:
        scheme = 'http';
        baseApiUrl = 'localhost';
        port = 8080;
        break;
      case Environment.dev:
        scheme = 'https';
        baseApiUrl = 'localhost_dev';
        port = 8080;
        break;
      case Environment.prod:
        scheme = 'https';
        baseApiUrl = 'localhost_prod';
        port = 8080;
        break;
    }
  }
}

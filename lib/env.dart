enum Environment { local, dev, prod }

abstract class AppEnvironment {

  static late String baseApiUrl;
  static late int port;
  static late Environment _environment;
  static Environment get environment => _environment;

  static setupEnv(Environment env) {
    _environment = env;
    switch (env) {
      case Environment.local:
        baseApiUrl = 'http://localhost';
        port = 8080;
        break;
      case Environment.dev:
        baseApiUrl = 'http://localhost_dev';
        port = 8080;
        break;
      case Environment.prod:
        baseApiUrl = 'http://localhost_prod';
        port = 8080;
        break;
    }
  }


}
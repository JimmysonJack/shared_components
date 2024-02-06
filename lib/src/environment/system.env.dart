class Environment {
  String? _serverUrl;
  String? _clientId;
  String? _clientSecret;
  String? _port;
  static Environment? _instance;

  static Environment getInstance() {
    _instance ??= Environment();
    return _instance!;
  }

  setClientId(String clientId) {
    _clientId = clientId;
  }

  String? getClientId() {
    return _clientId;
  }

  setClientSecret(String clientSecret) {
    _clientSecret = clientSecret;
  }

  String? getClientSecret() {
    return _clientSecret;
  }

  setServerUrl(String serverUrl) {
    _serverUrl = serverUrl;
  }

  String? getServerUrl() {
    return _serverUrl;
  }

  setServerUrlPort(String port) {
    _port = port;
  }

  String? getServerUrlPort() {
    return _port;
  }
}

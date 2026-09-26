class AppEnv {
  const AppEnv._();

  static const String appsScriptProxyUrl =
      String.fromEnvironment('APPS_SCRIPT_PROXY_URL');
  static const String appSharedSecret =
      String.fromEnvironment('APP_SHARED_SECRET');
}

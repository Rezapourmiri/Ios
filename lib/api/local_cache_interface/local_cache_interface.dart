import 'package:shared_preferences/shared_preferences.dart';

class LocalCacheInterface {
  final Future<SharedPreferences> _sharedPreferencesProvider;

  LocalCacheInterface(this._sharedPreferencesProvider);

  ///
  /// Saves app environment to shared preferences.
  ///
  Future<void> setAppEnvironment(String environment) async {
    SharedPreferences sharedPreferences = await _sharedPreferencesProvider;
    sharedPreferences.setString(Prefixes.APP_ENVIRONMENT, environment);
  }

  ///
  /// Gets app environment from shared preferences
  ///
  Future<String?> getAppEnvironment() async {
    SharedPreferences sharedPreferences = await _sharedPreferencesProvider;
    return sharedPreferences.getString(Prefixes.APP_ENVIRONMENT);
  }

  ///
  /// Saves custom frontend url to shared preferences.
  ///
  Future<void> setCustomFrontend(String frontEndURL) async {
    SharedPreferences sharedPreferences = await _sharedPreferencesProvider;
    sharedPreferences.setString(Prefixes.CUSTOM_FRONTEND, frontEndURL);
  }

  ///
  /// Gets custom frontend url from shared preferences
  ///
  Future<String?> getCustomFrontend() async {
    SharedPreferences sharedPreferences = await _sharedPreferencesProvider;
    return sharedPreferences.getString(Prefixes.CUSTOM_FRONTEND);
  }

  ///
  /// Saves custom backend url to shared preferences.
  ///
  Future<void> setCustomBackend(String backendURL) async {
    SharedPreferences sharedPreferences = await _sharedPreferencesProvider;
    sharedPreferences.setString(Prefixes.CUSTOM_BACKEND, backendURL);
  }

  ///
  /// Gets custom backend url from shared preferences
  ///
  Future<String?> getCustomBackend() async {
    SharedPreferences sharedPreferences = await _sharedPreferencesProvider;
    return sharedPreferences.getString(Prefixes.CUSTOM_BACKEND);
  }

  ///
  /// Removes custom backend data from shared preferences.
  ///
  Future<void> removeCustomBackend() async {
    SharedPreferences sharedPreferences = await _sharedPreferencesProvider;
    sharedPreferences.remove(Prefixes.CUSTOM_BACKEND);
  }

  ///
  /// Removes custom frontend data from shared preferences.
  ///
  Future<void> removeCustomFrontend() async {
    SharedPreferences sharedPreferences = await _sharedPreferencesProvider;
    sharedPreferences.remove(Prefixes.CUSTOM_FRONTEND);
  }
}

class Prefixes {
  // ignore: constant_identifier_names
  static const String APP_ENVIRONMENT = "APP_ENVIRONMENT";
  // ignore: constant_identifier_names
  static const String CUSTOM_FRONTEND = "CUSTOM_FRONTEND";
  // ignore: constant_identifier_names
  static const String CUSTOM_BACKEND = "CUSTOM_BACKEND";
}

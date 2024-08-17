// ignore_for_file: constant_identifier_names

import 'package:get_it/get_it.dart';
import 'package:optima_soft/api/local_cache_interface/local_cache_interface.dart';
import 'package:optima_soft/helpers/string_helpers.dart';
import 'package:optima_soft/services/shared-preference-service.dart';

const String tenantTag = "[tenantName]";
const String TldTag = "[TLD]";

class BackendDroplet {
  static const PRODUCTION = "https://api.optimasoft.[TLD]/$tenantTag/PR";
  static const SERVERSTAGE = "https://api.dev.optimasoft.[TLD]/$tenantTag/PR";
  static const STAGE = "http://192.168.80.109:5000/$tenantTag/PR";
}

class PWAServers {
  static const PRODUCTION =
      "https://hr.optimasoft.[TLD]/$tenantTag/PR/auth/login-phone";
  static const SERVERSTAGE =
      "https://hr.dev.optimasoft.[TLD]/$tenantTag/PR/auth/login-phone";
  static const STAGE =
      "http://192.168.80.109:4201/$tenantTag/PR/auth/login-phone";
}

enum Environment { PROD, STAGE, SERVERSTAGE }

// /android/app/build.gradle
// applicationId
// keystorePropertiesFile

// android\app\src\main\AndroidManifest.xml
// package name
// android:label
String appEnvironment = EnvironmentHelpers.SERVERSTAGE;

class EnvironmentHelpers {
  static const String STAGE = "STAGE";
  static const String SERVERSTAGE = "SERVERSTAGE";
  static const String PROD = "PROD";

  static final LocalCacheInterface _localCacheInterface =
      GetIt.instance.get<LocalCacheInterface>();

  ///
  /// Sets current app environment and remove cached custom URLs.
  ///
  static Future<void> setAppEnvironment(Environment environment) async {
    if (environment == Environment.STAGE) {
      await _localCacheInterface.setAppEnvironment(STAGE);
    } else {
      await _localCacheInterface.setAppEnvironment(PROD);
    }
    await _localCacheInterface.removeCustomBackend();
    await _localCacheInterface.removeCustomFrontend();
  }

  ///
  /// Returns current app environment.
  ///
  /// If no environment is set default would be `Environment.PROD`
  ///
  static Environment getAppEnvironment() {
    //     await _localCacheInterface.getAppEnvironment() ?? "";

    switch (appEnvironment) {
      case "STAGE":
        return Environment.STAGE;
      case "SERVERSTAGE":
        return Environment.SERVERSTAGE;
      default:
        return Environment.PROD;
    }
  }

  static String getUpdateServerEnvironment() {
    switch (getAppEnvironment()) {
      case Environment.PROD:
        return 'https://hr.optimasoft.ir/assets/app/android_version.json';
      default:
        return 'https://hr.optimasoft.ir/assets/${appEnvironment.toLowerCase()}App/android_version.json';
    }
  }

  ///
  /// Returns currently configured app front end domain.
  /// If any custom domain exists it will be returned instead.
  ///
  static Future<String> getCurrentServer() async {
    String customDomain = await _localCacheInterface.getCustomFrontend() ?? "";

    // custom domain is returned if exist otherwise last app environment
    if (!StringHelper.isEmptyOrNull(customDomain)) {
      return customDomain;
    }
    String? res;
    Environment appEnvironment = getAppEnvironment();
    switch (appEnvironment) {
      case Environment.STAGE:
        res = PWAServers.STAGE;
        break;
      case Environment.SERVERSTAGE:
        res = PWAServers.SERVERSTAGE;
        break;
      default:
        res = PWAServers.PRODUCTION;
        break;
    }

    var tenant = await SharedPreferenceService().getTenant();
    var tld = await SharedPreferenceService().getTLD();
    res = res.replaceAll(tenantTag, tenant).replaceAll(TldTag, tld);

    return res;
  }

  ///
  /// Returns currently configured app back end domain.
  /// If any custom domain exists it will be returned instead.
  ///
  static Future<String> getCurrentBackend() async {
    String customDomain = await _localCacheInterface.getCustomBackend() ?? "";

    // custom domain is returned if exist otherwise last app environment
    if (!StringHelper.isEmptyOrNull(customDomain)) {
      return customDomain;
    }

    Environment appEnvironment = getAppEnvironment();
    String? res;

    switch (appEnvironment) {
      case Environment.STAGE:
        res = BackendDroplet.STAGE;
        break;
      case Environment.SERVERSTAGE:
        res = BackendDroplet.SERVERSTAGE;
        break;
      default:
        res = BackendDroplet.PRODUCTION;
        break;
    }

    var tenant = await SharedPreferenceService().getTenant();
    var tld = await SharedPreferenceService().getTLD();
    res = res.replaceAll(tenantTag, tenant).replaceAll(TldTag, tld);

    return res;
  }

  ///
  /// Sets custom fronend url to user shared preferences.
  ///
  static Future<void> setCustomFrontEnd(String customFrontEnd) async {
    await _localCacheInterface.setCustomFrontend(customFrontEnd);
  }

  ///
  /// Sets custom backend url to user shared preferences.
  ///
  static Future<void> setCustomBackEnd(String customBackEnd) async {
    await _localCacheInterface.setCustomBackend(customBackEnd);
  }

  static Future<String> backendUrlFromEndpoint(String endpoint) async {
    return await getCurrentBackend() + endpoint;
  }
}

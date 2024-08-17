import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get_it/get_it.dart';
import 'package:localization/localization.dart';
import 'package:optima_soft/api/cloud_functions_interface/cloud_functions_interface.dart';
import 'package:optima_soft/api/local_cache_interface/local_cache_interface.dart';
import 'package:optima_soft/helpers/colors.dart';
import 'package:optima_soft/helpers/platform_helper.dart';
import 'package:optima_soft/helpers/routes.dart';
import 'package:optima_soft/modules/login_page/login.dart';
import 'package:optima_soft/modules/webview_screen/web_view_bloc.dart';
import 'package:optima_soft/modules/webview_screen/web_view_screen.dart';
import 'package:optima_soft/services/context_builder.dart';
import 'package:optima_soft/services/full-mission-permission.dart';
import 'package:optima_soft/services/navigation_service.dart';
import 'package:optima_soft/services/rx-dart-subject.dart';
import 'package:optima_soft/services/shared-preference-service.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'firebase_options.dart';

Future<void> main() async {
  setupAppDependencies();
  setupFireBase();

  WidgetsFlutterBinding.ensureInitialized();

  await initialLoginData();

  runApp(Phoenix(child: const InitialApp()));
  // runApp(const ExampleApp());
  FlutterForegroundTask.setOnLockScreenVisibility(false);
}

class InitialApp extends StatefulWidget {
  const InitialApp({Key? key}) : super(key: key);

  @override
  State<InitialApp> createState() => InitialAppState();

  static InitialAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<InitialAppState>();
}

class InitialAppState extends State<InitialApp> {
  Locale? _locale;

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['lib/i18n'];
    return FutureBuilder<bool>(
      future: SharedPreferenceService().getLoginStatus(),
      builder: (_, isLogin) => FutureBuilder<String>(
        future: SharedPreferenceService().getTenant(),
        builder: (_, tenantName) => FutureBuilder<String?>(
          future: initUniLinks(),
          builder: (context, lang) {
            if (lang.data != null) {
              _locale ??= Locale.fromSubtags(
                  languageCode: lang.data!.split("_")[0],
                  countryCode: lang.data!.split("_")[1]);
            }
            return MaterialApp(
              locale: _locale,
              supportedLocales: const [Locale('en', 'US'), Locale('fa', 'IR')],
              localizationsDelegates: [
                // delegate from flutter_localization
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                // delegate from localization package.
                LocalJsonLocalization.delegate,
              ],
              localeResolutionCallback: (locale, supportedLocales) {
                if (supportedLocales.contains(locale)) {
                  return locale;
                }
                // define pt_BR as default when de language code is 'pt'
                if (locale?.languageCode == 'fa') {
                  return const Locale('fa', 'IR');
                }

                // default language
                return const Locale('en', 'US');
              },
              title: (tenantName.data == "")
                  ? "Optimasoft"
                  : (tenantName.data ?? ""),
              builder: EasyLoading.init(),
              initialRoute: (isLogin.data != true) ? '/login' : '/app',
              routes: {
                // When navigating to the "/" route, build the FirstScreen widget.
                '/login': (context) {
                  return const Login();
                },
                // When navigating to the "/second" route, build the SecondScreen widget.
                '/app': (context) {
                  return const Payroll();
                },
              },
            );
          },
        ),
      ),
    );
  }
}

class Payroll extends StatelessWidget {
  const Payroll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ContextBuilderSaver().create(context);
    getMissionPermission(context);
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);
    void _onRefresh() async {
      // monitor network fetch
      await Future.delayed(Duration(milliseconds: 1000));
      // if failed,use refreshFailed()
      RxDartSubjectService().callReloadPage();
      _refreshController.refreshCompleted();
    }

    // void _onLoading() async {
    //   // monitor network fetch
    //   await Future.delayed(Duration(milliseconds: 1000));
    //   // if failed,use loadFailed(),if no data return,use LoadNodata()

    //   _refreshController.loadComplete();
    // }

    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.white),
        primaryColor: darkGrey,
        backgroundColor: doctorWhite,
        textTheme: const TextTheme(
          headline1: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          headline2: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),
        ),
      ),
      navigatorKey: GetIt.instance.get<NavigationService>().navigatorKey,
      initialRoute: Navigator.defaultRouteName,
      routes: {
        Navigator.defaultRouteName: (BuildContext context) {
          return Provider(
              create: (_) => WebViewBloc(),
              child: const WithForegroundTask(child: WebViewScreen()));
        }
      },
      onGenerateRoute: onGenerateRoute,
    );
  }
}

Future<void> setupAppDependencies() async {
  // GetIt getIt = GetIt.instance;
  // getIt.reset();
  // Add navigation service to dependency tree
  await GetIt.instance.reset();
  GetIt.instance.registerSingleton(NavigationService());
  // GetIt.instance.registerSingleton(RxDartSubjectService());

  // Add cloud function interface service to dependency tree
  GetIt.instance.registerFactory(() => CloudFunctionsInterface());

  // Add local cache interface to dependency tree
  GetIt.instance.registerLazySingleton(
    () => LocalCacheInterface(SharedPreferences.getInstance()),
  );
  // EnvironmentHelpers.setAppEnvironment(Environment.STAGE);
  // Add platform helper to dependency tree
  GetIt.instance.registerFactory(() => PlatformHelper());
}

Future<void> setupFireBase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

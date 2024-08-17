import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';
import 'package:optima_soft/helpers/environment_helpers.dart';
import 'package:optima_soft/helpers/js_handler_names.dart';
import 'package:optima_soft/models/get_user_state.dart';
import 'package:optima_soft/models/send_user_password_to_login_form.dart';
import 'package:optima_soft/models/user_mission_status.dart';
import 'package:optima_soft/modules/login_page/login.dart';
import 'package:optima_soft/modules/network_setting_screen/network_setting_bloc.dart';
import 'package:optima_soft/modules/network_setting_screen/network_setting_screen.dart';
import 'package:optima_soft/services/context_builder.dart';
import 'package:optima_soft/services/firebase-messaging.service.dart';
import 'package:optima_soft/services/forground_service.dart';
import 'package:optima_soft/services/full-mission-permission.dart';
import 'package:optima_soft/services/mission-location-service.dart';
import 'package:optima_soft/services/navigation_service.dart';
import 'package:optima_soft/services/rx-dart-subject.dart';
import 'package:optima_soft/services/send_mission_location_handler.dart';
import 'package:optima_soft/services/shared-preference-service.dart';
import 'package:optima_soft/services/updater.server.dart';
import 'package:rxdart/subjects.dart';

enum ViewDialogsAction { yes, no }

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(FirstTaskHandler());
}

class WebViewBloc {
  // ignore: constant_identifier_names
  static const int HIDE_FLOATING_BUTTON_TIMEOUT = 5;
  late String? deeplinkPage;

  WebViewBloc({this.deeplinkPage});

  final NavigationService _navigationService =
      GetIt.instance.get<NavigationService>();

  final BehaviorSubject<bool> _devMenuController =
      BehaviorSubject.seeded(false);
  final BehaviorSubject<bool> _isKeyboardVisibleController =
      BehaviorSubject.seeded(false);

  Stream<bool> get keyboardVisibleStream => _isKeyboardVisibleController.stream;

  Stream<bool> get devMenuStream => _devMenuController.stream;

  Stream<String?> get sendJsMessage =>
      RxDartSubjectService().sendJsMessageSubject.stream;

  Stream<void> get reloadPage =>
      RxDartSubjectService().reloadPageSubject.stream;

  late InAppWebViewController webViewController;

  Future<Uri> get getAppURL async {
    String appURL = await EnvironmentHelpers.getCurrentServer();
    return Uri.parse(appURL);
  }

  UnmodifiableListView<UserScript> get initialUserScripts =>
      UnmodifiableListView<UserScript>([
        UserScript(
            // ignore: prefer_adjacent_string_concatenation
            // ignore: prefer_interpolation_to_compose_strings
            source: "var meta = document.createElement('meta');" +
                "meta.name = 'viewport';" +
                "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
                "var head = document.getElementsByTagName('head')[0];" +
                "head.appendChild(meta);",
            injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END),
      ]);

// webView.getSettings().setDomStorageEnabled(false)
  InAppWebViewGroupOptions get initialOptions => InAppWebViewGroupOptions(
      ios: IOSInAppWebViewOptions(
        maximumZoomScale: 1.0,
        minimumZoomScale: 1.0,
        pageZoom: 1.0,
        alwaysBounceVertical: false,
        allowsInlineMediaPlayback: true,
        alwaysBounceHorizontal: false,
      ),
      crossPlatform: InAppWebViewOptions(
          allowFileAccessFromFileURLs: true,
          cacheEnabled: true,
          allowUniversalAccessFromFileURLs: true,
          useShouldOverrideUrlLoading: true,
          javaScriptEnabled: true,
          supportZoom: true,
          javaScriptCanOpenWindowsAutomatically: true,
          mediaPlaybackRequiresUserGesture: false),
      android: AndroidInAppWebViewOptions(
          domStorageEnabled: true,
          databaseEnabled: true,
          allowFileAccess: true,
          allowContentAccess: true,
          useHybridComposition: true,
          thirdPartyCookiesEnabled: true,
          geolocationEnabled: true));

  //TODO: Should remove this on product launch.
  // Future<ServerTrustAuthResponse> onReceivedServerTrustChallange(
  //     InAppWebViewController controller,
  //     URLAuthenticationChallenge challenge) async {
  //   return ServerTrustAuthResponse(
  //       action: ServerTrustAuthResponseAction.PROCEED);
  // }
  Future<void> onWebViewCreated(InAppWebViewController controller) async {
    sendJsMessage.listen((event) {
      if (event != null) {
        postJSMessageToWeb(event);
      }
    });
    reloadPage.listen((event) {
      reloadAndInvalidateCaches();
    });

    webViewController = controller;

    controller.addJavaScriptHandler(
        handlerName: JSHandlerNames.callFaceID, callback: callFaceIdHandler);

    controller.addJavaScriptHandler(
        handlerName: JSHandlerNames.callFaceIDLogin,
        callback: callFaceIdLoginHandler);

    controller.addJavaScriptHandler(
        handlerName: JSHandlerNames.setClientType, callback: setClientType);

    controller.addJavaScriptHandler(
        handlerName: JSHandlerNames.activeNotification,
        callback: activateNotificationHandler);

    controller.addJavaScriptHandler(
        handlerName: JSHandlerNames.getSafeAreaInset,
        callback: getSafeAreaInsetHandler);

    controller.addJavaScriptHandler(
        handlerName: JSHandlerNames.changeUrl, callback: changeUrlHandler);
    controller.addJavaScriptHandler(
        handlerName: JSHandlerNames.changeMissionStatus,
        callback: changeMissionStatus);

    controller.addJavaScriptHandler(
        handlerName: JSHandlerNames.getLoginInformation,
        callback: getLoginInformation);

    controller.addJavaScriptHandler(
        handlerName: JSHandlerNames.logoutAccount, callback: logoutAccount);

    controller.addJavaScriptHandler(
        handlerName: JSHandlerNames.getHtmlVersion, callback: getHtmlVersion);

    controller.addJavaScriptHandler(
        handlerName: JSHandlerNames.getTimeZone, callback: getTimeZone);

    controller.addJavaScriptHandler(
        handlerName: JSHandlerNames.callSetUsernamePassword,
        callback: callSetUsernamePassword);

    controller.addJavaScriptHandler(
        handlerName: JSHandlerNames.exitFromApp, callback: exitFromApp);

    controller.addJavaScriptHandler(
        handlerName: JSHandlerNames.getStateUser, callback: getStateUser);

    // controller.addJavaScriptHandler(
    //     handlerName: JSHandlerNames.pickBodyPhoto,
    //     callback: pickBodyPhotoHandler);

    // controller.addJavaScriptHandler(
    //     handlerName: JSHandlerNames.showPdf, callback: showPdfHandler);
  }

  void postJSMessageToWeb(String message) {
    webViewController.evaluateJavascript(source: message);
  }

  Future<void> callFaceIdHandler(List<dynamic> arguments) async {
    // try {
    //   var localAuth = LocalAuthentication();

    //   bool didAuthenticate = await localAuth.authenticate(
    //       localizedReason: 'Please authenticate to login without password',
    //       biometricOnly: true);
    //   int result = didAuthenticate ? 1 : 0;

    //   postJSMessageToWeb("getFaceId('$result')");
    // } on PlatformException catch (_) {
    //   postJSMessageToWeb("getFaceId('0')");
    // }
  }

  Future<void> callSetUsernamePassword(List<dynamic> arguments) async {
    loginWithExistUserPass();
  }

  Future<void> exitFromApp(List<dynamic> arguments) async {
    SystemNavigator.pop();
  }

  Future<void> getStateUser(List<dynamic> arguments) async {
    var lastStatusUser = GetUserState.fromJson(arguments.first);
    if (lastStatusUser.type != "PersonTour" ||
        (lastStatusUser.type == "PersonTour" &&
            lastStatusUser.userState == 2)) {
      callUpdater(true, ContextBuilderSaver().context);
    } else if ((await FlutterForegroundTask.isRunningService) == false) {
      await SharedPreferenceService()
          .saveMissoniId(lastStatusUser.personnelStartEndId ?? 0);
      ForgroundService.startForegroundTask(startCallback);
    }
  }

  bool checkVersionOfApp = false;

  callUpdater(bool mounted, BuildContext context) async {
    if (checkVersionOfApp == true) return;

    checkVersionOfApp = true;
    UpdaterService.checkUpdate(mounted, context);
  }

  Future<void> loginWithExistUserPass() async {
    bool loginStatus = await SharedPreferenceService().getLoginStatus();
    if ((await SharedPreferenceService().getUserName()) != "" &&
        loginStatus == true) {
      var username = await SharedPreferenceService().getUserName();
      var password = await SharedPreferenceService().getPassword();
      SendUserPasswordToLoginForm model =
          SendUserPasswordToLoginForm(username: username, password: password);
      RxDartSubjectService()
          .sendEventData("SetUsernamePassword", model.toJson());
    }
  }

  Future<void> callFaceIdLoginHandler(List<dynamic> arguments) async {
    // try {
    //   var localAuth = LocalAuthentication();

    //   bool didAuthenticate = await localAuth.authenticate(
    //       localizedReason: 'Please authenticate to login without password',
    //       biometricOnly: true);
    //   int result = didAuthenticate ? 1 : 0;

    //   postJSMessageToWeb("faceDetectResult('$result')");
    // } on PlatformException catch (_) {
    //   postJSMessageToWeb("faceDetectResult('0')");
    // }
  }

  // Complete handlers
  void setClientType(List<dynamic> arguments) {
    postJSMessageToWeb("setClientType('${Platform.isAndroid ? 2 : 3}')");
  }

  void activateNotificationHandler(List<dynamic> arguments) {
    if (kDebugMode) {
      print("activate notification");
    }
  }

  void getSafeAreaInsetHandler(List<dynamic> arguments) {}

  void changeUrlHandler(List<dynamic> arguments) {}

  Future<void> changeMissionStatus(List<dynamic> arguments) async {
    var inputItem = UserMissionStatus.fromJson(arguments.first);
    if (inputItem.userState?.toLowerCase() == 'start') {
      await SharedPreferenceService()
          .saveMissoniId(inputItem.personnelStartEndId ?? 0);
      await SharedPreferenceService()
          .saveAlwaysSendLocation(inputItem.alwaysSendLocation ?? false);
      ForgroundService.startForegroundTask(startCallback);

      await getMissionPermission(null);
    } else if (inputItem.userState?.toLowerCase() == 'end') {
      if ((await SharedPreferenceService().getLastLocationSave())
          .isBefore(DateTime.now().add(const Duration(minutes: -10)))) {
        MissionLocationService()
            .sendAllLocationToServerAndClearData(false, true);
      } else {
        MissionLocationService()
            .sendAllLocationToServerAndClearData(false, false);
      }
      ForgroundService.stopForegroundTask();
      await SharedPreferenceService().saveMissoniId(0);
      Location().enableBackgroundMode(enable: false);
    }
  }

  Future<void> getLoginInformation(List<dynamic> arguments) async {
    await SharedPreferenceService().saveLoginAccessData(arguments.first);
    await FirebaseMessagingService().registerUserDevice();
  }

  Future<void> logoutAccount(List<dynamic> arguments) async {
    // var res = await SharedPreferenceService().getLoginAccessData();
    // var password = res?.password;
    // var userName = res?.userName;
    // var model = LoginInformation(userName: userName, password: password);
    // SharedPreferenceService().saveLoginAccessData(model.toJson());
    await SharedPreferenceService().setLoginStatus(false);
    await FirebaseMessagingService().removeRegisterdUserDevice();
    await initialLoginData();
    Navigator.pushReplacementNamed(ContextBuilderSaver().context, "/login");
  }

  Future<void> getHtmlVersion(List<dynamic> arguments) async {
    var oldVersion = await SharedPreferenceService().getHtmlVersion();
    if (json.decode(arguments.first) != oldVersion && oldVersion != "0") {
      SharedPreferenceService().saveHtmlVersion(json.decode(arguments.first));
      reloadAndInvalidateCaches();
    }
  }

  Future<void> getTimeZone(List<dynamic> arguments) async {
    SharedPreferenceService().saveTimeZone(json.decode(arguments.first));
  }

  // void pickBodyPhotoHandler(List<dynamic> arguments) {
  //   PickPhotoModel pickPhotoModel =
  //       PickPhotoModel.fromJson(jsonDecode(arguments.first));
  //   PhotoPickerBloc photoPickerBloc = PhotoPickerBloc(pickPhotoModel,
  //       onPhotoFinishedUploading: pickBodyPhotoFinished);

  //   _navigationService.pushNamed(PhotoPickerScreen.routeName,
  //       arguments: photoPickerBloc);
  // }

  // void pickBodyPhotoFinished(bool success) {
  //   int result = success ? 1 : 0;
  //   postJSMessageToWeb("finishedPickBodyPhoto('$result')");
  // }

  // void showPdfHandler(List<dynamic> arguments) {
  //   String pdfPath = jsonDecode(arguments[0])["path"];
  //   PDFLoaderBloc bloc = PDFLoaderBloc(pdfPath);
  //   _navigationService.pushNamed(PDFLoaderScreen.routeName, arguments: bloc);
  // }

  ///
  /// Reloads webview with the `url` and reset cache if `removeCache` is true.
  ///
  void loadURL(Uri url, {bool removeCache = false}) {
    if (removeCache) {
      webViewController.clearCache();
      webViewController.webStorage.localStorage.clear();
      webViewController.webStorage.sessionStorage.clear();
    }
    webViewController.loadUrl(
      urlRequest: URLRequest(
        url: WebUri.uri(url),
      ),
    );
  }

  void onTapScreen() {
    if (_devMenuController.value == false) {
      _devMenuController.add(true);
    }
    Timer(const Duration(seconds: HIDE_FLOATING_BUTTON_TIMEOUT),
        hideFloatingButtons);
  }

  ///
  /// Clear web view caches and reload the content.
  ///
  void reloadAndInvalidateCaches() async {
    Uri appURL = await getAppURL;
    loadURL(appURL, removeCache: true);
  }

  void hideFloatingButtons() {
    _devMenuController.add(false);
  }

  void showNetworkSetting() {
    hideFloatingButtons();
    _navigationService.pushNamed(NetworkSettingScreen.routeName,
        arguments:
            NetworkSettingBloc(onSettingSelected: reloadAndInvalidateCaches));
  }

  void switchToProdEnvironment() async {
    await EnvironmentHelpers.setAppEnvironment(Environment.PROD);
    reloadAndInvalidateCaches();
    hideFloatingButtons();
  }

  void switchToStageEnvironment() async {
    await EnvironmentHelpers.setAppEnvironment(Environment.STAGE);
    reloadAndInvalidateCaches();
    hideFloatingButtons();
  }

  void didChangeBottomInset(double? bottomInset) {
    final isKeyboardVisible = (bottomInset ?? 0) > 0.0;
    if (isKeyboardVisible != _isKeyboardVisibleController.value) {
      _isKeyboardVisibleController.add(isKeyboardVisible);
    }
  }

  Future<void> loadDeeplinkIfExist() async {
    if (deeplinkPage != null) {
      webViewController.stopLoading();
      await Future.delayed(const Duration(seconds: 1), () {
        loadURL(Uri.parse(deeplinkPage ?? ""));
        deeplinkPage = null;
      });
    }
  }

  void dispose() {
    _devMenuController.close();
    _isKeyboardVisibleController.close();
    // _endMissionController.close();
  }

  Future<T?> showDialog<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
  }) {
    assert(builder != null);
    assert(barrierDismissible != null);
    assert(useSafeArea != null);
    assert(useRootNavigator != null);
    assert(debugCheckHasMaterialLocalizations(context));

    final CapturedThemes themes = InheritedTheme.capture(
      from: context,
      to: Navigator.of(
        context,
        rootNavigator: useRootNavigator,
      ).context,
    );

    return Navigator.of(context, rootNavigator: useRootNavigator)
        .push<T>(DialogRoute<T>(
      context: context,
      builder: builder,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      settings: routeSettings,
      themes: themes,
      anchorPoint: anchorPoint,
    ));
  }

  Future<GeolocationPermissionShowPromptResponse> javascriptLocationPermission(
      InAppWebViewController callback, String origin) async {
    return GeolocationPermissionShowPromptResponse(
        origin: origin, allow: true, retain: true);
  }
}

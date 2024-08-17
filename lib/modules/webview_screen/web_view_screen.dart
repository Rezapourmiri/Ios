import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:optima_soft/helpers/platform_helper.dart';
import 'package:optima_soft/modules/webview_screen/web_view_bloc.dart';
import 'package:optima_soft/services/firebase-messaging.service.dart';
import 'package:optima_soft/services/forground_service.dart';
import 'package:optima_soft/services/mission-location-service.dart';
import 'package:optima_soft/services/rx-dart-subject.dart';
import 'package:optima_soft/services/shared-preference-service.dart';
import 'package:optima_soft/widgets/floating_button.dart';
import 'package:optima_soft/widgets/splash_screen.dart';
import 'package:provider/provider.dart';

class WebViewScreen extends StatefulWidget {
  static const String routeName = "/WebViewScreen";

  const WebViewScreen({Key? key}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen>
    with WidgetsBindingObserver {
  // @override
  // Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
  //   await SharedPreferenceService().saveAppStatus(state);
  // }

  late WebViewBloc _bloc;
  bool isSplashScreenVisible = false;

  final GlobalKey webViewKey = GlobalKey();

  late InAppWebViewController webViewController;

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();
  T? _ambiguate<T>(T? value) => value;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ForgroundService.initForegroundTask();
    _ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) async {
      // You can get the previous ReceivePort without restarting the service.
      if (await FlutterForegroundTask.isRunningService) {
        final newReceivePort = await FlutterForegroundTask.receivePort;
        ForgroundService.registerReceivePort(newReceivePort);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = Provider.of(context);
    _bloc.loadDeeplinkIfExist();
  }

  @override
  void didChangeMetrics() {
    setState(() {
      final double bottomInset =
          WidgetsBinding.instance.window.viewInsets.bottom;
      _bloc.didChangeBottomInset(bottomInset);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: webViewKey,
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(children: <Widget>[
        Expanded(
            child: SizedBox(
                height: PlatformHelper.screenHeight,
                child: GestureDetector(
                  child: FutureBuilder(
                      future: _bloc.getAppURL,
                      builder: (_, AsyncSnapshot<Uri> snapshot) {
                        if (snapshot.hasData) {
                          return Stack(
                            children: [
                              _buildWebView(snapshot.data),
                              _buildSplashView(),
                              _buildDevMenu(snapshot.data.toString())
                            ],
                          );
                        } else {
                          return Stack(
                            children: [
                              Container(),
                              _buildSplashView(),
                              _buildDevMenu("empty")
                            ],
                          );
                        }
                      }),
                ))),
      ])),
    );
  }

  Future<bool> _backWebview() async {
    RxDartSubjectService().sendEventData("backPageCommand", true);
    return false;
  }

  bool runLoadStopBeforeStart = false;

  Widget _buildWebView(Uri? initialURI) {
    return WillPopScope(
      onWillPop: _backWebview,
      child: SafeArea(
        child: InAppWebView(
          initialUserScripts: _bloc.initialUserScripts,
          initialUrlRequest: URLRequest(url: WebUri.uri(initialURI!)),
          initialOptions: _bloc.initialOptions,
          onWebViewCreated: _bloc.onWebViewCreated,
          androidOnGeolocationPermissionsShowPrompt:
              _bloc.javascriptLocationPermission,
          onLoadStart:
              (InAppWebViewController controller, Uri? loadedResource) async {
            Uri? loadingURL = await controller.getUrl();
            if (kDebugMode) {
              print("load start $loadingURL");
            }

            if (!runLoadStopBeforeStart) {
              showSplashView();
            }
          },
          onLoadStop:
              (InAppWebViewController controller, Uri? loadedResource) async {
            if (kDebugMode) {
              print("load stop");
            }
            runLoadStopBeforeStart = true;
            hideSplashView();
            _afterloadActions();
          },
          onConsoleMessage: (controller, consoleMessage) {
            if (kDebugMode) {
              print(consoleMessage);
            }
          },
          onLoadHttpError: (InAppWebViewController controller, Uri? url,
              int statusCode, String description) async {
            if (kDebugMode) {
              print(
                  "onLoadHttpError statusCode: $statusCode and description: $description");
            }
          },
          onLoadError: (InAppWebViewController controller, Uri? url, int code,
              String message) async {},
        ),
      ),
    );
  }

  bool runAfterloadActions = false;
  Future<void> _afterloadActions() async {
    if (runAfterloadActions) {
      return;
    }
    runAfterloadActions = true;

    RxDartSubjectService()
        .sendJsMessageSubject
        .add("setClientType('${Platform.isAndroid ? 2 : 1}')");
    RxDartSubjectService()
        .sendJsMessageSubject
        .add("getRequiredForInitialData()");
    MissionLocationService().sendAllLocationToServerAndClearData(true, false);
    if ((await SharedPreferenceService().getToken()) != "") {
      await FirebaseMessagingService().registerUserDevice();
    }
    FirebaseMessagingService().reciveMessage();
  }

  void showSplashView() {
    setState(() {
      isSplashScreenVisible = true;
    });
  }

  void hideSplashView() {
    setState(() {
      isSplashScreenVisible = false;
    });
  }

  Widget _buildSplashView() {
    return Visibility(
        visible: isSplashScreenVisible, child: const SplashScreen());
  }

  Widget _buildDevMenu(String appDomain) {
    return SafeArea(
      child: StreamBuilder(
        stream: _bloc.devMenuStream,
        builder: (_, AsyncSnapshot<bool> snapshot) {
          bool isVisible = snapshot.hasData ? (snapshot.data ?? false) : false;
          return IgnorePointer(
            ignoring: !isVisible,
            child: AnimatedOpacity(
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 500),
              opacity: isVisible ? 1.0 : 0.0,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: PlatformHelper.screenWidth * 0.05,
                    vertical: PlatformHelper.screenHeight * 0.02),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingButton(Icons.settings, onDevSettingPressed),
                      Expanded(
                        child: Text(
                          appDomain,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      FloatingButton(Icons.refresh_rounded, onRefreshPressed)
                    ]),
              ),
            ),
          );
        },
      ),
    );
  }

  void onDevSettingPressed() {
    showCupertinoModalPopup(
      barrierColor: Colors.black38,
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text("Change Server Setting"),
          message:
              const Text("Choose server configuration from options below:"),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text("Prod"),
              onPressed: () {
                Navigator.pop(context);
                _bloc.switchToProdEnvironment();
              },
            ),
            CupertinoActionSheetAction(
              child: const Text("Stage"),
              onPressed: () {
                Navigator.pop(context);
                _bloc.switchToStageEnvironment();
              },
            ),
            CupertinoActionSheetAction(
              child: const Text("More"),
              onPressed: () {
                Navigator.pop(context);
                _bloc.showNetworkSetting();
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
              _bloc.hideFloatingButtons();
            },
          )),
    );
  }

  void onRefreshPressed() {
    showCupertinoModalPopup(
      barrierColor: Colors.black38,
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text("Reload app content"),
          message: const Text("Are you sure you want to reload app content?"),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text("Reload"),
              onPressed: () {
                Navigator.pop(context);
                _bloc.reloadAndInvalidateCaches();
                _bloc.hideFloatingButtons();
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              _bloc.hideFloatingButtons();
            },
            child: const Text("Cancel"),
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }
}

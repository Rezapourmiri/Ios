import 'package:flutter/material.dart';

class NavigationService {
  late GlobalKey<NavigatorState> navigatorKey;

  static final NavigationService _singleton = NavigationService._internal();

  NavigationService._internal() {
    navigatorKey = GlobalKey<NavigatorState>();
  }

  factory NavigationService() {
    return _singleton;
  }
  BuildContext? getNavigatorContext() {
    return navigatorKey.currentContext;
  }

  BuildContext? getOverlayContext() {
    return navigatorKey.currentState?.overlay?.context;
  }

  OverlayState? get overlayState => navigatorKey.currentState?.overlay;

  ///
  /// Push a new screen into the stack with a given `routeName`
  ///
  Future<dynamic>? pushNamed(String routeName, {Object? arguments}) {
    debugPrint("push named route:$routeName");
    return navigatorKey.currentState
        ?.pushNamed(routeName, arguments: arguments);
  }

  void popToFirstScreen() {
    navigatorKey.currentState?.popUntil((route) {
      debugPrint("poping route " + route.toString());
      return route.isFirst;
    });
  }

  /// Pops a single screen
  void pop<T extends Object>([T? result]) {
    navigatorKey.currentState?.pop(result);
  }
}

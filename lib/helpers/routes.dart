import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:optima_soft/modules/network_setting_screen/network_setting_bloc.dart';
import 'package:optima_soft/modules/network_setting_screen/network_setting_screen.dart';
import 'package:optima_soft/modules/webview_screen/web_view_bloc.dart';
import 'package:optima_soft/modules/webview_screen/web_view_screen.dart';

///
/// Generates navigation routes for given route name.
///
/// This method is not used directly and is passed to `MaterialApp onGenerateRoute` method.
///
Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case NetworkSettingScreen.routeName:
      return getNetworkSettingScreen(settings);
    // case PDFLoaderScreen.routeName:
    //   return getPDFLoaderScreen(settings);
    // case PhotoPickerScreen.routeName:
    //   return getPhotoPickerScreen(settings);
    // case CameraCaptureScreen.routeName:
    //   return getCameraCaptureScreen(settings);
    default:
      return handleOtherScenarios(settings);
  }
}

Route<dynamic>? handleOtherScenarios(RouteSettings settings) {
  var uri = Uri.parse(settings.name ?? "");
  // print(settings.name);
  // print(uri.pathSegments);
  //TODO: Complete scenario when backend and frontend is finished respective tasks.
  if (uri.pathSegments.isNotEmpty) {
    WebViewBloc bloc = WebViewBloc(deeplinkPage: "https://google.com");
    return MaterialPageRoute(
        settings: const RouteSettings(name: WebViewScreen.routeName),
        builder: (_) {
          return Provider(
            create: (_) => bloc,
            child: const WebViewScreen(),
          );
        });
  }
  return null;
}

PageRouteBuilder getNetworkSettingScreen(RouteSettings settings) {
  return PageRouteBuilder(
    settings: const RouteSettings(name: NetworkSettingScreen.routeName),
    pageBuilder: (_, __, ___) {
      return Provider(
        create: (_) => settings.arguments as NetworkSettingBloc,
        child: const NetworkSettingScreen(),
      );
    },
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(scale: animation, child: child),
      );
    },
  );
}

// CupertinoModalPopupRoute getPDFLoaderScreen(RouteSettings settings) {
//   return CupertinoModalPopupRoute(
//       settings: RouteSettings(name: PDFLoaderScreen.routeName),
//       builder: (_) {
//         return Provider(
//           create: (_) => settings.arguments as PDFLoaderBloc,
//           child: PDFLoaderScreen(),
//         );
//       });
// }

// CupertinoModalPopupRoute getPhotoPickerScreen(RouteSettings settings) {
//   return CupertinoModalPopupRoute(
//       settings: const RouteSettings(name: PhotoPickerScreen.routeName),
//       builder: (_) {
//         return Provider(
//           create: (_) => settings.arguments as PhotoPickerBloc,
//           child: const PhotoPickerScreen(),
//         );
//       });
// }

// MaterialPageRoute getCameraCaptureScreen(RouteSettings settings) {
//   return MaterialPageRoute(
//       settings: const RouteSettings(name: CameraCaptureScreen.routeName),
//       builder: (_) {
//         return Provider(
//           create: (_) => settings.arguments as CameraCaptureBloc,
//           child: const CameraCaptureScreen(),
//         );
//       });
// }

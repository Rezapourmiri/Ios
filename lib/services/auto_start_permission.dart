import 'dart:async';

import 'package:flutter/services.dart';

///initial AutoStart Class
const MethodChannel _channel =
    MethodChannel('activity/optima_soft');

/// It checks if the phone has auto-start function.
Future<bool?> get isAutoStartAvailable async {
  ///check availability
  //auto start availability
  final bool? isAutoStartAvailable =
      await _channel.invokeMethod('isAutoStartPermission');
  return isAutoStartAvailable;
}

Future<int?> get getBatteryLevel async {
  final int getBatteryLevel = await _channel.invokeMethod('getBatteryLevel');
  return getBatteryLevel;
}

Future<String?> customSetComponent(
    {String? manufacturer, String? pkg, String? cls}) async {
  try {
    String? result = await _channel.invokeMethod(
        'customSetComponent', <String, dynamic>{
      "manufacturer": manufacturer,
      "pkg": pkg,
      "cls": cls
    });
    return result;
  } on PlatformException catch (e) {
    return e.toString();
  }
}

///It navigates to settings => auto-start option where users can manually enable auto-start. It's not possible to check if user has turned on this option or not.
Future<void> getAutoStartPermission() async {
  try {
    await _channel.invokeMethod("permit-auto-start");
  } catch (e) {
    print(e);
  }
}

Future<void> goToXiaomiOtherPermissions() async {
  try {
    await _channel.invokeMethod("goToXiaomiOtherPermissions");
  } catch (e) {
    print(e);
  }
}

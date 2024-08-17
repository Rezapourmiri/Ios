// ignore_for_file: file_names

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localization/localization.dart';
import 'package:location/location.dart';
import 'package:optima_soft/services/auto_start_permission.dart';
import 'package:optima_soft/services/context_builder.dart';
import 'package:permission_handler/permission_handler.dart';

import '../modules/webview_screen/web_view_bloc.dart';

Future<void> getMissionPermission(BuildContext? inputContext) async {
  inputContext = inputContext ?? ContextBuilderSaver().context;
  if (Platform.isAndroid) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    var autostartPer = await isAutoStartAvailable;
    if (await FlutterForegroundTask.canDrawOverlays == false &&
        autostartPer == true &&
        androidInfo.manufacturer.toLowerCase() == "xiaomi") {
      allowAutoStartDialog(BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text("allowAutoStart".i18n()),
          content: Text("allowAutoStartMessage".i18n()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(ViewDialogsAction.no),
              child: Text("Reject".i18n()),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(ViewDialogsAction.yes),
              child: Text(
                "OK".i18n(),
                style: const TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        );
      }

      final res = await showDialog<ViewDialogsAction>(
          context: inputContext!, builder: allowAutoStartDialog);
      if ((res ?? ViewDialogsAction.no) == ViewDialogsAction.yes) {
        await getAutoStartPermission();
      }
    }

    if (await FlutterForegroundTask.canDrawOverlays == false &&
        androidInfo.manufacturer.toLowerCase() == "xiaomi") {
      allowCanDrawOverlaysDialog(BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text("allowCanDrawOverlay".i18n()),
          content: Text("allowCanDrawOverlayMessage".i18n()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(ViewDialogsAction.no),
              child: Text("Reject".i18n()),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(ViewDialogsAction.yes),
              child: Text(
                "OK".i18n(),
                style: const TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        );
      }

      final res = await showDialog<ViewDialogsAction>(
          context: inputContext!, builder: allowCanDrawOverlaysDialog);
      if ((res ?? ViewDialogsAction.no) == ViewDialogsAction.yes) {
        await goToXiaomiOtherPermissions();
      }
    } else if (await FlutterForegroundTask.canDrawOverlays == false) {
      await FlutterForegroundTask.openSystemAlertWindowSettings();
    }
  }
  if (await FlutterForegroundTask.isIgnoringBatteryOptimizations == false) {
    // await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    appIgnoringBatteryOptimizationDialog(BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text("BatteryOptimization".i18n()),
        content: Text("BatteryOptimizationMessage".i18n()),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(ViewDialogsAction.no),
            child: Text("Reject".i18n()),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(ViewDialogsAction.yes),
            child: Text(
              "OK".i18n(),
              style: const TextStyle(
                color: Colors.blueAccent,
              ),
            ),
          ),
        ],
      );
    }

    if (await FlutterForegroundTask.isIgnoringBatteryOptimizations == false) {
      final res = await showDialog<ViewDialogsAction>(
          context: inputContext!,
          builder: appIgnoringBatteryOptimizationDialog);
      if ((res ?? ViewDialogsAction.no) == ViewDialogsAction.yes) {
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
        Future.delayed(
            const Duration(seconds: 2),
            () async => {
                  if (await FlutterForegroundTask
                          .isIgnoringBatteryOptimizations ==
                      false)
                    {
                      await FlutterForegroundTask
                          .openIgnoreBatteryOptimizationSettings()
                    }
                });
      }
    }
  }

  await getFlutterLocationPermission(inputContext!);

  Location location = Location();
  var permission = await Geolocator.checkPermission();
  await Location().enableBackgroundMode(enable: true);
  if (await location.isBackgroundModeEnabled() ||
      permission != LocationPermission.always) {
    //dialog message
    appLocationServiceDialog(BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text("BackgroundLocationRequest".i18n()),
        content: Text("BackgroundLocationRequestMessage".i18n()),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(ViewDialogsAction.no),
            child: Text("Reject".i18n()),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(ViewDialogsAction.yes),
            child: Text(
              "OK".i18n(),
              style: const TextStyle(
                color: Colors.blueAccent,
              ),
            ),
          ),
        ],
      );
    }

    //dialog message
    // await Geolocator.openLocationSettings();
    if (!await location.isBackgroundModeEnabled() ||
        permission != LocationPermission.always) {
      final res = await showDialog<ViewDialogsAction>(
          context: inputContext!, builder: appLocationServiceDialog);
      if ((res ?? ViewDialogsAction.no) == ViewDialogsAction.yes) {
        try {
          await Location().enableBackgroundMode(enable: true);
          await Location().enableBackgroundMode(enable: false);
        } catch (err) {
          if (!await location.isBackgroundModeEnabled() ||
              await Geolocator.checkPermission() != LocationPermission.always) {
            Geolocator.openAppSettings();
          }
        }
      }
    } else {
      await location.enableBackgroundMode(enable: true);
      await location.enableBackgroundMode(enable: false);
    }
  }
}

Future<void> getFlutterLocationPermission(BuildContext? inputContext) async {
  bool serviceEnabled;
  LocationPermission permission;
  inputContext = inputContext ?? ContextBuilderSaver().context;
  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.

    locationServiceDialog(BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text("allowLocation".i18n()),
        content: Text("LocationRequestMessage".i18n()),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(ViewDialogsAction.no),
            child: Text("Reject".i18n()),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(ViewDialogsAction.yes),
            child: Text(
              "Gotoappsetting".i18n(),
              style: const TextStyle(
                color: Colors.blueAccent,
              ),
            ),
          ),
        ],
      );
    }

    final res = await showDialog<ViewDialogsAction>(
        context: inputContext!, builder: locationServiceDialog);
    if ((res ?? ViewDialogsAction.no) == ViewDialogsAction.yes) {
      await Geolocator.openLocationSettings();
    } else {
      SystemNavigator.pop();
    }
  }

  // permission = await Geolocator.requestPermission();

  appLocationServiceDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text("allowLocation".i18n()),
      content: Text("LocationRequestMessage".i18n()),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(ViewDialogsAction.no),
          child: Text("Reject".i18n()),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(ViewDialogsAction.yes),
          child: Text(
            "Gotoappsetting".i18n(),
            style: const TextStyle(
              color: Colors.blueAccent,
            ),
          ),
        ),
      ],
    );
  }

  try {
    permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      await Geolocator.requestPermission();
      final res = await showDialog<ViewDialogsAction>(
          context: inputContext!, builder: appLocationServiceDialog);
      if ((res ?? ViewDialogsAction.no) == ViewDialogsAction.yes) {
        if (await Geolocator.checkPermission() != LocationPermission.always) {
          bool res = await openAppSettings();
        }
      }
    }
  } catch (e) {
    permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.always &&
        permission != LocationPermission.whileInUse) {
      final res = await showDialog<ViewDialogsAction>(
          context: inputContext!, builder: appLocationServiceDialog);
      if ((res ?? ViewDialogsAction.no) == ViewDialogsAction.yes) {
        await Geolocator.openAppSettings();
        if (await Geolocator.checkPermission() != LocationPermission.always) {
          bool res = await openAppSettings();
        }
      }
    }
  }
}

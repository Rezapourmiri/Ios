import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:localization/localization.dart';
import 'package:optima_soft/models/set_state_input.dart';
import 'package:optima_soft/services/rx-dart-subject.dart';

class ForgroundService {
  static ReceivePort? _receivePort;
  static Future<void> initForegroundTask() async {
    FlutterForegroundTask.init(
        androidNotificationOptions: AndroidNotificationOptions(
          channelId: 'notification_channel_id',
          channelName: 'Foreground Notification',
          visibility: NotificationVisibility.VISIBILITY_SECRET,
          channelDescription:
              'This notification appears when the foreground service is running.',
          channelImportance: NotificationChannelImportance.LOW,
          priority: NotificationPriority.LOW,
          iconData: const NotificationIconData(
            resType: ResourceType.drawable,
            resPrefix: ResourcePrefix.img,
            name: 'icon',
          ),
          buttons: [
            NotificationButton(id: 'exitButton', text: 'exitButton'.i18n()),
            NotificationButton(id: 'EndMission', text: 'EndMission'.i18n()),
          ],
        ),
        iosNotificationOptions: const IOSNotificationOptions(
          showNotification: true,
          playSound: false,
        ),
        foregroundTaskOptions: const ForegroundTaskOptions(
          interval: 5000,
          isOnceEvent: false,
          autoRunOnBoot: true,
          allowWakeLock: true,
          allowWifiLock: true,
        ));
  }

  static Future<bool> startForegroundTask(Function startCallback) async {
    // Register the receivePort before starting the service.
    final ReceivePort? receivePort = FlutterForegroundTask.receivePort;
    final bool isRegistered = registerReceivePort(receivePort);
    if (!isRegistered) {
      print('Failed to register receivePort!');
      return false;
    }

    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        notificationTitle: 'Mission'.i18n(),
        notificationText: 'MissionLocationIsRunning'.i18n(),
        callback: startCallback,
      );
    }
  }

  static bool registerReceivePort(ReceivePort? newReceivePort) {
    if (newReceivePort == null) {
      return false;
    }

    _closeReceivePort();

    _receivePort = newReceivePort;
    _receivePort?.listen((message) {
      if (message == "EndMission" || message == "exitButton") {
        SetStateInput model = SetStateInput(state: "2", type: "PersonTour");
        RxDartSubjectService()
            .sendEventData("SetNewStateFromFlutter", model.toJson());
      }
      if (message == "exitButton") {
        SystemNavigator.pop();
      }
    });

    return _receivePort != null;
  }

  static void _closeReceivePort() {
    _receivePort?.close();
    _receivePort = null;
  }

  static Future<bool> stopForegroundTask() async {
    return await FlutterForegroundTask.stopService();
  }
}

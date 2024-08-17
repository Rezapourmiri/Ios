import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:optima_soft/helpers/environment_helpers.dart';
import 'package:optima_soft/models/register_user_device.dart';
import 'package:optima_soft/services/http-service.dart';
import 'package:optima_soft/services/rx-dart-subject.dart';
import 'package:optima_soft/services/shared-preference-service.dart';

class FirebaseMessagingService {
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();

  factory FirebaseMessagingService() {
    return _instance;
  }

  FirebaseMessagingService._internal();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<String?> _requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
    return await FirebaseMessaging.instance.getToken();
  }

  Future<void> registerUserDevice() async {
    var firebaseToken = await _requestPermission();
    SharedPreferenceService().saveFirebaseToken(firebaseToken ?? "");
    RegisterUserDevice data = RegisterUserDevice(
        deviceToken: firebaseToken, deviceType: Platform.isAndroid ? "2" : "1");
    HttpService().postData(
        "${await EnvironmentHelpers.getCurrentBackend()}/api/Notification/registerUserDevice",
        data.toMap(),
        null,
        false);
  }

  Future<void> removeRegisterdUserDevice() async {
    var token = await SharedPreferenceService().getFirebaseToken();
    RegisterUserDevice data = RegisterUserDevice(
        deviceToken: token, deviceType: Platform.isAndroid ? "2" : "1");
    HttpService().postData(
        "${await EnvironmentHelpers.getCurrentBackend()}/api/Notification/removeUserDevice",
        data.toMap(),
        null,
        false);
  }

  void reciveMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      // print('Message data: ${message.data}');
      RxDartSubjectService()
          .sendEventData("SendInAppNotification", message.data);

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }
}

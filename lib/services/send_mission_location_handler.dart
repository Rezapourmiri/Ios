import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:location/location.dart' as loc;
import 'package:optima_soft/api/local_cache_interface/local_cache_interface.dart';
import 'package:optima_soft/helpers/environment_helpers.dart';
import 'package:optima_soft/models/mission_location_model.dart';
import 'package:optima_soft/models/set_state_input.dart';
import 'package:optima_soft/models/set_state_output.dart';
import 'package:optima_soft/services/database_crud_service.dart';
import 'package:optima_soft/services/forground_service.dart';
import 'package:optima_soft/services/http-service.dart';
import 'package:optima_soft/services/mission-location-service.dart';
import 'package:optima_soft/services/shared-preference-service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstTaskHandler extends TaskHandler {
  StreamSubscription<Position>? streamSubscription;

  SendPort? _sendPort;
  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;
    if (!GetIt.instance.isRegistered<LocalCacheInterface>()) {
      GetIt.instance.registerLazySingleton(
          () => LocalCacheInterface(SharedPreferences.getInstance()));
    }
    late LocationSettings locationSettings;
    String? intervalDurationTime = await SharedPreferenceService()
        .getSetting("InMissionSendLocationIntervalMin");
    int intervalInt = int.parse(intervalDurationTime ?? "1") * 50;
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
        forceLocationManager: true,
        // forceLocationManager: true,
        // intervalInt * 60
        // intervalDuration: Duration(minutes: intervalInt),
        intervalDuration: Duration(seconds: intervalInt),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
          pauseLocationUpdatesAutomatically: false,
          allowBackgroundLocationUpdates: true,
          showBackgroundLocationIndicator: true);
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      );
    }

    final positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings);
    streamSubscription = positionStream.listen((event) async {
      // Update notification content.
      // FlutterForegroundTask.updateService(
      //     notificationTitle: 'Mission location report',
      //     notificationText: 'Mission name');
      // notificationText: '${event.latitude}, ${event.longitude}');

      DatabaseCrudService databaseCrudService = DatabaseCrudService();
      MissionLocation item = MissionLocation(
          await SharedPreferenceService().getMissoniId(),
          event.latitude,
          event.longitude,
          event.speed * 3.6);
      await databaseCrudService.saveMissoinLocation(item);

      // ignore: non_constant_identifier_names
      final List<AddressCheckOptions> DEFAULTADDRESSES =
          List<AddressCheckOptions>.unmodifiable(
        <AddressCheckOptions>[
          AddressCheckOptions(
            port: 80,
            hostname: (await EnvironmentHelpers.getCurrentServer())
                .split("//")[1]
                .split("/")[0],
          )
        ],
      );

      var conn =
          InternetConnectionChecker.createInstance(addresses: DEFAULTADDRESSES);

      var hasConnection = await conn.hasConnection;
      if (hasConnection) {
        MissionLocationService()
            .sendAllLocationToServerAndClearData(false, false);
      }
      await SharedPreferenceService().saveLastLocationSave();
    });
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    loc.Location().enableBackgroundMode(enable: false);
    await streamSubscription?.cancel();
  }

  @override
  Future<void> onButtonPressed(String id) async {
    if (id == "EndMission") {
      await stopForeground(true);
    }
    if (id == "exitButton") {
      await stopForeground(false);
    }

    // Called when the notification button on the Android platform is pressed.
  }

  Future<void> stopForeground(bool sendEndMission) async {
    var res = await _sendFinishMission();
    var personTourId =
        SetStateOutput.fromJson(res?.body ?? "").personnelStartEndId;
    var userState = SetStateOutput.fromJson(res?.body ?? "").userState;
    if (res?.statusCode == 200 ||
        (personTourId.toString() == "0" && userState == "0")) {
      await _actionsAfterFinishMission();
      if (sendEndMission == true) {
        _sendPort?.send("EndMission");
      }
      if (sendEndMission == false) {
        _sendPort?.send("exitButton");
      }
      ForgroundService.stopForegroundTask();
    }
  }

  Future _actionsAfterFinishMission() async {
    if ((await SharedPreferenceService().getLastLocationSave())
        .isBefore(DateTime.now().add(const Duration(minutes: -10)))) {
      MissionLocationService().sendAllLocationToServerAndClearData(false, true);
    } else {
      MissionLocationService()
          .sendAllLocationToServerAndClearData(false, false);
    }
    await SharedPreferenceService().saveMissoniId(0);
    loc.Location().enableBackgroundMode(enable: false);
    await streamSubscription?.cancel();
  }

  Future<Response?> _sendFinishMission() async {
    SetStateInput data = SetStateInput(type: "PersonTour", state: "End");
    final String url = await EnvironmentHelpers.getCurrentBackend();
    var response = await HttpService().postData(
        "$url/api/PersonnelEnterExit/SetState", data.toMap(), null, false);

    return response;
  }
}

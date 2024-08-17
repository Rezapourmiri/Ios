import 'dart:convert';

import 'package:optima_soft/helpers/environment_helpers.dart';
import 'package:optima_soft/services/database_crud_service.dart';
import 'package:optima_soft/services/http-service.dart';

class MissionLocationService {
  static final MissionLocationService _instance =
      MissionLocationService._internal();

  factory MissionLocationService() {
    return _instance;
  }

  MissionLocationService._internal();

  sendAllLocationToServerAndClearData(bool setLastLocationToEndMission,
      bool setLastLocationOnCurrentMission) async {
    String? newToken = await HttpService().getToken();
    List<Map<String, dynamic>> allLocation = [];
    // var personTourId = await SharedPreferenceService().getMissoniId();
    if (newToken != null) {
      allLocation = await DatabaseCrudService().getAllMissionLocation();

      if (allLocation.isNotEmpty) {
        for (var i = 0; i < allLocation.length / 1000; i++) {
          _sendLocationsInBuld(
              newToken,
              setLastLocationToEndMission,
              setLastLocationOnCurrentMission,
              allLocation.skip(i * 1000).take((i + 1) * 1000).toList());
        }
      }
    }
  }

  Future<void> _sendLocationsInBuld(
      String newToken,
      bool setLastLocationToEndMission,
      bool setLastLocationOnCurrentMission,
      List<Map<String, dynamic>> allLocation) async {
    var response = await HttpService().postData(
        "${await EnvironmentHelpers.getCurrentBackend()}/api/PersonTour/MissionLocation/${setLastLocationToEndMission || setLastLocationOnCurrentMission}",
        allLocation,
        newToken,
        false);

    if (response?.statusCode == 200) {
      _clearData(allLocation.last["missionLocationId"]);
    } else if (response?.statusCode == 401) {
      ///
    } else if (response?.statusCode == 403) {
      _clearData(allLocation.last["missionLocationId"]);
    } else if (response?.statusCode == 400) {
      _clearData(allLocation.last["missionLocationId"]);
    } else if (response?.statusCode == 500) {
      _clearData(allLocation.last["missionLocationId"]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<void> _clearData(int lastItemId) async {
    await DatabaseCrudService().clearAllMissoinLocationByLastItemId(lastItemId);
  }
}

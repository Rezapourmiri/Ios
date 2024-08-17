import 'package:intl/intl.dart';

class MissionLocation {
  int? missionLocationId;
  late int? personTourId;
  late double? latitude;
  late double? momentSpeed;
  late double? longitude;
  String? createLocationAt;
  String? updateLocationAt;

  MissionLocation(
      this.personTourId, this.latitude, this.longitude, this.momentSpeed) {
    var stringList = DateTime.now().toIso8601String().split(RegExp(r"[T\.]"));

    createLocationAt =
        "${stringList[0]} ${stringList[1]}+${DateTime.now().timeZoneOffset.toString().split(':')[0] + DateTime.now().timeZoneOffset.toString().split(':')[1]}";
  }

  MissionLocation.update(
      this.personTourId, this.latitude, this.longitude, this.momentSpeed) {
    var stringList = DateTime.now().toIso8601String().split(RegExp(r"[T\.]"));
    updateLocationAt =
        "${stringList[0]} ${stringList[1]}+${DateTime.now().timeZoneOffset}";
  }

  MissionLocation.map(dynamic obj) {
    missionLocationId = obj['missionLocationId'];
    personTourId = obj['personTourId'];
    latitude = obj['latitude'];
    longitude = obj['longitude'];
    momentSpeed = obj['momentSpeed'];
    createLocationAt = obj['createLocationAt'];
    updateLocationAt = obj['updateLocationAt'];
  }
  MissionLocation.fromMap(Map<String, dynamic> map) {
    missionLocationId = map['missionLocationId'];
    personTourId = map['personTourId'];
    latitude = map['latitude'];
    longitude = map['longitude'];
    momentSpeed = map['momentSpeed'];
    createLocationAt = map['createLocationAt'];
    updateLocationAt = map['updateLocationAt'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['missionLocationId'] = missionLocationId;
    map['personTourId'] = personTourId;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['momentSpeed'] = momentSpeed;
    map['createLocationAt'] = createLocationAt;
    map['updateLocationAt'] = updateLocationAt;
    return map;
  }
}

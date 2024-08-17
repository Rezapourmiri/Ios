import 'dart:convert';

import 'package:collection/collection.dart';

class UserMissionStatus {
  String? userState;
  int? personnelStartEndId;
  int? getLocationEvery;
  bool? alwaysSendLocation;

  UserMissionStatus({
    this.userState,
    this.personnelStartEndId,
    this.getLocationEvery,
    this.alwaysSendLocation,
  });

  @override
  String toString() {
    return 'UserMissionStatus(userState: $userState, personnelStartEndId: $personnelStartEndId, getLocationEvery: $getLocationEvery, alwaysSendLocation: $alwaysSendLocation)';
  }

  factory UserMissionStatus.fromMap(Map<String, dynamic> data) {
    return UserMissionStatus(
      userState: data['userState'] as String?,
      personnelStartEndId: data['personnelStartEndId'] as int?,
      getLocationEvery: data['getLocationEvery'] as int?,
      alwaysSendLocation: data['alwaysSendLocation'] as bool?,
    );
  }

  Map<String, dynamic> toMap() => {
        'userState': userState,
        'personnelStartEndId': personnelStartEndId,
        'getLocationEvery': getLocationEvery,
        'alwaysSendLocation': alwaysSendLocation,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserMissionStatus].
  factory UserMissionStatus.fromJson(String data) {
    return UserMissionStatus.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UserMissionStatus] to a JSON string.
  String toJson() => json.encode(toMap());

  UserMissionStatus copyWith({
    String? userState,
    int? personnelStartEndId,
    int? getLocationEvery,
    bool? alwaysSendLocation,
  }) {
    return UserMissionStatus(
      userState: userState ?? this.userState,
      personnelStartEndId: personnelStartEndId ?? this.personnelStartEndId,
      getLocationEvery: getLocationEvery ?? this.getLocationEvery,
      alwaysSendLocation: alwaysSendLocation ?? this.alwaysSendLocation,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! UserMissionStatus) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      userState.hashCode ^
      personnelStartEndId.hashCode ^
      getLocationEvery.hashCode ^
      alwaysSendLocation.hashCode;
}

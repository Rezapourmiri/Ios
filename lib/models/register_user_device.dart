import 'dart:convert';

import 'package:collection/collection.dart';

class RegisterUserDevice {
  String? deviceToken;
  String? deviceType;

  RegisterUserDevice({this.deviceToken, this.deviceType});

  @override
  String toString() {
    return 'RegisterUserDevice(deviceToken: $deviceToken, deviceType: $deviceType)';
  }

  factory RegisterUserDevice.fromMap(Map<String, dynamic> data) {
    return RegisterUserDevice(
      deviceToken: data['deviceToken'] as String?,
      deviceType: data['deviceType'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'deviceToken': deviceToken,
        'deviceType': deviceType,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RegisterUserDevice].
  factory RegisterUserDevice.fromJson(String data) {
    return RegisterUserDevice.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RegisterUserDevice] to a JSON string.
  String toJson() => json.encode(toMap());

  RegisterUserDevice copyWith({
    String? deviceToken,
    String? deviceType,
  }) {
    return RegisterUserDevice(
      deviceToken: deviceToken ?? this.deviceToken,
      deviceType: deviceType ?? this.deviceType,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! RegisterUserDevice) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => deviceToken.hashCode ^ deviceType.hashCode;
}

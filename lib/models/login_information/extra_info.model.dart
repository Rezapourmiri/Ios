import 'dart:convert';

import 'package:collection/collection.dart';

class ExtraInfo {
  String? workSettingType;
  String? value;

  ExtraInfo({this.workSettingType, this.value});

  @override
  String toString() {
    return 'ExtraInfo(workSettingType: $workSettingType, value: $value)';
  }

  factory ExtraInfo.fromMap(Map<String, dynamic> data) => ExtraInfo(
        workSettingType: data['workSettingType'].toString() as String?,
        value: data['value'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'workSettingType': workSettingType,
        'value': value,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ExtraInfo].
  factory ExtraInfo.fromJson(String data) {
    return ExtraInfo.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ExtraInfo] to a JSON string.
  String toJson() => json.encode(toMap());

  ExtraInfo copyWith({
    String? workSettingType,
    String? value,
  }) {
    return ExtraInfo(
      workSettingType: workSettingType ?? this.workSettingType,
      value: value ?? this.value,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ExtraInfo) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => workSettingType.hashCode ^ value.hashCode;
}

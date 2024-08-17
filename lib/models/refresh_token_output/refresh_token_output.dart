import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:optima_soft/models/login_information/extra_info.model.dart';

class RefreshTokenOutput {
  String? token;
  dynamic errors;
  List<ExtraInfo>? extraInfo;

  RefreshTokenOutput({this.token, this.errors, this.extraInfo});

  @override
  String toString() {
    return 'RefreshTokenOutput(token: $token, errors: $errors, extraInfo: $extraInfo)';
  }

  factory RefreshTokenOutput.fromMap(Map<String, dynamic> data) {
    return RefreshTokenOutput(
      token: data['token'] as String?,
      errors: data['errors'] as dynamic,
      extraInfo: (data['extraInfo'] as List<dynamic>?)
          ?.map((e) => ExtraInfo.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'token': token,
        'errors': errors,
        'extraInfo': extraInfo?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RefreshTokenOutput].
  factory RefreshTokenOutput.fromJson(String data) {
    return RefreshTokenOutput.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RefreshTokenOutput] to a JSON string.
  String toJson() => json.encode(toMap());

  RefreshTokenOutput copyWith({
    String? token,
    dynamic errors,
    List<ExtraInfo>? extraInfo,
  }) {
    return RefreshTokenOutput(
      token: token ?? this.token,
      errors: errors ?? this.errors,
      extraInfo: extraInfo ?? this.extraInfo,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! RefreshTokenOutput) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => token.hashCode ^ errors.hashCode ^ extraInfo.hashCode;
}

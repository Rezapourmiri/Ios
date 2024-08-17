import 'dart:convert';

import 'package:collection/collection.dart';

class SetStateOutput {
  String? userState;
  int? personnelStartEndId;

  SetStateOutput({this.userState, this.personnelStartEndId});

  @override
  String toString() {
    return 'SetStateOutput(userState: $userState, personnelStartEndId: $personnelStartEndId)';
  }

  factory SetStateOutput.fromMap(Map<String, dynamic> data) {
    return SetStateOutput(
      // ignore: unnecessary_cast
      userState: (data['userState']).toString() as String?,
      personnelStartEndId: data['personnelStartEndId'] as int?,
    );
  }

  Map<String, dynamic> toMap() => {
        'userState': userState,
        'personnelStartEndId': personnelStartEndId,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SetStateOutput].
  factory SetStateOutput.fromJson(String data) {
    return SetStateOutput.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SetStateOutput] to a JSON string.
  String toJson() => json.encode(toMap());

  SetStateOutput copyWith({
    String? userState,
    int? personnelStartEndId,
  }) {
    return SetStateOutput(
      userState: userState ?? this.userState,
      personnelStartEndId: personnelStartEndId ?? this.personnelStartEndId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! SetStateOutput) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => userState.hashCode ^ personnelStartEndId.hashCode;
}

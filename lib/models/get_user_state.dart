import 'dart:convert';

import 'package:collection/collection.dart';

class GetUserState {
  int? userState;
  String? type;
  int? personnelStartEndId;

  GetUserState({this.userState, this.type, this.personnelStartEndId});

  @override
  String toString() =>
      'GetUserState(userState: $userState, type: $type, personnelStartEndId: $personnelStartEndId)';

  factory GetUserState.fromMap(Map<String, dynamic> data) => GetUserState(
        userState: data['userState'] as int?,
        type: data['type'] as String?,
        personnelStartEndId: data['personnelStartEndId'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'userState': userState,
        'type': type,
        'personnelStartEndId': personnelStartEndId,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [GetUserState].
  factory GetUserState.fromJson(String data) {
    return GetUserState.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [GetUserState] to a JSON string.
  String toJson() => json.encode(toMap());

  GetUserState copyWith({
    int? userState,
    String? type,
  }) {
    return GetUserState(
      userState: userState ?? this.userState,
      type: type ?? this.type,
      personnelStartEndId: personnelStartEndId ?? this.personnelStartEndId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! GetUserState) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => userState.hashCode ^ type.hashCode;
}

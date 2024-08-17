import 'dart:convert';

import 'package:collection/collection.dart';

class SetStateInput {
  String? type;
  String? state;
  List<int>? projectIdList;

  SetStateInput({this.type, this.state, this.projectIdList});

  @override
  String toString() {
    return 'SetStateInput(type: $type, state: $state, projectIdList: $projectIdList)';
  }

  factory SetStateInput.fromMap(Map<String, dynamic> data) => SetStateInput(
        type: data['type'] as String?,
        state: data['state'] as String?,
        projectIdList: data['ProjectIdList'] as List<int>?,
      );

  Map<String, dynamic> toMap() => {
        'type': type,
        'state': state,
        'ProjectIdList': projectIdList,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SetStateInput].
  factory SetStateInput.fromJson(String data) {
    return SetStateInput.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SetStateInput] to a JSON string.
  String toJson() => json.encode(toMap());

  SetStateInput copyWith({
    String? type,
    String? state,
    List<int>? projectIdList,
  }) {
    return SetStateInput(
      type: type ?? this.type,
      state: state ?? this.state,
      projectIdList: projectIdList ?? this.projectIdList,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! SetStateInput) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => type.hashCode ^ state.hashCode ^ projectIdList.hashCode;
}

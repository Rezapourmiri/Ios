import 'dart:convert';

import 'package:collection/collection.dart';

class LetterGroup {
  String key;
  String value;

  LetterGroup({required this.key, required this.value});

  @override
  String toString() => 'LetterGroup(key: $key, value: $value)';

  factory LetterGroup.fromMap(Map<String, dynamic> data) => LetterGroup(
        key: data['key'] as String,
        value: data['value'] as String,
      );

  Map<String, dynamic> toMap() => {
        'key': key,
        'value': value,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [LetterGroup].
  factory LetterGroup.fromJson(String data) {
    return LetterGroup.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [LetterGroup] to a JSON string.
  String toJson() => json.encode(toMap());

  LetterGroup copyWith({
    String? key,
    String? value,
  }) {
    return LetterGroup(
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! LetterGroup) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => key.hashCode ^ value.hashCode;
}

import 'dart:convert';

import 'package:collection/collection.dart';

class SendUserPasswordToLoginForm {
  String? username;
  String? password;

  SendUserPasswordToLoginForm({this.username, this.password});

  @override
  String toString() {
    return 'SendUserPasswordToLoginForm(username: $username, password: $password)';
  }

  factory SendUserPasswordToLoginForm.fromMap(Map<String, dynamic> data) {
    return SendUserPasswordToLoginForm(
      username: data['username'] as String?,
      password: data['password'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'username': username,
        'password': password,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SendUserPasswordToLoginForm].
  factory SendUserPasswordToLoginForm.fromJson(String data) {
    return SendUserPasswordToLoginForm.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SendUserPasswordToLoginForm] to a JSON string.
  String toJson() => json.encode(toMap());

  SendUserPasswordToLoginForm copyWith({
    String? username,
    String? password,
  }) {
    return SendUserPasswordToLoginForm(
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! SendUserPasswordToLoginForm) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => username.hashCode ^ password.hashCode;
}

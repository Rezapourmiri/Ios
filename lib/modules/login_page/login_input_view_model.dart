import 'dart:convert';

import 'package:collection/collection.dart';

class LoginInputViewModel {
  String? email;
  String? phoneNumber;
  String? password;
  int? longLoginDays;

  LoginInputViewModel({
    this.email,
    this.phoneNumber,
    this.password,
    this.longLoginDays,
  });

  @override
  String toString() {
    return 'LoginInputViewModel(email: $email, phoneNumber: $phoneNumber, password: $password, longLoginDays: $longLoginDays)';
  }

  factory LoginInputViewModel.fromToMap(Map<String, dynamic> data) {
    return LoginInputViewModel(
      email: data['email'] as String?,
      phoneNumber: data['phoneNumber'] as String?,
      password: data['password'] as String?,
      longLoginDays: data['longLoginDays'] as int?,
    );
  }

  Map<String, dynamic> toMap() => {
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
        'longLoginDays': longLoginDays,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [LoginInputViewModel].
  factory LoginInputViewModel.fromJson(String data) {
    return LoginInputViewModel.fromToMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [LoginInputViewModel] to a JSON string.
  String toJson() => json.encode(toMap());

  LoginInputViewModel copyWith({
    String? email,
    String? phoneNumber,
    String? password,
    int? longLoginDays,
  }) {
    return LoginInputViewModel(
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      longLoginDays: longLoginDays ?? this.longLoginDays,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! LoginInputViewModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      email.hashCode ^
      phoneNumber.hashCode ^
      password.hashCode ^
      longLoginDays.hashCode;
}

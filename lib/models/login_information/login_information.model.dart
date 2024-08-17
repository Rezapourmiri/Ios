import 'dart:convert';

import 'package:collection/collection.dart';

import 'extra_info.model.dart';
import 'role.model.dart';

class LoginInformation {
  String? userName;
  String? password;
  String? requestedAt;
  bool? isActive;
  List<Role>? roles;
  List<int>? activities;
  String? token;
  String? refreshToken;
  String? expirationDate;
  List<ExtraInfo>? extraInfo;

  LoginInformation({
    this.userName,
    this.password,
    this.requestedAt,
    this.isActive,
    this.roles,
    this.activities,
    this.token,
    this.refreshToken,
    this.expirationDate,
    this.extraInfo,
  });

  @override
  String toString() {
    return 'LoginInformation(userName: $userName,password: $password, requestedAt: $requestedAt, isActive: $isActive, roles: $roles, activities: $activities, token: $token, refreshToken: $refreshToken, expirationDate: $expirationDate, extraInfo: $extraInfo)';
  }

  factory LoginInformation.fromMap(Map<String, dynamic> data) {
    return LoginInformation(
      userName: data['userName'] as String?,
      password: data['password'] as String?,
      requestedAt: data['requestedAt'] as String?,
      isActive: data['isActive'] as bool?,
      roles: (data['roles'] as List<dynamic>?)
          ?.map((e) => Role.fromMap(e as Map<String, dynamic>))
          .toList(),
      activities: data['activities'] as List<int>?,
      token: data['token'] as String?,
      refreshToken: data['refreshToken'] as String?,
      expirationDate: data['expirationDate'] as String?,
      extraInfo: (data['extraInfo'] as List<dynamic>?)
          ?.map((e) => ExtraInfo.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'userName': userName,
        'password': password,
        'requestedAt': requestedAt,
        'isActive': isActive,
        'roles': roles?.map((e) => e.toMap()).toList(),
        'activities': activities,
        'token': token,
        'refreshToken': refreshToken,
        'expirationDate': expirationDate,
        'extraInfo': extraInfo?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [LoginInformation].
  factory LoginInformation.fromJson(String data) {
    return LoginInformation.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [LoginInformation] to a JSON string.
  String toJson() => json.encode(toMap());

  LoginInformation copyWith({
    String? userName,
    String? password,
    String? requestedAt,
    bool? isActive,
    List<Role>? roles,
    List<int>? activities,
    String? token,
    String? refreshToken,
    String? expirationDate,
    List<ExtraInfo>? extraInfo,
  }) {
    return LoginInformation(
      userName: userName ?? this.userName,
      password: password ?? this.password,
      requestedAt: requestedAt ?? this.requestedAt,
      isActive: isActive ?? this.isActive,
      roles: roles ?? this.roles,
      activities: activities ?? this.activities,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      expirationDate: expirationDate ?? this.expirationDate,
      extraInfo: extraInfo ?? this.extraInfo,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! LoginInformation) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      userName.hashCode ^
      password.hashCode ^
      requestedAt.hashCode ^
      isActive.hashCode ^
      roles.hashCode ^
      activities.hashCode ^
      token.hashCode ^
      refreshToken.hashCode ^
      expirationDate.hashCode ^
      extraInfo.hashCode;
}

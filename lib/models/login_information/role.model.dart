import 'dart:convert';

import 'package:collection/collection.dart';

class Role {
  int? roleId;
  String? name;
  bool? isBusinessRole;
  String? businessName;

  Role({this.roleId, this.name, this.isBusinessRole, this.businessName});

  @override
  String toString() {
    return 'Role(roleId: $roleId, name: $name, isBusinessRole: $isBusinessRole, businessName: $businessName)';
  }

  factory Role.fromMap(Map<String, dynamic> data) => Role(
        roleId: data['roleId'] as int?,
        name: data['name'] as String?,
        isBusinessRole: data['isBusinessRole'] as bool?,
        businessName: data['businessName'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'roleId': roleId,
        'name': name,
        'isBusinessRole': isBusinessRole,
        'businessName': businessName,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Role].
  factory Role.fromJson(String data) {
    return Role.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Role] to a JSON string.
  String toJson() => json.encode(toMap());

  Role copyWith({
    int? roleId,
    String? name,
    bool? isBusinessRole,
    String? businessName,
  }) {
    return Role(
      roleId: roleId ?? this.roleId,
      name: name ?? this.name,
      isBusinessRole: isBusinessRole ?? this.isBusinessRole,
      businessName: businessName ?? this.businessName,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Role) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      roleId.hashCode ^
      name.hashCode ^
      isBusinessRole.hashCode ^
      businessName.hashCode;
}

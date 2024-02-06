import 'package:flutter/material.dart';

class User {
  String email;
  String? name;
  String? facilityName;
  String? firstName;
  String? lastName;
  String? middleName;
  List<Map<String, dynamic>>? facilities;
  String? phone;
  User(
      {required this.email,
      required this.name,
      this.phone,
      // this.facilities,
      this.facilityName,
      this.firstName,
      this.lastName,
      this.middleName});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      // facilities: List<Map<String, dynamic>>.from(json['facilities']),
      facilityName: json['facilityName'] as String?,
      firstName: json['firstName'] as String?,
      middleName: json['middleName'] as String?,
      lastName: json['lastName'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'phone': phone,
      // 'facilities': facilities,
      'facilityName': facilityName,
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
    };
  }
}

class Permissions {
  static Permissions? _instance;
  List<Map<String, dynamic>>? _authorities;
  static Permissions instance() {
    _instance ??= Permissions();
    return _instance!;
  }

  setAuthorities(List<Map<String, dynamic>>? values) => _authorities = values;

  List<Map<String, dynamic>>? getAuthorities() => _authorities;
}

// @JsonSerializable()
class TileFields {
  IconData icon;
  String title;
  String url;
  List<String> permissions;

  TileFields(
      {required this.icon,
      required this.title,
      required this.url,
      required this.permissions});

  // factory TileFields.fromJson(Map<String, dynamic> json) =>
  //     _$TileFieldsFromJson(json);

  // Map<String, dynamic> toJson() => _$TileFieldsToJson(this);
}

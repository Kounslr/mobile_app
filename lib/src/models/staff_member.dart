/*
Kounslr iOS & Android App
Copyright (C) 2021 Kounslr

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class StaffMember {
  String? id;
  String? name;
  String? gender;
  String? role;
  String? phoneNumber;
  String? emailAddress;

  StaffMember({
    this.id,
    this.name,
    this.gender,
    this.role,
    this.phoneNumber,
    this.emailAddress,
  });

  StaffMember copyWith({
    String? id,
    String? name,
    String? gender,
    String? role,
    String? roomNumber,
    String? phoneNumber,
    String? emailAddress,
  }) {
    return StaffMember(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailAddress: emailAddress ?? this.emailAddress,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'role': role,
      'phoneNumber': phoneNumber,
      'emailAddress': emailAddress,
    };
  }

  factory StaffMember.fromMap(Map<String, dynamic> map) {
    return StaffMember(
      id: map['id'],
      name: map['name'],
      gender: map['gender'],
      role: map['role'],
      phoneNumber: map['phoneNumber'],
      emailAddress: map['emailAddress'],
    );
  }

  factory StaffMember.fromDocumentSnapshot(DocumentSnapshot doc) {
    return StaffMember(
      id: doc['id'],
      name: doc['name'],
      gender: doc['gender'],
      role: doc['role'],
      phoneNumber: doc['phoneNumber'],
      emailAddress: doc['emailAddress'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StaffMember.fromJson(String source) =>
      StaffMember.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StaffMember(id: $id, name: $name, gender: $gender, role: $role, phoneNumber: $phoneNumber, emailAddress: $emailAddress)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StaffMember &&
        other.id == id &&
        other.name == name &&
        other.gender == gender &&
        other.role == role &&
        other.phoneNumber == phoneNumber &&
        other.emailAddress == emailAddress;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        gender.hashCode ^
        role.hashCode ^
        phoneNumber.hashCode ^
        emailAddress.hashCode;
  }
}

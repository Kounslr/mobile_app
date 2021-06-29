import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class StaffMember {
  String? id;
  String? name;
  String? role;
  String? roomNumber;
  String? phoneNumber;
  String? emailAddress;

  StaffMember({
    this.id,
    this.name,
    this.role,
    this.roomNumber,
    this.phoneNumber,
    this.emailAddress,
  });

  StaffMember copyWith({
    String? id,
    String? name,
    String? role,
    String? roomNumber,
    String? phoneNumber,
    String? emailAddress,
  }) {
    return StaffMember(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      roomNumber: roomNumber ?? this.roomNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailAddress: emailAddress ?? this.emailAddress,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'roomNumber': roomNumber,
      'phoneNumber': phoneNumber,
      'emailAddress': emailAddress,
    };
  }

  factory StaffMember.fromMap(Map<String, dynamic> map) {
    return StaffMember(
      id: map['id'],
      name: map['name'],
      role: map['role'],
      roomNumber: map['roomNumber'],
      phoneNumber: map['phoneNumber'],
      emailAddress: map['emailAddress'],
    );
  }

  factory StaffMember.fromDocumentSnapshot(DocumentSnapshot doc) {
    return StaffMember(
      id: doc['id'],
      name: doc['name'],
      role: doc['role'],
      roomNumber: doc['roomNumber'],
      phoneNumber: doc['phoneNumber'],
      emailAddress: doc['emailAddress'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StaffMember.fromJson(String source) =>
      StaffMember.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StaffMember(id: $id, name: $name, role: $role, roomNumber: $roomNumber, phoneNumber: $phoneNumber, emailAddress: $emailAddress)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StaffMember &&
        other.id == id &&
        other.name == name &&
        other.role == role &&
        other.roomNumber == roomNumber &&
        other.phoneNumber == phoneNumber &&
        other.emailAddress == emailAddress;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        role.hashCode ^
        roomNumber.hashCode ^
        phoneNumber.hashCode ^
        emailAddress.hashCode;
  }
}

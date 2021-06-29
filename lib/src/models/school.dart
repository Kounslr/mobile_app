import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:kounslr/src/models/current_day.dart';
import 'package:kounslr/src/models/staff_member.dart';

class School {
  String? name;
  String? address;
  String? principal;
  String? phoneNumber;
  String? faxNumber;
  String? websiteURL;
  CurrentDay? currentDay;
  List<StaffMember>? staff;

  School({
    this.name,
    this.address,
    this.principal,
    this.phoneNumber,
    this.faxNumber,
    this.websiteURL,
    this.currentDay,
    this.staff,
  });

  School copyWith({
    String? name,
    String? address,
    String? principal,
    String? phoneNumber,
    String? faxNumber,
    String? websiteURL,
    CurrentDay? currentDay,
    List<StaffMember>? staff,
  }) {
    return School(
      name: name ?? this.name,
      address: address ?? this.address,
      principal: principal ?? this.principal,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      faxNumber: faxNumber ?? this.faxNumber,
      websiteURL: websiteURL ?? this.websiteURL,
      currentDay: currentDay ?? this.currentDay,
      staff: staff ?? this.staff,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'principal': principal,
      'phoneNumber': phoneNumber,
      'faxNumber': faxNumber,
      'websiteURL': websiteURL,
      'currentDay': currentDay?.toMap(),
    };
  }

  factory School.fromMap(Map<String, dynamic> map) {
    return School(
      name: map['name'],
      address: map['address'],
      principal: map['principal'],
      phoneNumber: map['phoneNumber'],
      faxNumber: map['faxNumber'],
      websiteURL: map['websiteURL'],
      currentDay: CurrentDay.fromMap(map['currentDay']),
    );
  }

  factory School.fromDocumentSnapshot(DocumentSnapshot doc) {
    return School(
      name: doc['name'],
      address: doc['address'],
      principal: doc['principal'],
      phoneNumber: doc['phoneNumber'],
      faxNumber: doc['faxNumber'],
      websiteURL: doc['websiteURL'],
      currentDay: CurrentDay.fromDocumentSnapshot(doc['currentDay']),
    );
  }

  String toJson() => json.encode(toMap());

  factory School.fromJson(String source) => School.fromMap(json.decode(source));

  @override
  String toString() {
    return 'School(name: $name, address: $address, principal: $principal, phoneNumber: $phoneNumber, faxNumber: $faxNumber, websiteURL: $websiteURL, currentDay: $currentDay, staff: $staff)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is School &&
        other.name == name &&
        other.address == address &&
        other.principal == principal &&
        other.phoneNumber == phoneNumber &&
        other.faxNumber == faxNumber &&
        other.websiteURL == websiteURL &&
        other.currentDay == currentDay &&
        listEquals(other.staff, staff);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        address.hashCode ^
        principal.hashCode ^
        phoneNumber.hashCode ^
        faxNumber.hashCode ^
        websiteURL.hashCode ^
        currentDay.hashCode ^
        staff.hashCode;
  }
}

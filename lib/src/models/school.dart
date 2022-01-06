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

import 'package:kounslr/src/models/current_day.dart';

class School {
  String? id;
  String? name;
  String? address;
  String? phoneNumber;
  String? faxNumber;
  String? websiteURL;
  CurrentDay? currentDay;

  School({
    this.id,
    this.name,
    this.address,
    this.phoneNumber,
    this.faxNumber,
    this.websiteURL,
    this.currentDay,
  });

  School copyWith({
    String? id,
    String? name,
    String? address,
    String? phoneNumber,
    String? faxNumber,
    String? websiteURL,
    CurrentDay? currentDay,
  }) {
    return School(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      faxNumber: faxNumber ?? this.faxNumber,
      websiteURL: websiteURL ?? this.websiteURL,
      currentDay: currentDay ?? this.currentDay,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'faxNumber': faxNumber,
      'websiteURL': websiteURL,
      'currentDay': currentDay?.toMap(),
    };
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'faxNumber': faxNumber,
      'websiteURL': websiteURL,
      'currentDay': currentDay?.toDocumentSnapshot(),
    };
  }

  factory School.fromMap(Map<String, dynamic> map) {
    return School(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      phoneNumber: map['phoneNumber'],
      faxNumber: map['faxNumber'],
      websiteURL: map['websiteURL'],
      currentDay: CurrentDay.fromMap(map['currentDay']),
    );
  }

  factory School.fromDocumentSnapshot(DocumentSnapshot doc) {
    return School(
      id: doc['id'],
      name: doc['name'],
      address: doc['address'],
      phoneNumber: doc['phoneNumber'],
      faxNumber: doc['faxNumber'],
      websiteURL: doc['websiteURL'],
      currentDay: CurrentDay.fromMapFromDocumentSnapshot(doc['currentDay']),
    );
  }

  String toJson() => json.encode(toMap());

  factory School.fromJson(String source) => School.fromMap(json.decode(source));

  @override
  String toString() {
    return 'School(id: $id, name: $name, address: $address, phoneNumber: $phoneNumber, faxNumber: $faxNumber, websiteURL: $websiteURL, currentDay: $currentDay)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is School &&
        other.id == id &&
        other.name == name &&
        other.address == address &&
        other.phoneNumber == phoneNumber &&
        other.faxNumber == faxNumber &&
        other.websiteURL == websiteURL &&
        other.currentDay == currentDay;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        address.hashCode ^
        phoneNumber.hashCode ^
        faxNumber.hashCode ^
        websiteURL.hashCode ^
        currentDay.hashCode;
  }
}

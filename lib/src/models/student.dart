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

import 'package:kounslr/src/models/class.dart';

class Student {
  String? id;
  String? studentId;
  String? name;
  String? gender;
  String? grade;
  String? address;
  String? nickname;
  String? birthdate;
  String? email;
  String? phone;
  String? photo;

  Student({
    this.id,
    this.studentId,
    this.name,
    this.gender,
    this.grade,
    this.address,
    this.nickname,
    this.birthdate,
    this.email,
    this.phone,
    this.photo,
  });

  Student copyWith({
    String? id,
    String? studentId,
    String? name,
    String? gender,
    String? grade,
    String? address,
    String? nickname,
    String? birthdate,
    String? email,
    String? phone,
    String? photo,
  }) {
    return Student(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      grade: grade ?? this.grade,
      address: address ?? this.address,
      nickname: nickname ?? this.nickname,
      birthdate: birthdate ?? this.birthdate,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'name': name,
      'gender': gender,
      'grade': grade,
      'address': address,
      'nickname': nickname,
      'birthdate': birthdate,
      'email': email,
      'phone': phone,
      'photo': photo,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      studentId: map['studentId'],
      name: map['name'],
      gender: map['gender'],
      grade: map['grade'],
      address: map['address'],
      nickname: map['nickname'],
      birthdate: map['birthdate'],
      email: map['email'],
      phone: map['phone'],
      photo: map['photo'],
    );
  }

  factory Student.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Student(
      id: doc['id'],
      studentId: doc['studentId'],
      name: doc['name'],
      gender: doc['gender'],
      grade: doc['grade'],
      address: doc['address'],
      nickname: doc['nickname'],
      birthdate: doc['birthdate'],
      email: doc['email'],
      phone: doc['phone'],
      photo: doc['photo'],
    );
  }

  StudentID idOnly() {
    return StudentID(
      id: id,
    );
  }

  StudentInClass toStudentInClass() {
    return StudentInClass(
      grades: [],
    );
  }

  StudentInAssignment toStudentInAssignment() {
    return StudentInAssignment(
      id: id,
      completed: false,
      earnedPoints: 0.0,
    );
  }

  Map<String, dynamic> toMapId() {
    return {
      'id': id,
    };
  }

  factory Student.fromMapId(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Student.fromJson(String source) =>
      Student.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Student(id: $id, studentId: $studentId, name: $name, gender: $gender, grade: $grade, address: $address, nickname: $nickname, birthdate: $birthdate, email: $email, phone: $phone, photo: $photo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Student &&
        other.id == id &&
        other.studentId == studentId &&
        other.name == name &&
        other.gender == gender &&
        other.grade == grade &&
        other.address == address &&
        other.nickname == nickname &&
        other.birthdate == birthdate &&
        other.email == email &&
        other.phone == phone &&
        other.photo == photo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        studentId.hashCode ^
        name.hashCode ^
        gender.hashCode ^
        grade.hashCode ^
        address.hashCode ^
        nickname.hashCode ^
        birthdate.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        photo.hashCode;
  }
}

class StudentID {
  String? id;

  StudentID({
    this.id,
  });

  StudentID copyWith({
    String? id,
  }) {
    return StudentID(
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  factory StudentID.fromMap(Map<String, dynamic> map) {
    return StudentID(
      id: map['id'],
    );
  }

  factory StudentID.fromDocumentSnapshot(DocumentSnapshot doc) {
    return StudentID(
      id: doc['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StudentID.fromJson(String source) =>
      StudentID.fromMap(json.decode(source));

  @override
  String toString() => 'StudentInClass(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StudentID && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class StudentInAssignment {
  String? id;
  bool? completed;
  double? earnedPoints;

  StudentInAssignment({
    this.id,
    this.completed,
    this.earnedPoints,
  });

  StudentInAssignment copyWith({
    String? id,
    bool? completed,
    double? earnedPoints,
  }) {
    return StudentInAssignment(
      id: id ?? this.id,
      completed: completed ?? this.completed,
      earnedPoints: earnedPoints ?? this.earnedPoints,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'completed': completed,
      'earnedPoints': earnedPoints,
    };
  }

  factory StudentInAssignment.fromMap(Map<String, dynamic> map) {
    return StudentInAssignment(
      id: map['id'],
      completed: map['completed'],
      earnedPoints: map['earnedPoints'].toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory StudentInAssignment.fromJson(String source) =>
      StudentInAssignment.fromMap(json.decode(source));

  @override
  String toString() =>
      'StudentInAssignment(id: $id, completed: $completed, earnedPoints: $earnedPoints)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StudentInAssignment &&
        other.id == id &&
        other.completed == completed &&
        other.earnedPoints == earnedPoints;
  }

  @override
  int get hashCode => id.hashCode ^ completed.hashCode ^ earnedPoints.hashCode;
}

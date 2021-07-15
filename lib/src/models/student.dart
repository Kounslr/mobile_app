import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

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

  Student.id({
    this.id,
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

  Map<String, dynamic> toMapId() {
    return {
      'id': id,
    };
  }

  factory Student.fromMapId(Map<String, dynamic> map) {
    return Student.id(
      id: map['id'],
    );
  }

  factory Student.fromDocumentSnapshotId(DocumentSnapshot doc) {
    return Student.id(
      id: doc['id'],
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
      earnedPoints: map['earnedPoints'],
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

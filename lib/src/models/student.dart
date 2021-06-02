import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  String id;
  String name;
  String gender;
  String grade;
  String address;
  String nickname;
  String birthdate;
  String email;
  String phone;
  String photo;
  String currentSchool;
  String homeroom;
  String homeroomTeacher;
  String homeroomTeacherEmail;
  String counselorName;

  Student({
    this.id,
    this.name,
    this.gender,
    this.grade,
    this.address,
    this.nickname,
    this.birthdate,
    this.email,
    this.phone,
    this.photo,
    this.currentSchool,
    this.homeroom,
    this.homeroomTeacher,
    this.homeroomTeacherEmail,
    this.counselorName,
  });

  Student copyWith({
    String id,
    String name,
    String gender,
    String grade,
    String address,
    String nickname,
    String birthdate,
    String email,
    String phone,
    String photo,
    String currentSchool,
    String homeroom,
    String homeroomTeacher,
    String homeroomTeacherEmail,
    String counselorName,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      grade: grade ?? this.grade,
      address: address ?? this.address,
      nickname: nickname ?? this.nickname,
      birthdate: birthdate ?? this.birthdate,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      currentSchool: currentSchool ?? this.currentSchool,
      homeroom: homeroom ?? this.homeroom,
      homeroomTeacher: homeroomTeacher ?? this.homeroomTeacher,
      homeroomTeacherEmail: homeroomTeacherEmail ?? this.homeroomTeacherEmail,
      counselorName: counselorName ?? this.counselorName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'grade': grade,
      'address': address,
      'nickname': nickname,
      'birthdate': birthdate,
      'email': email,
      'phone': phone,
      'photo': photo,
      'currentSchool': currentSchool,
      'homeroom': homeroom,
      'homeroomTeacher': homeroomTeacher,
      'homeroomTeacherEmail': homeroomTeacherEmail,
      'counselorName': counselorName,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      gender: map['gender'],
      grade: map['grade'],
      address: map['address'],
      nickname: map['nickname'],
      birthdate: map['birthdate'],
      email: map['email'],
      phone: map['phone'],
      photo: map['photo'],
      currentSchool: map['currentSchool'],
      homeroom: map['homeroom'],
      homeroomTeacher: map['homeroomTeacher'],
      homeroomTeacherEmail: map['homeroomTeacherEmail'],
      counselorName: map['counselorName'],
    );
  }

  factory Student.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Student(
      id: doc.data(),
      name: doc['name'],
      gender: doc['gender'],
      grade: doc['grade'],
      address: doc['address'],
      nickname: doc['nickname'],
      birthdate: doc['birthdate'],
      email: doc['email'],
      phone: doc['phone'],
      photo: doc['photo'],
      currentSchool: doc['currentSchool'],
      homeroom: doc['homeroom'],
      homeroomTeacher: doc['homeroomTeacher'],
      homeroomTeacherEmail: doc['homeroomTeacherEmail'],
      counselorName: doc['counselorName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Student.fromJson(String source) =>
      Student.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Student(id: $id, name: $name, gender: $gender, grade: $grade, address: $address, nickname: $nickname, birthdate: $birthdate, email: $email, phone: $phone, photo: $photo, currentSchool: $currentSchool, homeroom: $homeroom, homeroomTeacher: $homeroomTeacher, homeroomTeacherEmail: $homeroomTeacherEmail, counselorName: $counselorName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Student &&
        other.id == id &&
        other.name == name &&
        other.gender == gender &&
        other.grade == grade &&
        other.address == address &&
        other.nickname == nickname &&
        other.birthdate == birthdate &&
        other.email == email &&
        other.phone == phone &&
        other.photo == photo &&
        other.currentSchool == currentSchool &&
        other.homeroom == homeroom &&
        other.homeroomTeacher == homeroomTeacher &&
        other.homeroomTeacherEmail == homeroomTeacherEmail &&
        other.counselorName == counselorName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        gender.hashCode ^
        grade.hashCode ^
        address.hashCode ^
        nickname.hashCode ^
        birthdate.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        photo.hashCode ^
        currentSchool.hashCode ^
        homeroom.hashCode ^
        homeroomTeacher.hashCode ^
        homeroomTeacherEmail.hashCode ^
        counselorName.hashCode;
  }
}

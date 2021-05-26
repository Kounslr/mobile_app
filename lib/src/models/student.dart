import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:kounslr/src/models/class.dart';

class Student {
  // Theoretically the name and other info can go here
  // var studentApi = StudentVueClient('1056083', 'Bingie@jordan0831!', 'portal.lcps.org').loadStudentData().then((value) => studentInfo = value);

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
  String error;
  List<Class> classes;

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
    this.classes,
    this.error,
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
    List<Class> classes,
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
      classes: classes ?? this.classes,
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
      'classes': classes?.map((x) => x.toMap())?.toList(),
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
      classes: List<Class>.from(map['classes']?.map((x) => Class.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Student.fromJson(String source) =>
      Student.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Student(id: $id, name: $name, gender: $gender, grade: $grade, address: $address, nickname: $nickname, birthdate: $birthdate, email: $email, phone: $phone, photo: $photo, currentSchool: $currentSchool, homeroom: $homeroom, homeroomTeacher: $homeroomTeacher, homeroomTeacherEmail: $homeroomTeacherEmail, counselorName: $counselorName, classes: $classes)';
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
        other.counselorName == counselorName &&
        listEquals(other.classes, classes);
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
        counselorName.hashCode ^
        classes.hashCode;
  }
}

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kounslr/src/models/staff_member.dart';

class Student {
  String? id;
  String? name;
  String? gender;
  String? grade;
  String? address;
  String? nickname;
  String? birthdate;
  String? email;
  String? phone;
  String? photo;
  String? currentSchool;
  StaffMember? homeroomTeacher;
  StaffMember? counselor;

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
    this.homeroomTeacher,
    this.counselor,
  });

  Student copyWith({
    String? id,
    String? name,
    String? gender,
    String? grade,
    String? address,
    String? nickname,
    String? birthdate,
    String? email,
    String? phone,
    String? photo,
    String? currentSchool,
    StaffMember? homeroomTeacher,
    StaffMember? counselor,
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
      homeroomTeacher: homeroomTeacher ?? this.homeroomTeacher,
      counselor: counselor ?? this.counselor,
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
      'homeroomTeacher': homeroomTeacher?.toMap(),
      'counselor': counselor?.toMap(),
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
      homeroomTeacher: StaffMember.fromMap(map['homeroomTeacher'] ?? {}),
      counselor: StaffMember.fromMap(map['counselor'] ?? {}),
    );
  }

  factory Student.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Student(
      id: doc.data() as String?,
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
      homeroomTeacher: StaffMember.fromDocumentSnapshot(doc['homeroomTeacher']),
      counselor: StaffMember.fromDocumentSnapshot(doc['counselor']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Student.fromJson(String source) =>
      Student.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Student(id: $id, name: $name, gender: $gender, grade: $grade, address: $address, nickname: $nickname, birthdate: $birthdate, email: $email, phone: $phone, photo: $photo, currentSchool: $currentSchool, homeroomTeacher: $homeroomTeacher, counselorName: $counselor)';
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
        other.homeroomTeacher == homeroomTeacher &&
        other.counselor == counselor;
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
        homeroomTeacher.hashCode ^
        counselor.hashCode;
  }
}

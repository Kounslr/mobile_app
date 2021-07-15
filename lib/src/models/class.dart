import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:kounslr/src/models/assignment.dart';
import 'package:kounslr/src/models/student.dart';

class Class {
  String? id;
  String? name;
  String? roomNumber;
  String? teacherId;
  int? block;
  List<Student>? students;
  List<Assignment>? assignments;

  Class({
    this.id,
    this.name,
    this.block,
    this.roomNumber,
    this.teacherId,
    this.students,
    this.assignments,
  });

  Class copyWith({
    String? id,
    String? name,
    String? roomNumber,
    String? teacherId,
    int? block,
    List<Student>? students,
    List<Assignment>? assignments,
  }) {
    return Class(
      id: id ?? this.id,
      name: name ?? this.name,
      block: block ?? this.block,
      roomNumber: roomNumber ?? this.roomNumber,
      teacherId: teacherId ?? this.teacherId,
      students: students ?? this.students,
      assignments: assignments ?? this.assignments,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'block': block,
      'roomNumber': roomNumber,
      'teacherId': teacherId,
      'students': students?.map((x) => x.toMapId()).toList(),
      'assignments': assignments?.map((x) => x.toMap()).toList(),
    };
  }

  factory Class.fromMap(Map<String, dynamic> map) {
    return Class(
      id: map['id'],
      name: map['name'],
      block: map['block'],
      roomNumber: map['roomNumber'],
      teacherId: map['teacherId'],
      students:
          List<Student>.from(map['students']?.map((x) => Student.fromMap(x))),
      assignments: List<Assignment>.from(
          map['assignments']?.map((x) => Assignment.fromMap(x))),
    );
  }

  factory Class.fromDocumentSnapshot(
    DocumentSnapshot doc,
    List<Assignment> assignments,
  ) {
    return Class(
      id: doc['id'],
      name: doc['name'],
      block: doc['block'],
      roomNumber: doc['roomNumber'],
      teacherId: doc['teacherId'],
      students:
          List<Student>.from(doc['students']?.map((x) => Student.fromMapId(x))),
      assignments: assignments,
    );
  }

  String toJson() => json.encode(toMap());

  factory Class.fromJson(String source) => Class.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Class(id: $id, name: $name, block: $block, roomNumber: $roomNumber, teacherId: $teacherId, students: $students, assignments: $assignments)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Class &&
        other.id == id &&
        other.name == name &&
        other.block == block &&
        other.roomNumber == roomNumber &&
        other.teacherId == teacherId &&
        listEquals(other.students, students) &&
        listEquals(other.assignments, assignments);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        block.hashCode ^
        roomNumber.hashCode ^
        teacherId.hashCode ^
        students.hashCode ^
        assignments.hashCode;
  }
}

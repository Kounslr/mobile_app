import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:kounslr/src/models/assignment.dart';
import 'package:kounslr/src/models/block.dart';
import 'package:kounslr/src/models/staff_member.dart';

class Class {
  String? className;
  String? roomNumber;
  String? pctGrade;
  String? letterGrade;
  StaffMember? teacher;
  Block? block;
  List<Assignment>? assignments;

  Class({
    this.className,
    this.roomNumber,
    this.pctGrade,
    this.letterGrade,
    this.teacher,
    this.block,
    this.assignments,
  });

  Class copyWith({
    String? className,
    String? roomNumber,
    String? pctGrade,
    String? letterGrade,
    StaffMember? teacher,
    Block? block,
    List<Assignment>? assignments,
  }) {
    return Class(
      className: className ?? this.className,
      roomNumber: roomNumber ?? this.roomNumber,
      pctGrade: pctGrade ?? this.pctGrade,
      letterGrade: letterGrade ?? this.letterGrade,
      teacher: teacher ?? this.teacher,
      block: block ?? this.block,
      assignments: assignments ?? this.assignments,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'className': className,
      'roomNumber': roomNumber,
      'pctGrade': pctGrade,
      'letterGrade': letterGrade,
      'teacher': teacher?.toMap(),
      'block': block?.toMap(),
    };
  }

  factory Class.fromMap(Map<String, dynamic> map) {
    return Class(
      className: map['className'],
      roomNumber: map['roomNumber'],
      pctGrade: map['pctGrade'],
      letterGrade: map['letterGrade'],
      teacher: StaffMember.fromMap(map['teacher']),
      block: Block.fromMap(map['block']),
    );
  }

  factory Class.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Class(
      className: doc['className'],
      roomNumber: doc['roomNumber'],
      pctGrade: doc['pctGrade'],
      letterGrade: doc['letterGrade'],
      teacher: StaffMember.fromDocumentSnapshot(doc['teacher']),
      block: Block.fromDocumentSnapshot(doc['block']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Class.fromJson(String source) => Class.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Class(className: $className, roomNumber: $roomNumber, pctGrade: $pctGrade, letterGrade: $letterGrade, teacher: $teacher, block: $block, assignments: $assignments)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Class &&
        other.className == className &&
        other.roomNumber == roomNumber &&
        other.pctGrade == pctGrade &&
        other.letterGrade == letterGrade &&
        other.teacher == teacher &&
        other.block == block &&
        listEquals(other.assignments, assignments);
  }

  @override
  int get hashCode {
    return className.hashCode ^
        roomNumber.hashCode ^
        pctGrade.hashCode ^
        letterGrade.hashCode ^
        teacher.hashCode ^
        block.hashCode ^
        assignments.hashCode;
  }
}

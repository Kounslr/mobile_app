import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:kounslr/src/models/assignment.dart';

class Class {
  String className;
  String classTeacher;
  String classTeacherEmail;
  String markingPeriod;
  String roomNumber;
  String pctGrade;
  String letterGrade;
  int period;
  List<Assignment> assignments;

  Class({
    this.className,
    this.classTeacher,
    this.classTeacherEmail,
    this.markingPeriod,
    this.roomNumber,
    this.pctGrade,
    this.letterGrade,
    this.period,
    this.assignments,
  });

  Class copyWith({
    String className,
    String classTeacher,
    String classTeacherEmail,
    String markingPeriod,
    String roomNumber,
    String pctGrade,
    String letterGrade,
    int period,
    List<Assignment> assignments,
  }) {
    return Class(
      className: className ?? this.className,
      classTeacher: classTeacher ?? this.classTeacher,
      classTeacherEmail: classTeacherEmail ?? this.classTeacherEmail,
      markingPeriod: markingPeriod ?? this.markingPeriod,
      roomNumber: roomNumber ?? this.roomNumber,
      pctGrade: pctGrade ?? this.pctGrade,
      letterGrade: letterGrade ?? this.letterGrade,
      period: period ?? this.period,
      assignments: assignments ?? this.assignments,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'className': className,
      'classTeacher': classTeacher,
      'classTeacherEmail': classTeacherEmail,
      'markingPeriod': markingPeriod,
      'roomNumber': roomNumber,
      'pctGrade': pctGrade,
      'letterGrade': letterGrade,
      'period': period,
    };
  }

  factory Class.fromMap(Map<String, dynamic> map) {
    return Class(
      className: map['className'] as String,
      classTeacher: map['classTeacher'] as String,
      classTeacherEmail: map['classTeacherEmail'] as String,
      markingPeriod: map['markingPeriod'] as String,
      roomNumber: map['roomNumber'] as String,
      pctGrade: map['pctGrade'] as String,
      letterGrade: map['letterGrade'] as String,
      period: map['period'] as int,
    );
  }

  factory Class.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Class(
      className: doc['className'] as String,
      classTeacher: doc['classTeacher'] as String,
      classTeacherEmail: doc['classTeacherEmail'] as String,
      markingPeriod: doc['markingPeriod'] as String,
      roomNumber: doc['roomNumber'] as String,
      pctGrade: doc['pctGrade'] as String,
      letterGrade: doc['letterGrade'] as String,
      period: doc['period'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Class.fromJson(String source) => Class.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Class(className: $className, classTeacher: $classTeacher, classTeacherEmail: $classTeacherEmail, markingPeriod: $markingPeriod, roomNumber: $roomNumber, pctGrade: $pctGrade, letterGrade: $letterGrade, period: $period, assignments: $assignments)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Class &&
        other.className == className &&
        other.classTeacher == classTeacher &&
        other.classTeacherEmail == classTeacherEmail &&
        other.markingPeriod == markingPeriod &&
        other.roomNumber == roomNumber &&
        other.pctGrade == pctGrade &&
        other.letterGrade == letterGrade &&
        other.period == period &&
        listEquals(other.assignments, assignments);
  }

  @override
  int get hashCode {
    return className.hashCode ^
        classTeacher.hashCode ^
        classTeacherEmail.hashCode ^
        markingPeriod.hashCode ^
        roomNumber.hashCode ^
        pctGrade.hashCode ^
        letterGrade.hashCode ^
        period.hashCode ^
        assignments.hashCode;
  }
}

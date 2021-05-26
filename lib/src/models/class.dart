import 'dart:convert';

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
  double earnedPoints;
  double possiblePoints;
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
    this.earnedPoints,
    this.possiblePoints,
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
    double earnedPoints,
    double possiblePoints,
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
      earnedPoints: earnedPoints ?? this.earnedPoints,
      possiblePoints: possiblePoints ?? this.possiblePoints,
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
      'earnedPoints': earnedPoints,
      'possiblePoints': possiblePoints,
      'period': period,
      'assignments': assignments?.map((x) => x.toMap())?.toList(),
    };
  }

  factory Class.fromMap(Map<String, dynamic> map) {
    return Class(
      className: map['className'],
      classTeacher: map['classTeacher'],
      classTeacherEmail: map['classTeacherEmail'],
      markingPeriod: map['markingPeriod'],
      roomNumber: map['roomNumber'],
      pctGrade: map['pctGrade'],
      letterGrade: map['letterGrade'],
      earnedPoints: map['earnedPoints'],
      possiblePoints: map['possiblePoints'],
      period: map['period'],
      assignments: List<Assignment>.from(
          map['assignments']?.map((x) => Assignment.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Class.fromJson(String source) => Class.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Class(className: $className, classTeacher: $classTeacher, classTeacherEmail: $classTeacherEmail, markingPeriod: $markingPeriod, roomNumber: $roomNumber, pctGrade: $pctGrade, letterGrade: $letterGrade, earnedPoints: $earnedPoints, possiblePoints: $possiblePoints, period: $period, assignments: $assignments)';
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
        other.earnedPoints == earnedPoints &&
        other.possiblePoints == possiblePoints &&
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
        earnedPoints.hashCode ^
        possiblePoints.hashCode ^
        period.hashCode ^
        assignments.hashCode;
  }
}

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
import 'package:flutter/foundation.dart';

import 'package:kounslr/src/models/student.dart';

class Assignment {
  String? id;
  String? classId;
  String? name;
  String? type;
  int? markingPeriod;
  double? possiblePoints;
  DateTime? creationDate;
  DateTime? dueDate;
  List<StudentInAssignment>? students;

  Assignment({
    this.id,
    this.classId,
    this.name,
    this.type,
    this.markingPeriod,
    this.possiblePoints,
    this.creationDate,
    this.dueDate,
    this.students,
  });

  Assignment copyWith({
    String? id,
    String? classId,
    String? name,
    String? type,
    int? markingPeriod,
    double? possiblePoints,
    DateTime? creationDate,
    DateTime? dueDate,
    List<StudentInAssignment>? students,
  }) {
    return Assignment(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      name: name ?? this.name,
      type: type ?? this.type,
      markingPeriod: markingPeriod ?? this.markingPeriod,
      possiblePoints: possiblePoints ?? this.possiblePoints,
      creationDate: creationDate ?? this.creationDate,
      dueDate: dueDate ?? this.dueDate,
      students: students ?? this.students,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'classId': classId,
      'name': name,
      'type': type,
      'markingPeriod': markingPeriod,
      'possiblePoints': possiblePoints,
      'creationDate': creationDate?.millisecondsSinceEpoch,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'students': students?.map((x) => x.toMap()).toList(),
    };
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      'id': id,
      'classId': classId,
      'name': name,
      'type': type,
      'markingPeriod': markingPeriod,
      'possiblePoints': possiblePoints,
      'creationDate': Timestamp.fromDate(creationDate!),
      'dueDate': Timestamp.fromDate(dueDate!),
      'students': students?.map((x) => x.toMap()).toList(),
    };
  }

  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      id: map['id'],
      classId: map['classId'],
      name: map['name'],
      type: map['type'],
      markingPeriod: map['markingPeriod'],
      possiblePoints: map['possiblePoints'].toDouble(),
      creationDate: DateTime.fromMillisecondsSinceEpoch(map['creationDate']),
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate']),
      students: List<StudentInAssignment>.from(
          map['students']?.map((x) => StudentInAssignment.fromMap(x))),
    );
  }

  factory Assignment.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Assignment(
      id: doc['id'],
      classId: doc['classId'],
      name: doc['name'],
      type: doc['type'],
      markingPeriod: doc['markingPeriod'],
      possiblePoints: doc['possiblePoints'].toDouble(),
      creationDate: (doc['creationDate'] as Timestamp).toDate(),
      dueDate: (doc['dueDate'] as Timestamp).toDate(),
      students: List<StudentInAssignment>.from(
          doc['students']?.map((x) => StudentInAssignment.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Assignment.fromJson(String source) =>
      Assignment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Assignment(id: $id, classId: $classId, name: $name, type: $type, markingPeriod: $markingPeriod, possiblePoints: $possiblePoints, creationDate: $creationDate, dueDate: $dueDate, students: $students)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Assignment &&
        other.id == id &&
        other.classId == classId &&
        other.name == name &&
        other.type == type &&
        other.markingPeriod == markingPeriod &&
        other.possiblePoints == possiblePoints &&
        other.creationDate == creationDate &&
        other.dueDate == dueDate &&
        listEquals(other.students, students);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        classId.hashCode ^
        name.hashCode ^
        type.hashCode ^
        markingPeriod.hashCode ^
        possiblePoints.hashCode ^
        creationDate.hashCode ^
        dueDate.hashCode ^
        students.hashCode;
  }
}

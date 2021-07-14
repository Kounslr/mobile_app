import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:kounslr/src/models/class.dart';
import 'package:kounslr/src/models/student.dart';

class Assignment {
  String? assignmentName;
  String? type;
  double? earnedPoints;
  double? possiblePoints;
  bool? completed;
  DateTime? creationDate;
  DateTime? dueDate;
  Class? schoolClass;

  Assignment({
    this.assignmentName,
    this.type,
    this.earnedPoints,
    this.possiblePoints,
    this.completed,
    this.creationDate,
    this.dueDate,
    this.schoolClass,
  });

  Assignment copyWith({
    String? assignmentName,
    String? type,
    double? earnedPoints,
    double? possiblePoints,
    bool? completed,
    DateTime? creationDate,
    DateTime? dueDate,
    Class? schoolClass,
  }) {
    return Assignment(
      assignmentName: assignmentName ?? this.assignmentName,
      type: type ?? this.type,
      earnedPoints: earnedPoints ?? this.earnedPoints,
      possiblePoints: possiblePoints ?? this.possiblePoints,
      completed: completed ?? this.completed,
      creationDate: creationDate ?? this.creationDate,
      dueDate: dueDate ?? this.dueDate,
      schoolClass: schoolClass ?? this.schoolClass,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'assignmentName': assignmentName,
      'type': type,
      'earnedPoints': earnedPoints,
      'possiblePoints': possiblePoints,
      'completed': completed,
      'creationDate': creationDate?.millisecondsSinceEpoch,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'schoolClass': schoolClass?.toMap(),
    };
  }

  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      assignmentName: map['assignmentName'],
      type: map['type'],
      earnedPoints: map['earnedPoints'],
      possiblePoints: map['possiblePoints'],
      completed: map['completed'],
      creationDate: DateTime.fromMillisecondsSinceEpoch(
        map['creationDate'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate']),
      schoolClass: Class.fromMap(map['schoolClass']),
    );
  }

  factory Assignment.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Assignment(
      assignmentName: doc['assignmentName'],
      type: doc['type'],
      earnedPoints: doc['earnedPoints'],
      possiblePoints: doc['possiblePoints'],
      completed: doc['completed'],
      creationDate: DateTime.fromMillisecondsSinceEpoch(
        doc['creationDate'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      dueDate: DateTime.fromMillisecondsSinceEpoch(doc['dueDate']),
      schoolClass: Class.fromDocumentSnapshot(doc['schoolClass']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Assignment.fromJson(String source) =>
      Assignment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Assignment(assignmentName: $assignmentName, type: $type, earnedPoints: $earnedPoints, possiblePoints: $possiblePoints, completed: $completed, creationDate: $creationDate, dueDate: $dueDate, schoolClass: $schoolClass)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Assignment &&
        other.assignmentName == assignmentName &&
        other.type == type &&
        other.earnedPoints == earnedPoints &&
        other.possiblePoints == possiblePoints &&
        other.completed == completed &&
        other.creationDate == creationDate &&
        other.dueDate == dueDate &&
        other.schoolClass == schoolClass;
  }

  @override
  int get hashCode {
    return assignmentName.hashCode ^
        type.hashCode ^
        earnedPoints.hashCode ^
        possiblePoints.hashCode ^
        completed.hashCode ^
        creationDate.hashCode ^
        dueDate.hashCode ^
        schoolClass.hashCode;
  }
}

class AssignmentM {
  String? id;
  String? classId;
  String? name;
  String? type;
  double? possiblePoints;
  DateTime? creationDate;
  DateTime? dueDate;
  List<StudentInAssignment>? students;

  AssignmentM({
    this.id,
    this.classId,
    this.name,
    this.type,
    this.possiblePoints,
    this.creationDate,
    this.dueDate,
    this.students,
  });

  AssignmentM copyWith({
    String? id,
    String? classId,
    String? name,
    String? type,
    double? possiblePoints,
    DateTime? creationDate,
    DateTime? dueDate,
    List<StudentInAssignment>? students,
  }) {
    return AssignmentM(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      name: name ?? this.name,
      type: type ?? this.type,
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
      'possiblePoints': possiblePoints,
      'creationDate': Timestamp.fromDate(creationDate!),
      'dueDate': Timestamp.fromDate(dueDate!),
      'students': students?.map((x) => x.toMap()).toList(),
    };
  }

  factory AssignmentM.fromMap(Map<String, dynamic> map) {
    return AssignmentM(
      id: map['id'],
      classId: map['classId'],
      name: map['name'],
      type: map['type'],
      possiblePoints: map['possiblePoints'],
      creationDate: DateTime.fromMillisecondsSinceEpoch(map['creationDate']),
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate']),
      students: List<StudentInAssignment>.from(
          map['students']?.map((x) => StudentInAssignment.fromMap(x))),
    );
  }

  factory AssignmentM.fromDocumentSnapshot(DocumentSnapshot doc) {
    return AssignmentM(
      id: doc['id'],
      classId: doc['classId'],
      name: doc['name'],
      type: doc['type'],
      possiblePoints: doc['possiblePoints'],
      creationDate: (doc['creationDate'] as Timestamp).toDate(),
      dueDate: (doc['dueDate'] as Timestamp).toDate(),
      students: List<StudentInAssignment>.from(
          doc['students']?.map((x) => StudentInAssignment.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory AssignmentM.fromJson(String source) =>
      AssignmentM.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AssignmentM(id: $id, classId: $classId, name: $name, type: $type, possiblePoints: $possiblePoints, creationDate: $creationDate, dueDate: $dueDate, students: $students)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AssignmentM &&
        other.id == id &&
        other.classId == classId &&
        other.name == name &&
        other.type == type &&
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
        possiblePoints.hashCode ^
        creationDate.hashCode ^
        dueDate.hashCode ^
        students.hashCode;
  }
}

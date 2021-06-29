import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Assignment {
  String? assignmentName;
  String? type;
  double? earnedPoints;
  double? possiblePoints;
  bool? completed;
  DateTime? creationDate;
  DateTime? dueDate;

  Assignment({
    this.assignmentName,
    this.type,
    this.earnedPoints,
    this.possiblePoints,
    this.completed,
    this.creationDate,
    this.dueDate,
  });

  Assignment copyWith({
    String? assignmentName,
    String? type,
    double? earnedPoints,
    double? possiblePoints,
    bool? completed,
    DateTime? creationDate,
    DateTime? dueDate,
  }) {
    return Assignment(
      assignmentName: assignmentName ?? this.assignmentName,
      type: type ?? this.type,
      earnedPoints: earnedPoints ?? this.earnedPoints,
      possiblePoints: possiblePoints ?? this.possiblePoints,
      completed: completed ?? this.completed,
      creationDate: creationDate ?? this.creationDate,
      dueDate: dueDate ?? this.dueDate,
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
    };
  }

  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      assignmentName: map['assignmentName'],
      type: map['type'],
      earnedPoints: map['earnedPoints'],
      possiblePoints: map['possiblePoints'],
      completed: map['completed'],
      creationDate: DateTime.fromMillisecondsSinceEpoch(map['creationDate']),
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate']),
    );
  }

  factory Assignment.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Assignment(
      assignmentName: doc['assignmentName'],
      type: doc['type'],
      earnedPoints: doc['earnedPoints'],
      possiblePoints: doc['possiblePoints'],
      completed: doc['completed'],
      creationDate: DateTime.fromMillisecondsSinceEpoch(doc['creationDate']),
      dueDate: DateTime.fromMillisecondsSinceEpoch(doc['dueDate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Assignment.fromJson(String source) =>
      Assignment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Assignment(assignmentName: $assignmentName, type: $type, earnedPoints: $earnedPoints, possiblePoints: $possiblePoints, completed: $completed, creationDate: $creationDate, dueDate: $dueDate)';
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
        other.dueDate == dueDate;
  }

  @override
  int get hashCode {
    return assignmentName.hashCode ^
        type.hashCode ^
        earnedPoints.hashCode ^
        possiblePoints.hashCode ^
        completed.hashCode ^
        creationDate.hashCode ^
        dueDate.hashCode;
  }
}

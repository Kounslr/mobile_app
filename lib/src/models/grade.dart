import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Grade {
  int? markingPeriod;
  int? percentGrade;
  String? letterGrade;

  Grade({
    this.markingPeriod,
    this.percentGrade,
    this.letterGrade,
  });

  Grade copyWith({
    int? markingPeriod,
    int? percentGrade,
    String? letterGrade,
  }) {
    return Grade(
      markingPeriod: markingPeriod ?? this.markingPeriod,
      percentGrade: percentGrade ?? this.percentGrade,
      letterGrade: letterGrade ?? this.letterGrade,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'markingPeriod': markingPeriod,
      'percentGrade': percentGrade,
      'letterGrade': letterGrade,
    };
  }

  factory Grade.fromMap(Map<String, dynamic> map) {
    return Grade(
      markingPeriod: map['markingPeriod'],
      percentGrade: map['percentGrade'],
      letterGrade: map['letterGrade'],
    );
  }

  factory Grade.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Grade(
      markingPeriod: doc['markingPeriod'],
      percentGrade: doc['percentGrade'],
      letterGrade: doc['letterGrade'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Grade.fromJson(String source) => Grade.fromMap(json.decode(source));

  @override
  String toString() =>
      'Grade(markingPeriod: $markingPeriod, percentGrade: $percentGrade, letterGrade: $letterGrade)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Grade &&
        other.markingPeriod == markingPeriod &&
        other.percentGrade == percentGrade &&
        other.letterGrade == letterGrade;
  }

  @override
  int get hashCode =>
      markingPeriod.hashCode ^ percentGrade.hashCode ^ letterGrade.hashCode;
}

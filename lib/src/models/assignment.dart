import 'dart:convert';

class Assignment {
  String assignmentName;
  String date;
  String category;

  // earn points = -1 means grade not added
  double earnedPoints;
  double possiblePoints;

  Assignment({
    this.assignmentName,
    this.date,
    this.category,
    this.earnedPoints,
    this.possiblePoints,
  });

  Assignment copyWith({
    String assignmentName,
    String date,
    String category,
    double earnedPoints,
    double possiblePoints,
  }) {
    return Assignment(
      assignmentName: assignmentName ?? this.assignmentName,
      date: date ?? this.date,
      category: category ?? this.category,
      earnedPoints: earnedPoints ?? this.earnedPoints,
      possiblePoints: possiblePoints ?? this.possiblePoints,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'assignmentName': assignmentName,
      'date': date,
      'category': category,
      'earnedPoints': earnedPoints,
      'possiblePoints': possiblePoints,
    };
  }

  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      assignmentName: map['assignmentName'],
      date: map['date'],
      category: map['category'],
      earnedPoints: map['earnedPoints'],
      possiblePoints: map['possiblePoints'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Assignment.fromJson(String source) =>
      Assignment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Assignment(assignmentName: $assignmentName, date: $date, category: $category, earnedPoints: $earnedPoints, possiblePoints: $possiblePoints)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Assignment &&
        other.assignmentName == assignmentName &&
        other.date == date &&
        other.category == category &&
        other.earnedPoints == earnedPoints &&
        other.possiblePoints == possiblePoints;
  }

  @override
  int get hashCode {
    return assignmentName.hashCode ^
        date.hashCode ^
        category.hashCode ^
        earnedPoints.hashCode ^
        possiblePoints.hashCode;
  }
}

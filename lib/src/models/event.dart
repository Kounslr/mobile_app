import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String? name;
  String? time;

  Event({
    this.name,
    this.time,
  });

  Event copyWith({
    String? name,
    String? time,
  }) {
    return Event(
      name: name ?? this.name,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'time': time,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      name: map['name'],
      time: map['time'],
    );
  }

  factory Event.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Event(
      name: doc['name'],
      time: doc['time'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) => Event.fromMap(json.decode(source));

  @override
  String toString() => 'Event(name: $name, time: $time)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Event && other.name == name && other.time == time;
  }

  @override
  int get hashCode => name.hashCode ^ time.hashCode;
}

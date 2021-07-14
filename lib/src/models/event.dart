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

class EventM {
  String? name;
  DateTime? time;

  EventM({
    this.name,
    this.time,
  });

  EventM copyWith({
    String? name,
    DateTime? time,
  }) {
    return EventM(
      name: name ?? this.name,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'time': time?.millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      'name': name,
      'time': Timestamp.fromDate(time!),
    };
  }

  factory EventM.fromMap(Map<String, dynamic> map) {
    return EventM(
      name: map['name'],
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
    );
  }

  factory EventM.fromMapFromDocumentSnapshot(Map<String, dynamic> map) {
    return EventM(
      name: map['name'],
      time: map['time'].toDate(),
    );
  }

  factory EventM.fromDocumentSnapshot(DocumentSnapshot doc) {
    return EventM(
      name: doc['name'],
      time: doc['time'].toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory EventM.fromJson(String source) => EventM.fromMap(json.decode(source));

  @override
  String toString() => 'EventM(name: $name, time: $time)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EventM && other.name == name && other.time == time;
  }

  @override
  int get hashCode => name.hashCode ^ time.hashCode;
}

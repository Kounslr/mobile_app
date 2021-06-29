import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:kounslr/src/models/block.dart';
import 'package:kounslr/src/models/event.dart';

class CurrentDay {
  String dayType; // Could be A-Day, B-Day etc.
  String markingPeriod;
  String date;
  List<Block> blocks; // Blocks 1 - 8, 1 - 4 etc.
  List<Event> events; // Pep rally, Sports practice, lunch

  CurrentDay({
    required this.dayType,
    required this.markingPeriod,
    required this.date,
    required this.blocks,
    required this.events,
  });

  CurrentDay copyWith({
    String? dayType,
    String? markingPeriod,
    String? date,
    List<Block>? blocks,
    List<Event>? events,
  }) {
    return CurrentDay(
      dayType: dayType ?? this.dayType,
      markingPeriod: markingPeriod ?? this.markingPeriod,
      date: date ?? this.date,
      blocks: blocks ?? this.blocks,
      events: events ?? this.events,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dayType': dayType,
      'markingPeriod': markingPeriod,
      'date': date,
      'blocks': blocks.map((x) => x.toMap()).toList(),
      'events': events.map((x) => x.toMap()).toList(),
    };
  }

  factory CurrentDay.fromMap(Map<String, dynamic> map) {
    return CurrentDay(
      dayType: map['dayType'],
      markingPeriod: map['markingPeriod'],
      date: map['date'],
      blocks: List<Block>.from(map['blocks']?.map((x) => Block.fromMap(x))),
      events: List<Event>.from(map['events']?.map((x) => Event.fromMap(x))),
    );
  }

  factory CurrentDay.fromDocumentSnapshot(DocumentSnapshot doc) {
    return CurrentDay(
      dayType: doc['dayType'],
      markingPeriod: doc['markingPeriod'],
      date: doc['date'],
      blocks: List<Block>.from(
          doc['blocks']?.map((x) => Block.fromDocumentSnapshot(x))),
      events: List<Event>.from(
          doc['events']?.map((x) => Event.fromDocumentSnapshot(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CurrentDay.fromJson(String source) =>
      CurrentDay.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CurrentDay(dayType: $dayType, markingPeriod: $markingPeriod, date: $date, blocks: $blocks, events: $events)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CurrentDay &&
        other.dayType == dayType &&
        other.markingPeriod == markingPeriod &&
        other.date == date &&
        listEquals(other.blocks, blocks) &&
        listEquals(other.events, events);
  }

  @override
  int get hashCode {
    return dayType.hashCode ^
        markingPeriod.hashCode ^
        date.hashCode ^
        blocks.hashCode ^
        events.hashCode;
  }
}

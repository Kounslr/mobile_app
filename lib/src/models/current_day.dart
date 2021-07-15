import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:kounslr/src/models/block.dart';
import 'package:kounslr/src/models/event.dart';

class CurrentDay {
  String? id;
  String? dayType; // Could be A-Day, B-Day etc.
  String? markingPeriod;
  DateTime? date;
  List<Block>? blocks; // Blocks 1 - 8, 1 - 4 etc.
  List<Event>? events; // Pep rally, Sports practice, lunch

  CurrentDay({
    this.id,
    this.dayType,
    this.markingPeriod,
    this.date,
    this.blocks,
    this.events,
  });

  CurrentDay copyWith({
    String? id,
    String? dayType,
    String? markingPeriod,
    DateTime? date,
    List<Block>? blocks,
    List<Event>? events,
  }) {
    return CurrentDay(
      id: id ?? this.id,
      dayType: dayType ?? this.dayType,
      markingPeriod: markingPeriod ?? this.markingPeriod,
      date: date ?? this.date,
      blocks: blocks ?? this.blocks,
      events: events ?? this.events,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dayType': dayType,
      'markingPeriod': markingPeriod,
      'date': date?.millisecondsSinceEpoch,
      'blocks': blocks?.map((x) => x.toMap()).toList(),
      'events': events?.map((x) => x.toMap()).toList(),
    };
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      'id': id,
      'dayType': dayType,
      'markingPeriod': markingPeriod,
      'date': Timestamp.fromDate(date!),
      'blocks': blocks?.map((x) => x.toDocumentSnapshot()).toList(),
      'events': events?.map((x) => x.toMap()).toList(),
    };
  }

  factory CurrentDay.fromMap(Map<String, dynamic> map) {
    return CurrentDay(
      id: map['id'],
      dayType: map['dayType'],
      markingPeriod: map['markingPeriod'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      blocks: List<Block>.from(map['blocks']?.map((x) => Block.fromMap(x))),
      events: List<Event>.from(map['events']?.map((x) => Event.fromMap(x))),
    );
  }

  factory CurrentDay.fromMapFromDocumentSnapshot(Map<String, dynamic> map) {
    return CurrentDay(
      id: map['id'],
      dayType: map['dayType'],
      markingPeriod: map['markingPeriod'],
      date: map['date'].toDate(),
      blocks: List<Block>.from(
          map['blocks']?.map((x) => Block.fromMapFromDocumentSnapshot(x))),
      events: List<Event>.from(
          map['events']?.map((x) => Event.fromMapFromDocumentSnapshot(x))),
    );
  }

  factory CurrentDay.fromDocumentSnapshot(DocumentSnapshot doc) {
    return CurrentDay(
      id: doc['id'],
      dayType: doc['dayType'],
      markingPeriod: doc['markingPeriod'],
      date: doc['date'].toDate(),
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
    return 'CurrentDay(id: $id, dayType: $dayType, markingPeriod: $markingPeriod, date: $date, blocks: $blocks, events: $events)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CurrentDay &&
        other.id == id &&
        other.dayType == dayType &&
        other.markingPeriod == markingPeriod &&
        other.date == date &&
        listEquals(other.blocks, blocks) &&
        listEquals(other.events, events);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        dayType.hashCode ^
        markingPeriod.hashCode ^
        date.hashCode ^
        blocks.hashCode ^
        events.hashCode;
  }
}

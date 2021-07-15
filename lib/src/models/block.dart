import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Block {
  int? period;
  DateTime? time;

  Block({
    this.period,
    this.time,
  });

  Block copyWith({
    int? period,
    DateTime? time,
  }) {
    return Block(
      period: period ?? this.period,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'period': period,
      'time': time?.millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      'period': period,
      'time': Timestamp.fromDate(time!),
    };
  }

  factory Block.fromMap(Map<String, dynamic> map) {
    return Block(
      period: map['period'],
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
    );
  }

  factory Block.fromMapFromDocumentSnapshot(Map<String, dynamic> map) {
    return Block(
      period: map['period'],
      time: map['time'].toDate(),
    );
  }

  factory Block.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Block(
      period: doc['period'],
      time: doc['time'].toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Block.fromJson(String source) => Block.fromMap(json.decode(source));

  @override
  String toString() => 'Block(period: $period, time: $time)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Block && other.period == period && other.time == time;
  }

  @override
  int get hashCode => period.hashCode ^ time.hashCode;
}

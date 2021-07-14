import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Block {
  int? period;
  String? time;

  Block({
    this.period,
    this.time,
  });

  Block copyWith({
    int? period,
    String? time,
  }) {
    return Block(
      period: period ?? this.period,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'period': period,
      'time': time,
    };
  }

  factory Block.fromMap(Map<String, dynamic> map) {
    return Block(
      period: map['period'] as int? ?? 1,
      time: map['time'] as String?,
    );
  }

  factory Block.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Block(
      period: doc['period'] as int?,
      time: doc['time'] as String?,
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

class BlockM {
  int? period;
  DateTime? time;

  BlockM({
    this.period,
    this.time,
  });

  BlockM copyWith({
    int? period,
    DateTime? time,
  }) {
    return BlockM(
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

  factory BlockM.fromMap(Map<String, dynamic> map) {
    return BlockM(
      period: map['period'],
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
    );
  }

  factory BlockM.fromMapFromDocumentSnapshot(Map<String, dynamic> map) {
    return BlockM(
      period: map['period'],
      time: map['time'].toDate(),
    );
  }

  factory BlockM.fromDocumentSnapshot(DocumentSnapshot doc) {
    return BlockM(
      period: doc['period'],
      time: doc['time'].toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory BlockM.fromJson(String source) => BlockM.fromMap(json.decode(source));

  @override
  String toString() => 'BlockM(period: $period, time: $time)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BlockM && other.period == period && other.time == time;
  }

  @override
  int get hashCode => period.hashCode ^ time.hashCode;
}

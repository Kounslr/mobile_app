/*
Kounslr iOS & Android App
Copyright (C) 2021 Kounslr

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

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

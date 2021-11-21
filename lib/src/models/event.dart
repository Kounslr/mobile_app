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

class Event {
  String? name;
  DateTime? time;

  Event({
    this.name,
    this.time,
  });

  Event copyWith({
    String? name,
    DateTime? time,
  }) {
    return Event(
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

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      name: map['name'],
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
    );
  }

  factory Event.fromMapFromDocumentSnapshot(Map<String, dynamic> map) {
    return Event(
      name: map['name'],
      time: map['time'].toDate(),
    );
  }

  factory Event.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Event(
      name: doc['name'],
      time: doc['time'].toDate(),
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

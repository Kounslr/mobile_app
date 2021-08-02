import 'dart:convert';

import 'package:canton_design_system/models/tag.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class JournalEntry {
  String? id;
  String? title;
  String? summary;
  DateTime? creationDate;
  DateTime? lastEditDate;
  List<Tag>? tags;
  JournalEntry({
    this.id,
    this.title,
    this.summary,
    this.creationDate,
    this.lastEditDate,
    this.tags,
  });

  JournalEntry copyWith({
    String? id,
    String? title,
    String? summary,
    DateTime? creationDate,
    DateTime? lastEditDate,
    List<Tag>? tags,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      creationDate: creationDate ?? this.creationDate,
      lastEditDate: lastEditDate ?? this.lastEditDate,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'creationDate': creationDate!.millisecondsSinceEpoch,
      'lastEditDate': lastEditDate!.millisecondsSinceEpoch,
      'tags': tags?.map((x) => x.toMap()).toList(),
    };
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'creationDate': Timestamp.fromDate(creationDate!),
      'lastEditDate': Timestamp.fromDate(lastEditDate!),
      'tags': tags?.map((x) => x.toMap()).toList(),
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'],
      title: map['title'],
      summary: map['summary'],
      creationDate: DateTime.fromMillisecondsSinceEpoch(map['creationDate']),
      lastEditDate: DateTime.fromMillisecondsSinceEpoch(map['lastEditDate']),
      tags: List<Tag>.from(map['tags']?.map((x) => Tag.fromMap(x))),
    );
  }

  factory JournalEntry.fromDocumentSnapshot(DocumentSnapshot doc) {
    return JournalEntry(
      id: doc['id'],
      title: doc['title'],
      summary: doc['summary'],
      creationDate: doc['creationDate'].toDate(),
      lastEditDate: doc['lastEditDate'].toDate(),
      tags: List<Tag>.from(doc['tags']?.map((x) => Tag.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory JournalEntry.fromJson(String source) =>
      JournalEntry.fromMap(json.decode(source));

  @override
  String toString() {
    return 'JournalEntry(id: $id, title: $title, summary: $summary, creationDate: $creationDate, lastEditDate: $lastEditDate, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is JournalEntry &&
        other.id == id &&
        other.title == title &&
        other.summary == summary &&
        other.creationDate == creationDate &&
        other.lastEditDate == lastEditDate &&
        listEquals(other.tags, tags);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        summary.hashCode ^
        creationDate.hashCode ^
        lastEditDate.hashCode ^
        tags.hashCode;
  }
}

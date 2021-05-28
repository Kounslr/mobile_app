import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:kounslr/src/models/journal_entry_tag.dart';

class JournalEntry {
  String title;
  String summary;
  DateTime creationDate;
  DateTime lastEditDate;
  List<JournalEntryTag> tags;
  JournalEntry({
    this.title,
    this.summary,
    this.creationDate,
    this.lastEditDate,
    this.tags,
  });

  JournalEntry copyWith({
    String title,
    String summary,
    DateTime creationDate,
    DateTime lastEditDate,
    List<JournalEntryTag> tags,
  }) {
    return JournalEntry(
      title: title ?? this.title,
      summary: summary ?? this.summary,
      creationDate: creationDate ?? this.creationDate,
      lastEditDate: lastEditDate ?? this.lastEditDate,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'summary': summary,
      'creationDate': creationDate.millisecondsSinceEpoch,
      'lastEditDate': lastEditDate.millisecondsSinceEpoch,
      'tags': tags?.map((x) => x.toMap())?.toList(),
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      title: map['title'],
      summary: map['summary'],
      creationDate: DateTime.fromMillisecondsSinceEpoch(map['creationDate']),
      lastEditDate: DateTime.fromMillisecondsSinceEpoch(map['lastEditDate']),
      tags: List<JournalEntryTag>.from(
          map['tags']?.map((x) => JournalEntryTag.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory JournalEntry.fromJson(String source) =>
      JournalEntry.fromMap(json.decode(source));

  @override
  String toString() {
    return 'JournalEntry(title: $title, summary: $summary, creationDate: $creationDate, lastEditDate: $lastEditDate, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is JournalEntry &&
        other.title == title &&
        other.summary == summary &&
        other.creationDate == creationDate &&
        other.lastEditDate == lastEditDate &&
        listEquals(other.tags, tags);
  }

  @override
  int get hashCode {
    return title.hashCode ^
        summary.hashCode ^
        creationDate.hashCode ^
        lastEditDate.hashCode ^
        tags.hashCode;
  }
}

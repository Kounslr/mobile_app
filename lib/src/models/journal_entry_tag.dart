import 'dart:convert';

class JournalEntryTag {
  String name;
  JournalEntryTag({
    this.name,
  });

  JournalEntryTag copyWith({
    String name,
  }) {
    return JournalEntryTag(
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory JournalEntryTag.fromMap(Map<String, dynamic> map) {
    return JournalEntryTag(
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory JournalEntryTag.fromJson(String source) =>
      JournalEntryTag.fromMap(json.decode(source));

  @override
  String toString() => 'JournalEntryTag(name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is JournalEntryTag && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}

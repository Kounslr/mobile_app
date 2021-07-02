import 'dart:async';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kounslr/src/models/assignment.dart';

import 'package:kounslr/src/models/journal_entry.dart';

class StudentRepository extends ChangeNotifier {
  final CollectionReference user = FirebaseFirestore.instance
      .collection('customers')
      .doc('lcps')
      .collection('schools')
      .doc('independence')
      .collection('students');

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStudent() {
    try {
      return user.doc(FirebaseAuth.instance.currentUser?.uid).snapshots()
          as Stream<DocumentSnapshot<Map<String, dynamic>>>;
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStudentClasses() {
    try {
      return user
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('classes')
          .snapshots();
    } catch (e) {
      rethrow;
    }
  }

  List<Assignment> assignments = [];
  Future<List<Assignment>> getTopSevenUpcomingAssignments() async {
    List<Assignment> _assignments = [];

    await user
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('classes')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.collection('assignments').get().then((value) {
          value.docs.forEach((sAssignment) {
            assignments.add(Assignment.fromMap(sAssignment.data()));
            assignments.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
          });
        });
      });
    });

    for (var item in assignments) {
      if (item.dueDate!.isAfter(DateTime.now())) {
        _assignments.add(item);
      }
    }

    return _assignments;
  }

  Future<void> addJournalEntry(JournalEntry entry) async {
    String id = user
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('journal entries')
        .doc()
        .id;

    await user
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('journal entries')
        .doc(id)
        .set(entry.copyWith(id: id).toMap());
  }

  Future<void> deleteJournalEntry(JournalEntry entry) async {
    await user
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('journal entries')
        .doc(entry.id)
        .delete();
  }

  Future<void> updateJournalEntry({
    required JournalEntry entry,
    String? title,
    String? summary,
    List<Tag>? tags,
  }) async {
    await user
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('journal entries')
        .doc(entry.id)
        .update(entry
            .copyWith(
                title: title,
                summary: summary,
                tags: tags,
                lastEditDate: DateTime.now())
            .toMap());
  }

  Future<void> completeJournalEntry(
      {JournalEntry? entry,
      String? title,
      String? summary,
      List<Tag>? tags}) async {
    if (!([null, ''].contains(title) || [null, ''].contains(summary)) ||
        [[], null].contains(tags)) {
      if (entry!.id == null) {
        await addJournalEntry(JournalEntry(
          creationDate: DateTime.now(),
          lastEditDate: DateTime.now(),
          title: title,
          summary: summary,
          tags: tags,
        ));
      } else {
        await updateJournalEntry(
          entry: entry,
          title: title,
          summary: summary,
          tags: tags,
        );
      }
    }
  }

  Map<String?, int?> getTopThreeMostUsedTags(
    List<QueryDocumentSnapshot> entries,
  ) {
    /// Variables
    List<JournalEntry> _entries = [];
    List<Tag> _tags = [];
    var map = <dynamic, dynamic>{};

    /// Convert firebase data to [Journal Entry]
    entries.forEach((element) {
      _entries
          .add(JournalEntry.fromMap(element.data() as Map<String, dynamic>));
    });

    /// Adds [Tag] (s) from [JournalEntry] to a list
    _entries.forEach((element) {
      element.tags!.forEach((element) {
        _tags.add(element);
      });
    });

    /// Counts the number of times the entry has been used
    for (var x in _tags) map[x.name] = ((map[x.name] ?? 0) + 1);

    var sortedKeys = map.keys.toList()
      ..sort((k1, k2) => map[k2].compareTo(map[k1]));

    for (int i = 0; i < sortedKeys.length; i++) {
      if (i >= 3) {
        sortedKeys.removeAt(i);
      }
    }

    var sortedMap = Map<String?, int?>.fromIterable(
      sortedKeys,
      key: (k) => k,
      value: (k) => map[k],
    );

    map = sortedMap;

    map.removeWhere((key, value) => false);

    return map as Map<String?, int?>;
  }

  Future<void> renameJournalEntryTags(
    List<JournalEntry> entries,
    Tag tag,
    Tag newTag,
  ) async {
    for (var entry in entries) {
      for (var item in entry.tags!) {
        if (item == tag) {
          entry.tags?.remove(item);
          entry.tags?.add(newTag);
        }
      }
      updateJournalEntry(entry: entry, tags: entry.tags);
    }
  }
}

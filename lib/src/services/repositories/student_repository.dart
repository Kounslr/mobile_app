import 'package:canton_design_system/canton_design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:kounslr/src/models/journal_entry.dart';
import 'package:kounslr/src/models/journal_entry_tag.dart';

class StudentRepository extends ChangeNotifier {
  final CollectionReference user = FirebaseFirestore.instance
      .collection('customers')
      .doc('lcps')
      .collection('schools')
      .doc('independence')
      .collection('students');

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStudent(
      String district, String school, String uid) {
    try {
      return user.doc(uid).snapshots();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addJournalEntry(JournalEntry entry) async {
    String id = user
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('journal entries')
        .doc()
        .id;
    await user
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('journal entries')
        .doc()
        .set(entry.copyWith(id: id).toMap());
  }

  Future<void> updateJournalEntry({
    JournalEntry entry,
    String title,
    String summary,
    List<JournalEntryTag> tags,
  }) async {
    await user
        .doc(FirebaseAuth.instance.currentUser.uid)
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
}

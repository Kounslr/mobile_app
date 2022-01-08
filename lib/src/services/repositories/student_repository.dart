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

import 'dart:async';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:uuid/uuid.dart';

import 'package:kounslr/src/models/assignment.dart';
import 'package:kounslr/src/models/block.dart';
import 'package:kounslr/src/models/class.dart';
import 'package:kounslr/src/models/journal_entry.dart';
import 'package:kounslr/src/models/school.dart';
import 'package:kounslr/src/models/staff_member.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/services/repositories/school_repository.dart';

class StudentRepository {
  var ref = FirebaseFirestore.instance.collection('customers/lcps/schools').doc('independence');

  var uid = FirebaseAuth.instance.currentUser?.uid;

  Stream<School> get school {
    try {
      var school = ref.snapshots().map((event) => School.fromDocumentSnapshot(event));

      return school;
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.recordError(e, e.stackTrace);

      rethrow;
    }
  }

  Stream<Student> get student {
    try {
      var student = ref
          .collection('students')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots()
          .map((event) => Student.fromDocumentSnapshot(event));

      return student;
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.recordError(e, e.stackTrace);

      rethrow;
    }
  }

  Future<Class> getClassByBlock(int block) async {
    try {
      var schoolClass = Class();
      List<Assignment> assignments = [];
      var classesRef = await ref
          .collection('classes')
          .where('students', arrayContains: {'id': FirebaseAuth.instance.currentUser?.uid})
          .where('block', isEqualTo: block)
          .get();

      if (classesRef.docs.isEmpty) {
        schoolClass.id = 'next';
        return schoolClass;
      }

      var assignmentsRef = await classesRef.docs.first.reference.collection('assignments').get();

      for (var element in assignmentsRef.docs) {
        assignments.add(Assignment.fromDocumentSnapshot(element));
      }

      Map<String, Assignment> mapFilter = {};
      for (var item in assignments) {
        mapFilter[item.id!] = item;
      }
      assignments = mapFilter.values.toList();

      assignments.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

      schoolClass = Class.fromDocumentSnapshot(classesRef.docs.first, assignments);

      return schoolClass;
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.recordError(e, e.stackTrace);

      rethrow;
    }
  }

  Stream<Block> get nextBlockStream async* {
    try {
      await for (var item in SchoolRepository().school.asStream()) {
        final now = DateTime.now();
        var nextBlock = Block();
        var blocks = item.currentDay!.blocks!;
        var times = blocks.map((e) => e.time!).toList();
        var timesAfterNow = [];

        for (var element in times) {
          if (element.isAfter(now)) {
            timesAfterNow.add(element);
          }
        }

        if (timesAfterNow.isEmpty) {
          yield Block(period: 0);
        } else {
          var closestTime = timesAfterNow.reduce((a, b) => a.difference(now).abs() < b.difference(now).abs() ? a : b);

          nextBlock = blocks.where((element) => element.time == closestTime).toList()[0];

          yield nextBlock;
        }
      }
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.recordError(e, e.stackTrace);

      rethrow;
    }
  }

  Future<Block> get nextBlock async {
    try {
      var school = await SchoolRepository().school;
      var block = Block();
      var now = DateTime.now();

      List<Block> blocks = school.currentDay!.blocks!;
      List<DateTime> times = blocks.map((e) => e.time!).toList();
      List<DateTime> timesAfterNow = [];

      for (var element in times) {
        if (element.isAfter(now)) timesAfterNow.add(element);
      }

      if (timesAfterNow.isEmpty) {
        return Block(period: 0);
      }

      var closestTime = timesAfterNow.reduce((a, b) => a.difference(now).abs() < b.difference(now).abs() ? a : b);

      block = blocks.where((element) => element.time == closestTime).toList()[0];

      return block;
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.recordError(e, e.stackTrace);

      rethrow;
    }
  }

  Stream<StaffMember> get nextClassTeacher async* {
    try {
      await for (var item in nextClassStream) {
        if (item.id == 'done') {
          yield StaffMember();
        } else {
          await for (var teacher in SchoolRepository().getTeacherByTeacherId(item.teacherId ?? '').asStream()) {
            yield teacher;
          }
        }
      }
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.recordError(e, e.stackTrace);

      rethrow;
    }
  }

  Stream<Class> get nextClassStream async* {
    try {
      await for (var item in nextBlockStream) {
        if (![0, null].contains(item.period)) {
          await for (var upcomingClass in getClassByBlock(item.period!).asStream()) {
            yield upcomingClass;
          }
        } else {
          yield Class(id: 'done');
        }
      }
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.recordError(e, e.stackTrace);

      rethrow;
    }
  }

  Future<Class> get nextClass async {
    try {
      var upcomingClass = Class();
      var upcomingBlock = await nextBlock;
      upcomingClass =
          ![0, null].contains(upcomingBlock.period) ? await getClassByBlock(upcomingBlock.period!) : Class(id: 'done');
      return upcomingClass;
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.recordError(e, e.stackTrace);

      rethrow;
    }
  }

  Stream<List<Class>> get studentClasses async* {
    try {
      List<Class> classes = [];

      var classesRef = await ref
          .collection('classes')
          .where('students', arrayContains: {'id': FirebaseAuth.instance.currentUser?.uid}).get();

      for (var item in classesRef.docs) {
        List<Assignment> ass = [];

        var assignmentsRef = await item.reference.collection('assignments').get();

        for (var element in assignmentsRef.docs) {
          ass.add(Assignment.fromDocumentSnapshot(element));
        }

        classes.add(Class.fromDocumentSnapshot(item, ass));
      }

      /// Fixes glitch where duplicate Classes are returned in list
      Map<String, Class> mapFilter = {};
      for (var item in classes) {
        mapFilter[item.id!] = item;
      }
      classes = mapFilter.values.toList();

      classes.sort((a, b) => a.block!.compareTo(b.block!));

      yield classes;
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.recordError(e, e.stackTrace);

      rethrow;
    }
  }

  Stream<List<Class>> get studentClassesForTheDay async* {
    try {
      List<Class> classes = [];
      final nBlocks = await SchoolRepository().blocks;
      final blocks = <int>[];

      for (var item in nBlocks) {
        blocks.add(item.period!);
      }

      var classesRef = await ref
          .collection('classes')
          .where('students', arrayContains: {'id': FirebaseAuth.instance.currentUser?.uid})
          .where('block', whereIn: blocks)
          .get();

      for (var item in classesRef.docs) {
        List<Assignment> ass = [];

        var assignmentsRef = await item.reference.collection('assignments').get();

        for (var element in assignmentsRef.docs) {
          ass.add(Assignment.fromDocumentSnapshot(element));
        }

        classes.add(Class.fromDocumentSnapshot(item, ass));
      }

      /// Fixes glitch where duplicate Classes are returned in list
      Map<String, Class> mapFilter = {};
      for (var item in classes) {
        mapFilter[item.id!] = item;
      }
      classes = mapFilter.values.toList();

      classes.sort((a, b) => a.block!.compareTo(b.block!));

      yield classes;
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.recordError(e, e.stackTrace);

      rethrow;
    }
  }

  Stream<List<Assignment>> get upcomingAssignments async* {
    try {
      List<Assignment>? ass;
      var classesRef = await ref
          .collection('classes')
          .where('students', arrayContains: {'id': FirebaseAuth.instance.currentUser?.uid}).get();
      ass = [];

      for (var item in classesRef.docs) {
        var assignmentRef = await item.reference.collection('assignments').get();

        for (var element in assignmentRef.docs) {
          var item = Assignment.fromDocumentSnapshot(element);

          if (item.dueDate!.isAfter(DateTime.now()) &&
                  !item
                      .students![
                          item.students!.indexWhere((element) => element.id == FirebaseAuth.instance.currentUser!.uid)]
                      .completed!
              //     &&
              // item.markingPeriod == schoolRef['currentDay']['markingPeriod']
              ) {
            ass.add(item);
          }
        }
      }

      /// Fixes glitch where duplicate Assignments are returned in list
      Map<String, Assignment> mapFilter = {};
      for (var item in ass) {
        mapFilter[item.id!] = item;
      }
      ass = mapFilter.values.toList();

      ass.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

      yield ass;
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.recordError(e, e.stackTrace);

      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get journalEntries {
    try {
      var entries = ref.collection('students/${FirebaseAuth.instance.currentUser?.uid}/journal_entries').snapshots();

      return entries;
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.recordError(e, e.stackTrace);

      rethrow;
    }
  }

  Future<List<Tag>> get getAllJournalEntryTags async {
    try {
      var tags = <Tag>[];
      // var newDocs = <DocumentSnapshot>[];
      var entries = await ref.collection('students/${FirebaseAuth.instance.currentUser?.uid}/journal_entries').get();
      for (var item in entries.docs) {
        tags.addAll(JournalEntry.fromDocumentSnapshot(item).tags!);
      }

      return tags.toSet().toList();
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.recordError(e, e.stackTrace);

      rethrow;
    }
  }

  Future<void> addJournalEntry(JournalEntry entry) async {
    await ref
        .collection('students/${FirebaseAuth.instance.currentUser?.uid}/journal_entries')
        .doc(entry.id)
        .set(entry.toDocumentSnapshot());
  }

  Future<void> deleteJournalEntry(JournalEntry entry) async {
    await ref.collection('students/${FirebaseAuth.instance.currentUser?.uid}/journal_entries').doc(entry.id).delete();
  }

  Future<void> updateJournalEntry(
      {required JournalEntry entry, String? title, String? summary, List<Tag>? tags}) async {
    await ref
        .collection('students/${FirebaseAuth.instance.currentUser?.uid}/journal_entries')
        .doc(entry.id)
        .update(entry
            .copyWith(
              title: title,
              summary: summary,
              tags: tags,
              lastEditDate: DateTime.now(),
            )
            .toDocumentSnapshot());
  }

  Future<void> completeJournalEntry({JournalEntry? entry, String? title, String? summary, List<Tag>? tags}) async {
    if (!([null, ''].contains(title) || [null, ''].contains(summary)) || [[], null].contains(tags)) {
      if (entry!.id == null) {
        await addJournalEntry(
          JournalEntry(
            id: const Uuid().v4(),
            creationDate: DateTime.now(),
            lastEditDate: DateTime.now(),
            title: title,
            summary: summary,
            tags: tags,
          ),
        );
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

  Map<String?, int?> getTopThreeMostUsedTags(List<JournalEntry> entries) {
    /// Variables
    List<Tag> _tags = [];
    var map = <String?, int?>{};

    /// Adds [Tag] (s) from [JournalEntry] to a list
    for (var element in entries) {
      for (var element in element.tags!) {
        _tags.add(element);
      }
    }

    /// Counts the number of times the entry has been used
    for (var x in _tags) {
      map[x.name] = ((map[x.name] ?? 0) + 1);
    }

    var sortedKeys = map.keys.toList()..sort((k1, k2) => map[k2]!.compareTo(map[k1]!));

    var newList = [];

    for (int i = 0; i < sortedKeys.length; i++) {
      if (i < 3) {
        newList.add(sortedKeys[i]);
      }
    }

    Map<String?, int?> sortedMap = {for (var k in newList) k: map[k]};

    map = sortedMap;

    map.removeWhere((key, value) => false);

    return map;
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

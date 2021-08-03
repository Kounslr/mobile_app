import 'dart:async';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kounslr/src/models/assignment.dart';
import 'package:kounslr/src/models/block.dart';
import 'package:kounslr/src/models/class.dart';

import 'package:kounslr/src/models/journal_entry.dart';
import 'package:kounslr/src/models/school.dart';
import 'package:kounslr/src/models/staff_member.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/services/repositories/school_repository.dart';
import 'package:uuid/uuid.dart';

class StudentRepository {
  var ref = FirebaseFirestore.instance
      .collection('customers/lcps/schools')
      .doc('independence');

  var uid = FirebaseAuth.instance.currentUser?.uid;

  Stream<School> get school {
    try {
      var school =
          ref.snapshots().map((event) => School.fromDocumentSnapshot(event));

      return school;
    } catch (e) {
      rethrow;
    }
  }

  Stream<Student> get student {
    try {
      var student = ref
          .collection('students')
          .doc(uid)
          .snapshots()
          .map((event) => Student.fromDocumentSnapshot(event));

      return student;
    } catch (e) {
      rethrow;
    }
  }

  Future<Class> getClassByBlock(int block) async {
    try {
      var schoolClass = Class();
      List<Assignment> assignments = [];
      var classesRef = await ref
          .collection('classes')
          .where('students', arrayContains: {'id': uid})
          .where('block', isEqualTo: block)
          .get();

      if (classesRef.docs.isEmpty) {
        schoolClass.id = 'done';
        return schoolClass;
      }

      var assignmentsRef =
          await classesRef.docs.first.reference.collection('assignments').get();

      assignmentsRef.docs.forEach((element) {
        assignments.add(Assignment.fromDocumentSnapshot(element));
      });

      Map<String, Assignment> mapFilter = {};
      for (var item in assignments) {
        mapFilter[item.id!] = item;
      }
      assignments = mapFilter.values.toList();

      assignments.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

      schoolClass =
          Class.fromDocumentSnapshot(classesRef.docs.first, assignments);

      return schoolClass;
    } catch (e) {
      rethrow;
    }
  }

  Stream<Block> get nextBlockStream async* {
    var school = await SchoolRepository().school;
    var nextBlock = Block();
    var now = DateTime.now();

    List<Block> blocks = school.currentDay!.blocks!;
    List<DateTime> times = blocks.map((e) => e.time!).toList();
    List<DateTime> timesAfterNow = [];

    times.forEach((element) {
      if (element.isAfter(now)) timesAfterNow.add(element);
    });

    if (timesAfterNow.isEmpty) {
      yield Block(period: 0);
    } else {
      var closestTime = timesAfterNow.reduce(
          (a, b) => a.difference(now).abs() < b.difference(now).abs() ? a : b);

      nextBlock =
          blocks.where((element) => element.time == closestTime).toList()[0];

      yield nextBlock;
    }
  }

  Future<Block> get nextBlock async {
    var school = await SchoolRepository().school;
    var block = Block();
    var now = DateTime.now();

    List<Block> blocks = school.currentDay!.blocks!;
    List<DateTime> times = blocks.map((e) => e.time!).toList();
    List<DateTime> timesAfterNow = [];

    times.forEach((element) {
      if (element.isAfter(now)) timesAfterNow.add(element);
    });

    if (timesAfterNow.isEmpty) {
      return Block(period: 0);
    }

    var closestTime = timesAfterNow.reduce(
        (a, b) => a.difference(now).abs() < b.difference(now).abs() ? a : b);

    block = blocks.where((element) => element.time == closestTime).toList()[0];

    return block;
  }

  Stream<StaffMember> get nextClassTeacher async* {
    var schoolClass = await nextClass;
    if (schoolClass.id == 'done') {
      yield StaffMember();
    }

    var teacher = await SchoolRepository()
        .getTeacherByTeacherId(schoolClass.teacherId ?? '');

    yield teacher;
  }

  Stream<Class> get nextClassStream async* {
    var upcomingClass = Class();
    var upcomingBlock = await nextBlock;
    upcomingClass = ![0, null].contains(upcomingBlock.period)
        ? await getClassByBlock(upcomingBlock.period!)
        : Class(id: 'done');
    yield upcomingClass;
  }

  Future<Class> get nextClass async {
    var upcomingClass = Class();
    var upcomingBlock = await nextBlock;
    upcomingClass = ![0, null].contains(upcomingBlock.period)
        ? await getClassByBlock(upcomingBlock.period!)
        : Class(id: 'done');
    return upcomingClass;
  }

  Stream<List<Class>> get studentClasses async* {
    try {
      List<Class> classes = [];

      var classesRef = await ref
          .collection('classes')
          .where('students', arrayContains: {'id': uid}).get();

      for (var item in classesRef.docs) {
        List<Assignment> ass = [];

        var assignmentsRef =
            await item.reference.collection('assignments').get();

        assignmentsRef.docs.forEach((element) {
          ass.add(Assignment.fromDocumentSnapshot(element));
        });

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
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Assignment>> get upcomingAssignments async* {
    try {
      List<Assignment>? ass;
      var classesRef = await ref
          .collection('classes')
          .where('students', arrayContains: {'id': uid}).get();
      var schoolRef = await ref.get();
      ass = [];

      for (var item in classesRef.docs) {
        var assignmentRef =
            await item.reference.collection('assignments').get();

        assignmentRef.docs.forEach((element) {
          var item = Assignment.fromDocumentSnapshot(element);

          if (item.dueDate!.isAfter(DateTime.now()) &&
              !item
                  .students![item.students!.indexWhere((element) =>
                      element.id == FirebaseAuth.instance.currentUser!.uid)]
                  .completed! &&
              item.markingPeriod == schoolRef['currentDay']['markingPeriod']) {
            ass!.add(item);
          }
        });
      }

      /// Fixes glitch where duplicate Assignments are returned in list
      Map<String, Assignment> mapFilter = {};
      for (var item in ass) {
        mapFilter[item.id!] = item;
      }
      ass = mapFilter.values.toList();

      ass.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

      yield ass;
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get journalEntries {
    try {
      var entries = ref.collection('students/$uid/journal_entries').snapshots();

      return entries;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addJournalEntry(JournalEntry entry) async {
    await ref
        .collection('students/$uid/journal_entries')
        .doc(entry.id)
        .set(entry.toDocumentSnapshot());
  }

  Future<void> deleteJournalEntry(JournalEntry entry) async {
    await ref
        .collection('students/$uid/journal_entries')
        .doc(entry.id)
        .delete();
  }

  Future<void> updateJournalEntry(
      {required JournalEntry entry,
      String? title,
      String? summary,
      List<Tag>? tags}) async {
    await ref
        .collection('students/$uid/journal_entries')
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

  Future<void> completeJournalEntry(
      {JournalEntry? entry,
      String? title,
      String? summary,
      List<Tag>? tags}) async {
    if (!([null, ''].contains(title) || [null, ''].contains(summary)) ||
        [[], null].contains(tags)) {
      if (entry!.id == null) {
        await addJournalEntry(
          JournalEntry(
            id: Uuid().v4(),
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
    var map = <dynamic, dynamic>{};

    /// Adds [Tag] (s) from [JournalEntry] to a list
    entries.forEach((element) {
      element.tags!.forEach((element) {
        _tags.add(element);
      });
    });

    /// Counts the number of times the entry has been used
    for (var x in _tags) map[x.name] = ((map[x.name] ?? 0) + 1);

    var sortedKeys = map.keys.toList()
      ..sort((k1, k2) => map[k2].compareTo(map[k1]));

    var newList = [];

    for (int i = 0; i < sortedKeys.length; i++) {
      if (i < 3) {
        newList.add(sortedKeys[i]);
      }
    }

    var sortedMap = Map<String?, int?>.fromIterable(
      newList,
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

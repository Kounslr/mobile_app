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
      .collection('customers')
      .doc('lcps')
      .collection('schools')
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
      List<Assignment> assignments = [];
      var classesRef = await ref
          .collection('classes')
          .where('students', arrayContains: {'id': uid})
          .where('block', isEqualTo: block)
          .get();

      var assignmentsRef =
          await classesRef.docs[0].reference.collection('assignments').get();

      assignmentsRef.docs.forEach((element) {
        assignments.add(Assignment.fromDocumentSnapshot(element));
      });

      Map<String, Assignment> mapFilter = {};
      for (var item in assignments) {
        mapFilter[item.id!] = item;
      }
      assignments = mapFilter.values.toList();

      assignments.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

      var schoolClass =
          Class.fromDocumentSnapshot(classesRef.docs[0], assignments);

      return schoolClass;
    } catch (e) {
      rethrow;
    }
  }

  Stream<Block> get nextBlockStream async* {
    var school = await SchoolRepository().school;
    var nextBlock = Block();

    List<Block> blocks = school.currentDay!.blocks!;

    for (int i = 0; i < blocks.length; i++) {
      if (DateTime.now().isAfter(blocks[blocks.length - 2].time!)) {
        nextBlock = blocks[blocks.length - 2];
      } else if (DateTime.now().isAfter(blocks[blocks.length - 3].time!)) {
        nextBlock = blocks[blocks.length - 3];
      } else {
        nextBlock = blocks[blocks.length - 4];
      }
    }

    yield nextBlock;
  }

  Future<Block> get nextBlock async {
    var school = await SchoolRepository().school;
    var nextBlock = Block();

    List<Block> blocks = school.currentDay!.blocks!;

    for (int i = 0; i < blocks.length; i++) {
      if (DateTime.now().isAfter(blocks[blocks.length - 2].time!)) {
        nextBlock = blocks[blocks.length - 2];
      } else if (DateTime.now().isAfter(blocks[blocks.length - 3].time!)) {
        nextBlock = blocks[blocks.length - 3];
      } else {
        nextBlock = blocks[blocks.length - 4];
      }
    }

    return nextBlock;
  }

  Stream<StaffMember> get nextClassTeacher async* {
    var schoolClass = await nextClass;
    var teacher =
        await SchoolRepository().getTeacherByTeacherId(schoolClass.teacherId!);

    yield teacher;
  }

  Stream<Class> get nextClassStream async* {
    var upcomingClass = Class();
    var upcomingBlock = await nextBlock;
    upcomingClass = upcomingBlock.period != null
        ? await getClassByBlock(upcomingBlock.period!)
        : Class();
    yield upcomingClass;
  }

  Future<Class> get nextClass async {
    var upcomingClass = Class();
    var upcomingBlock = await nextBlock;
    upcomingClass = upcomingBlock.period != null
        ? await getClassByBlock(upcomingBlock.period!)
        : Class();
    return upcomingClass;
  }

  Future<List<Class>> get studentClasses async {
    try {
      List<Class> classes = [];
      var classesRef = await ref
          .collection('classes')
          .where('students', arrayContains: {'id': uid}).get();

      classesRef.docs.forEach((element) async {
        List<Assignment> ass = [];
        var assignmentsRef =
            await element.reference.collection('assignments').get();
        assignmentsRef.docs.forEach((element) {
          ass.add(Assignment.fromDocumentSnapshot(element));
        });
        classes.add(Class.fromDocumentSnapshot(element, ass));
      });

      /// Fixes glitch where duplicate Classes are returned in list
      Map<String, Class> mapFilter = {};
      for (var item in classes) {
        mapFilter[item.id!] = item;
      }
      classes = mapFilter.values.toList();

      classes.sort((a, b) => a.block!.compareTo(b.block!));

      return classes;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Assignment>> get upcomingAssignments async {
    try {
      List<Assignment> ass = [];
      var classesRef = await ref
          .collection('classes')
          .where('students', arrayContains: {'id': uid}).get();

      classesRef.docs.forEach((element) async {
        var assignmentRef =
            await element.reference.collection('assignments').get();
        assignmentRef.docs.forEach((element) {
          ass.add(Assignment.fromDocumentSnapshot(element));
        });
      });

      for (var item in ass) {
        if (item.dueDate!.isBefore(DateTime.now())) {
          ass.remove(item);
        }
      }

      /// Fixes glitch where duplicate Assignments are returned in list
      Map<String, Assignment> mapFilter = {};
      for (var item in ass) {
        mapFilter[item.id!] = item;
      }
      ass = mapFilter.values.toList();

      ass.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

      return ass;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addJournalEntry(JournalEntry entry) async {
    String id = Uuid().v4();

    await ref
        .collection('students')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('journal entries')
        .doc(id)
        .set(entry.copyWith(id: id).toMap());
  }

  Future<void> deleteJournalEntry(JournalEntry entry) async {
    await ref
        .collection('students')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('journal entries')
        .doc(entry.id)
        .delete();
  }

  Future<void> updateJournalEntry(
      {required JournalEntry entry,
      String? title,
      String? summary,
      List<Tag>? tags}) async {
    await ref
        .collection('students')
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

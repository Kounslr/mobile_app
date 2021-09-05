import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/services/repositories/school_repository.dart';

final allStudentsStreamProvider =
    FutureProvider.autoDispose<List<Student>>((ref) {
  return SchoolRepository().getAllStudents;
});

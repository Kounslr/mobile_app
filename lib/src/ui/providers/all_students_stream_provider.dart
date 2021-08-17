import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/services/repositories/school_repository.dart';
import 'package:kounslr/src/ui/providers/authentication_providers/authentication_stream_provider.dart';

final allStudentsStreamProvider = FutureProvider.autoDispose<List<Student>>((ref) {
  ref.watch(authenticationStreamProvider).whenData((value) {
    if (value == null) {
      ref.maintainState = false;
    } else {
      ref.maintainState = true;
    }
  });
  return SchoolRepository().allStudents;
});
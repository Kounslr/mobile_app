import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/services/repositories/student_repository.dart';

import 'authentication_providers/authentication_stream_provider.dart';

final studentStreamProvider = StreamProvider.autoDispose<Student>((ref) {
  ref.watch(authenticationStreamProvider).whenData((value) {
    if (value == null) {
      ref.maintainState = false;
    } else {
      ref.maintainState = true;
    }
  });
  return StudentRepository().student;
});

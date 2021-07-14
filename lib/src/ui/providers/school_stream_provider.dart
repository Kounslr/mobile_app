import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/school.dart';
import 'package:kounslr/src/services/repositories/student_repository.dart';

final schoolStreamProvider = StreamProvider<SchoolM>((ref) {
  return StudentRepository().school;
});

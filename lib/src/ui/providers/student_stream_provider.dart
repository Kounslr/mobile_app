import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/services/repositories/student_repository.dart';

final studentStreamProvider = StreamProvider<StudentM>((ref) {
  return StudentRepository().student;
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/services/repositories/student_repository.dart';

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return StudentRepository();
});

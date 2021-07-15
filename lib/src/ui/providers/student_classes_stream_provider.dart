import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/class.dart';
import 'package:kounslr/src/services/repositories/student_repository.dart';

final studentClassesFutureProvider = FutureProvider<List<Class>>((ref) {
  return StudentRepository().studentClasses;
});

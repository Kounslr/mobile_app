import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/assignment.dart';
import 'package:kounslr/src/services/repositories/student_repository.dart';

final upcomingAssignmentsFutureProvider =
    FutureProvider<List<Assignment>>((ref) {
  return StudentRepository().upcomingAssignments;
});

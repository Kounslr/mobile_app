import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/staff_member.dart';
import 'package:kounslr/src/services/repositories/student_repository.dart';

final nextClassTeacherStreamProvider = StreamProvider<StaffMember>((ref) {
  return StudentRepository().nextClassTeacher;
});

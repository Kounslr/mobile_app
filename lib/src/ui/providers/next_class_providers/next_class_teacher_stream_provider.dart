import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/staff_member.dart';
import 'package:kounslr/src/services/repositories/student_repository.dart';
import 'package:kounslr/src/ui/providers/authentication_providers/authentication_stream_provider.dart';

final nextClassTeacherStreamProvider =
    StreamProvider.autoDispose<StaffMember>((ref) {
  ref.watch(authenticationStreamProvider).whenData((value) {
    if (value == null) {
      ref.maintainState = false;
    } else {
      ref.maintainState = true;
    }
  });
  return StudentRepository().nextClassTeacher;
});

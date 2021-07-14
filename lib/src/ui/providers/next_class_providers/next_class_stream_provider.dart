import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/class.dart';
import 'package:kounslr/src/services/repositories/student_repository.dart';

final nextClassStreamProvider = StreamProvider<ClassM>((ref) {
  return StudentRepository().nextClassStream;
});

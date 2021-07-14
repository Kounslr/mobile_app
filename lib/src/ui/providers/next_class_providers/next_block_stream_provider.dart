import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/block.dart';
import 'package:kounslr/src/services/repositories/student_repository.dart';

final nextBlockStreamProvider = StreamProvider<BlockM>((ref) {
  return StudentRepository().nextBlockStream;
});

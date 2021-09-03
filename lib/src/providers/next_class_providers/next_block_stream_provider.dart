import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/block.dart';
import 'package:kounslr/src/providers/authentication_providers/authentication_stream_provider.dart';
import 'package:kounslr/src/services/repositories/student_repository.dart';

final nextBlockStreamProvider = StreamProvider.autoDispose<Block>((ref) {
  ref.watch(authenticationStreamProvider).whenData((value) {
    if (value == null) {
      ref.maintainState = false;
    } else {
      ref.maintainState = true;
    }
  });
  return StudentRepository().nextBlockStream;
});

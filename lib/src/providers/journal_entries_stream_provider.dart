import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/providers/authentication_providers/authentication_stream_provider.dart';
import 'package:kounslr/src/services/repositories/student_repository.dart';

final journalEntriesStreamProvider =
    StreamProvider.autoDispose<QuerySnapshot<Map<String, dynamic>>>((ref) {
  ref.watch(authenticationStreamProvider).whenData((value) {
    if (value == null) {
      ref.maintainState = false;
    } else {
      ref.maintainState = true;
    }
  });
  return StudentRepository().journalEntries;
});

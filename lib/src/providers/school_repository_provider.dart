import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/services/repositories/school_repository.dart';

import 'authentication_providers/authentication_stream_provider.dart';

final schoolRepositoryProvider = Provider.autoDispose<SchoolRepository>((ref) {
  ref.watch(authenticationStreamProvider).whenData((value) {
    if (value == null) {
      ref.maintainState = false;
    } else {
      ref.maintainState = true;
    }
  });
  return SchoolRepository();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/school.dart';
import 'package:kounslr/src/services/repositories/school_repository.dart';

final schoolFutureProvider = FutureProvider<School>((ref) {
  return SchoolRepository().school;
});

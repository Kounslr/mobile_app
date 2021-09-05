import 'package:kounslr/src/models/block.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/services/repositories/school_repository.dart';

final schoolBlocksFutureProvider = FutureProvider<List<Block>>((ref) {
  return SchoolRepository().blocks;
});

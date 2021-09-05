import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/room.dart';
import 'package:kounslr/src/providers/authentication_providers/authentication_stream_provider.dart';
import 'package:kounslr/src/services/repositories/chat_repository/chat_repository.dart';

final roomsStreamProvider = StreamProvider.autoDispose<List<Room>>((ref) {
  ref.watch(authenticationStreamProvider).whenData((value) {
    if (value == null) {
      ref.maintainState = false;
    } else {
      ref.maintainState = true;
    }
  });
  return ChatRepository.instance.rooms();
});

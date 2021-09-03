import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/services/repositories/chat_repository/chat_repository.dart';
import 'package:kounslr/src/models/room.dart';

var currentChatRoomId = '';

final roomStreamProvider = StreamProvider.autoDispose<Room>((ref) {
  ref.maintainState = false;
  return ChatRepository.instance.room(currentChatRoomId);
});

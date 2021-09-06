import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:kounslr/src/models/room.dart';
import 'package:kounslr/src/services/repositories/chat_repository/chat_repository.dart';

var currentChatRoom = Room(id: '', users: [], type: types.RoomType.direct);

final roomMessagesStreamProvider =
    StreamProvider.autoDispose<List<types.Message>>((ref) {
  ref.maintainState = false;
  return ChatRepository.instance.messages(currentChatRoom);
});

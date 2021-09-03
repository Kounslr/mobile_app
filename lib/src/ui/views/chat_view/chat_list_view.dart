import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/providers/chat_providers/rooms_stream_provider.dart';
import 'package:kounslr/src/ui/styled_components/something_went_wrong.dart';
import 'package:kounslr/src/ui/views/chat_view/components/chat_card.dart';
import 'package:kounslr/src/ui/views/chat_view/components/chat_list_view_header.dart';

class ChatListView extends StatefulWidget {
  const ChatListView();

  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  @override
  Widget build(BuildContext context) {
    return _content(context);
  }

  Widget _content(BuildContext context) {
    return Column(
      children: [
        ChatListViewHeader(),
        const SizedBox(height: 7),
        _body(context),
      ],
    );
  }

  Widget _body(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final roomsRepo = watch(roomsStreamProvider);

        return roomsRepo.when(
          error: (e, s) {
            return SomethingWentWrong();
          },
          loading: () => Expanded(child: Loading()),
          data: (rooms) {
            if (rooms.length < 1) {
              return Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Text(
                      'Click the "+" button to create a Chat',
                      style: Theme.of(context).textTheme.headline5,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }

            return Expanded(
              child: ListView.builder(
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ChatCard(rooms[index]),
                      if (index == rooms.length - 1) Divider(),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

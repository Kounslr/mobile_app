import 'package:canton_design_system/canton_design_system.dart';
import 'package:kounslr/src/models/room.dart';
import 'package:kounslr/src/services/repositories/chat_repository.dart';
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
    return StreamBuilder<List<Room>>(
      stream: FirebaseChatCore.instance.rooms(),
      initialData: const [],
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Expanded(
            child: Loading(),
          );
        }

        var rooms = snapshot.data!;

        if (rooms.length < 1) {
          return Expanded(
            child: Center(
              child: Text(
                'Click the "+" button to create a Chat',
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
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
  }
}

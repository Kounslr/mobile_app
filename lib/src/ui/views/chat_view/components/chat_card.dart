import 'package:canton_design_system/canton_design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kounslr/src/models/room.dart';
import 'package:kounslr/src/ui/views/chat_view/chat_view.dart';

class ChatCard extends StatelessWidget {
  const ChatCard(this.room);

  final Room room;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        dismissThresholds: <SlideActionType, double>{
          SlideActionType.primary: 1.0,
          SlideActionType.secondary: 1.0,
        },
      ),
      secondaryActions: <Widget>[
        // _deleteMessage(context),
      ],
      child: GestureDetector(
        onTap: () {
          CantonMethods.viewTransition(context, ChatView(room));
        },
        child: Container(
          color: CantonColors.transparent,
          child: Column(
            children: [
              Divider(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      radius: 25,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _roomName(),
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        SizedBox(
                          height: 40,
                          child: Text(
                            _messageText(),
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryVariant,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    IconlyIcon(
                      IconlyLine.ArrowRight2,
                      color: Theme.of(context).colorScheme.secondaryVariant,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _roomName() {
    var string = room.name ?? '';

    if (room.users.length == 2) {
      string = room.users
              .where((element) =>
                  element.id != FirebaseAuth.instance.currentUser?.uid)
              .first
              .firstName ??
          'User';
    }

    if (string.length > 21) {
      return string.substring(0, 21) + '...';
    }

    return string;
  }

  String _messageText() {
    var string = '';
    if (room.lastMessages == null) {
      return 'No new messages';
    }

    if (room.lastMessages!.length == 1) {
      string = '1 New message';
    }

    if (room.lastMessages!.length > 1) {
      string = room.lastMessages!.length.toString() + ' New messages';
    }

    return string;
  }
}

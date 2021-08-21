import 'package:canton_design_system/canton_design_system.dart';
import 'package:kounslr/src/models/room.dart';
import 'package:kounslr/src/ui/views/chat_view/chat_view.dart';

class ChatCard extends StatelessWidget {
  const ChatCard(this.room);

  final Room room;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CantonMethods.viewTransition(context, ChatView(room));
      },
      child: Container(
        color: CantonColors.transparent,
        child: Column(
          children: [
            Divider(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
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
                          room.lastMessages.toString(),
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
    );
  }

  String _roomName() {
    var string = '';
    string = room.name!;

    if (string.length > 21) {
      return string.substring(0, 21) + '...';
    }

    return string;
  }
}

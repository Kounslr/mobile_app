import 'package:canton_design_system/canton_design_system.dart';
import 'package:kounslr/src/models/room.dart';

class ChatViewHeader extends StatelessWidget {
  const ChatViewHeader({required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: ViewHeaderTwo(
        backButton: true,
        title: room.name ?? room.users.first.firstName ?? 'Chat',
        buttonOne: GestureDetector(
          onTap: () {},
          child: Transform.rotate(
            angle: 180,
            child: Container(
              child: IconlyIcon(
                IconlyBold.InfoCircle,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:canton_design_system/canton_design_system.dart';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kounslr/src/models/room.dart';

class ChatViewHeader extends StatelessWidget {
  const ChatViewHeader(this.room);

  final Room room;

  @override
  Widget build(BuildContext context) {
    String roomName() {
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: ViewHeaderTwo(
        backButton: true,
        title: roomName(),
        buttonTwo: CantonActionButton(
          onPressed: () {},
          icon: Transform.rotate(
            angle: math.pi,
            child: Container(
              alignment: Alignment.centerRight,
              child: Icon(
                Iconsax.info_circle,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

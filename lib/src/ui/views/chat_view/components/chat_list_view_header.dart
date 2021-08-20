import 'package:canton_design_system/canton_design_system.dart';
import 'package:kounslr/src/ui/views/chat_view/add_users_to_chat_view.dart';

class ChatListViewHeader extends StatelessWidget {
  const ChatListViewHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: ViewHeaderOne(
        title: 'Chat',
        button: CantonHeaderButton(
          isClear: true,
          icon: Icon(
            FeatherIcons.plus,
            color: Theme.of(context).primaryColor,
            size: 27,
          ),
          onPressed: () {
            CantonMethods.viewTransition(context, AddUsersToChatView());
          },
        ),
      ),
    );
  }
}
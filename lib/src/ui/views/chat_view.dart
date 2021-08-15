import 'package:canton_design_system/canton_design_system.dart';

class ChatView extends StatefulWidget {
  const ChatView();

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return _content(context);
  }

  Widget _content(BuildContext context) {
    return Column(
      children: [
        _header(context),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      child: ViewHeaderOne(
        title: 'Chat',
        button: CantonHeaderButton(
          icon: Icon(
            FeatherIcons.plus,
            color: Theme.of(context).primaryColor,
            size: 27,
          ),
        ),
      ),
    );
  }
}

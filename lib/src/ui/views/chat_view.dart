import 'package:canton_design_system/canton_design_system.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return _content(context);
  }

  Widget _content(BuildContext context) {
    return Center(
      child: Text(
        'Real-time chat coming soon 🚀',
        style: Theme.of(context).textTheme.headline4!.copyWith(
              color: Theme.of(context).primaryColor,
            ),
      ),
    );
  }
}

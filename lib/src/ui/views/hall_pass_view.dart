import 'package:canton_design_system/canton_design_system.dart';

class HallPassView extends StatefulWidget {
  @override
  _HallPassViewState createState() => _HallPassViewState();
}

class _HallPassViewState extends State<HallPassView> {
  @override
  Widget build(BuildContext context) {
    return _content(context);
  }

  Widget _content(BuildContext context) {
    return Center(
      child: Text(
        'Hall Pass View coming soon 🚀',
        style: Theme.of(context).textTheme.headline4!.copyWith(
              color: Theme.of(context).primaryColor,
            ),
      ),
    );
  }
}

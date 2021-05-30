import 'package:canton_design_system/canton_design_system.dart';
import 'package:kounslr/src/ui/views/hall_pass_view.dart';
import 'package:kounslr/src/ui/views/journal_entry_view.dart';
import 'package:kounslr/src/ui/views/profile_view.dart';

class JournalView extends StatefulWidget {
  @override
  _JournalViewState createState() => _JournalViewState();
}

class _JournalViewState extends State<JournalView> {
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
    return Row(
      children: [
        Text(
          'Journal',
          style: Theme.of(context).textTheme.headline2.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
        Spacer(),
        CantonHeaderButton(
          backgroundColor: Theme.of(context).primaryColor,
          icon: Icon(
            FeatherIcons.plus,
            color: CantonColors.white,
            size: 24,
          ),
          onPressed: () => CantonMethods.viewTransition(
            context,
            JournalEntryView(),
          ),
        ),
      ],
    );
  }
}

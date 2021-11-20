import 'package:canton_design_system/canton_design_system.dart';
import 'package:kounslr/src/models/journal_entry.dart';
import 'package:kounslr/src/ui/views/journal_view/journal_entry_view.dart';

class JournalViewHeader extends StatelessWidget {
  const JournalViewHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 17, left: 17, right: 17),
      child: ViewHeaderOne(
        title: 'Journal',
        button: CantonHeaderButton(
          isClear: true,
          icon: Icon(
            Iconsax.message_edit,
            color: Theme.of(context).primaryColor,
            size: 27,
          ),
          onPressed: () => CantonMethods.viewTransition(
            context,
            JournalEntryView(JournalEntry()),
          ),
        ),
      ),
    );
  }
}

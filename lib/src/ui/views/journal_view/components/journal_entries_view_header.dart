import 'package:canton_design_system/canton_design_system.dart';

class JournalEntriesViewHeader extends StatelessWidget {
  const JournalEntriesViewHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: ViewHeaderTwo(
        title: 'Journal Entries',
        backButton: true,
      ),
    );
  }
}

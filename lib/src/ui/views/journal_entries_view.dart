import 'package:canton_design_system/canton_design_system.dart';
import 'package:kounslr/src/ui/styled_components/journal_entry_card.dart';

class JournalEntriesView extends StatefulWidget {
  const JournalEntriesView();

  @override
  _JournalEntriesViewState createState() => _JournalEntriesViewState();
}

class _JournalEntriesViewState extends State<JournalEntriesView> {
  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      children: [
        ViewHeaderTwo(
          title: 'Journal Entries',
          backButton: true,
          isBackButtonClear: true,
        ),
        _journalEntriesListView(context),
      ],
    );
  }

  Widget _journalEntriesListView(BuildContext context) {
    return ListView.builder(itemBuilder: (context, index) {
      //return JournalEntryCard();
    });
  }
}

import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/journal_entry.dart';
import 'package:kounslr/src/ui/providers/journal_entries_stream_provider.dart';
import 'package:kounslr/src/ui/styled_components/journal_entry_tag_card.dart';
import 'package:kounslr/src/ui/styled_components/something_went_wrong.dart';

class JournalEntriesView extends StatefulWidget {
  const JournalEntriesView();

  @override
  _JournalEntriesViewState createState() => _JournalEntriesViewState();
}

class _JournalEntriesViewState extends State<JournalEntriesView> {
  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      padding: const EdgeInsets.all(0),
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      children: [
        _header(),
        _journalEntriesListView(context),
      ],
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: ViewHeaderTwo(
        title: 'Journal Entries',
        backButton: true,
      ),
    );
  }

  Widget _journalEntriesListView(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final entryRepo = watch(journalEntriesStreamProvider);
        return entryRepo.when(
          error: (e, s) {
            return SomethingWentWrong();
          },
          loading: () => Loading(),
          data: (data) {
            List<JournalEntry> entries = [];
            data.docs.forEach((element) {
              entries.add(JournalEntry.fromDocumentSnapshot(element));
            });
            _listOfEntries(entries);
            return Expanded(
              child: _tagList.length > 0
                  ? ListView.builder(
                      itemCount: _tagList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            JournalEntryTagCard(
                              _listOfEntries(entries)
                                  .where((element) =>
                                      element.tags!.contains(_tagList[index]))
                                  .toList(),
                              _tagList[index],
                            ),
                            if (index == _tagList.length - 1) Divider(),
                          ],
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No entries',
                        style: Theme.of(context).textTheme.headline4?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryVariant,
                            ),
                      ),
                    ),
            );
          },
        );
      },
    );
  }

  List<JournalEntry> _listOfEntries(List<JournalEntry> entries) {
    List<JournalEntry> e = [];
    List<Tag> _tags = [];
    for (var item in entries) {
      e.add(item);
    }
    for (var entry in e) {
      for (var tag in entry.tags!) if (!_tags.contains(tag)) _tags.add(tag);
    }

    _tagList = _tags;

    return e;
  }

  List<Tag> _tagList = [];
}

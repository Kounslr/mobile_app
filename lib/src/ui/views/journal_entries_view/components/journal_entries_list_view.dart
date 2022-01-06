import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kounslr/src/models/journal_entry.dart';
import 'package:kounslr/src/providers/journal_entries_stream_provider.dart';
import 'package:kounslr/src/ui/components/something_went_wrong.dart';
import 'package:kounslr/src/ui/views/journal_entries_view/components/journal_entry_tag_card.dart';

class JournalEntriesListView extends StatefulWidget {
  const JournalEntriesListView(this.allEntries, {Key? key}) : super(key: key);

  final Map<String?, int?> allEntries;

  @override
  State<JournalEntriesListView> createState() => _JournalEntriesListViewState();
}

class _JournalEntriesListViewState extends State<JournalEntriesListView> {
  List<JournalEntry> _listOfEntries(List<JournalEntry> entries) {
    List<JournalEntry> e = [];
    List<Tag> _tags = [];
    for (var item in entries) {
      e.add(item);
    }
    for (var entry in e) {
      for (var tag in entry.tags!) {
        if (!_tags.contains(tag)) _tags.add(tag);
      }
    }

    _tagList = _tags;

    return e;
  }

  List<Tag> _tagList = [];

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final entryRepo = watch(journalEntriesStreamProvider);
        return entryRepo.when(
          error: (e, s) {
            return const SomethingWentWrong();
          },
          loading: () => Loading(),
          data: (data) {
            List<JournalEntry> entries = [];
            for (var element in data.docs) {
              entries.add(JournalEntry.fromDocumentSnapshot(element));
            }
            _listOfEntries(entries);
            return Expanded(
              child: _tagList.isNotEmpty
                  ? ListView.builder(
                      itemCount: _tagList.length,
                      itemBuilder: (context, index) {
                        BorderRadius radiiByIndex() {
                          if (_tagList.length == 1) {
                            return BorderRadius.circular(12);
                          } else if (_tagList.length == 2) {
                            if (index == 0) {
                              return const BorderRadius.vertical(top: Radius.circular(12));
                            } else {
                              return const BorderRadius.vertical(bottom: Radius.circular(12));
                            }
                          } else {
                            if (index == 0) {
                              return const BorderRadius.vertical(top: Radius.circular(12));
                            } else if (index == _tagList.length - 1) {
                              return const BorderRadius.vertical(bottom: Radius.circular(12));
                            } else {
                              return BorderRadius.zero;
                            }
                          }
                        }

                        return Column(
                          children: [
                            JournalEntryTagCard(
                              _listOfEntries(entries)
                                  .where((element) => element.tags!.contains(_tagList[index]))
                                  .toList(),
                              _tagList[index],
                              allEntries: widget.allEntries,
                              radius: radiiByIndex(),
                            ),
                            if (index != _tagList.length - 1) const Divider(),
                          ],
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No entries',
                        style: Theme.of(context).textTheme.headline4?.copyWith(
                              color: Theme.of(context).colorScheme.secondaryVariant,
                            ),
                      ),
                    ),
            );
          },
        );
      },
    );
  }
}

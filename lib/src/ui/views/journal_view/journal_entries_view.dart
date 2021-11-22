/*
Kounslr iOS & Android App
Copyright (C) 2021 Kounslr

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/journal_entry.dart';
import 'package:kounslr/src/providers/journal_entries_stream_provider.dart';
import 'package:kounslr/src/ui/components/journal_entry_tag_card.dart';
import 'package:kounslr/src/ui/components/something_went_wrong.dart';
import 'package:kounslr/src/ui/views/journal_view/components/journal_entries_view_header.dart';

class JournalEntriesView extends StatefulWidget {
  const JournalEntriesView({Key? key}) : super(key: key);

  @override
  _JournalEntriesViewState createState() => _JournalEntriesViewState();
}

class _JournalEntriesViewState extends State<JournalEntriesView> {
  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      backgroundColor: CantonMethods.alternateCanvasColor(context),
      padding: const EdgeInsets.all(0),
      safeArea: false,
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      children: [
        const JournalEntriesViewHeader(),
        _journalEntriesListView(context),
      ],
    );
  }

  Widget _journalEntriesListView(BuildContext context) {
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
                        return Column(
                          children: [
                            JournalEntryTagCard(
                              _listOfEntries(entries)
                                  .where((element) => element.tags!.contains(_tagList[index]))
                                  .toList(),
                              _tagList[index],
                            ),
                            if (index == _tagList.length - 1) const Divider(),
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
}

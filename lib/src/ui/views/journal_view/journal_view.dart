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
import 'package:kounslr/src/providers/student_repository_provider.dart';
import 'package:kounslr/src/ui/components/something_went_wrong.dart';
import 'package:kounslr/src/ui/views/journal_view/components/horizontal_bar_chart.dart';
import 'package:kounslr/src/ui/views/journal_view/components/journal_view_header.dart';
import 'package:kounslr/src/ui/views/journal_entries_view/journal_entries_view.dart';
import 'package:kounslr/src/ui/views/journal_view/components/view_card.dart';

class JournalView extends StatefulWidget {
  const JournalView({Key? key}) : super(key: key);

  @override
  _JournalViewState createState() => _JournalViewState();
}

class _JournalViewState extends State<JournalView> {
  @override
  Widget build(BuildContext context) {
    return _content(context);
  }

  Widget _content(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final entryRepo = watch(journalEntriesStreamProvider);

        return entryRepo.when(
          loading: () => Loading(),
          error: (e, s) {
            return const SomethingWentWrong();
          },
          data: (data) {
            List<JournalEntry> entries = [];

            for (var element in data.docs) {
              entries.add(JournalEntry.fromDocumentSnapshot(element));
            }

            final tags = context.read(studentRepositoryProvider).getTopThreeMostUsedTags(entries);

            if (entries.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  JournalViewHeader(tags),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                              text: 'Click the "',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            const WidgetSpan(
                              child: Icon(
                                Iconsax.message_edit,
                                size: 27,
                              ),
                            ),
                            TextSpan(
                              text: '" button to create your first journal entry',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                JournalViewHeader(tags),
                const SizedBox(height: 10),
                HorizontalBarChart(tags: tags),
                const SizedBox(height: 10),
                ViewCard(view: JournalEntriesView(tags), text: 'View all entries'),
              ],
            );
          },
        );
      },
    );
  }
}

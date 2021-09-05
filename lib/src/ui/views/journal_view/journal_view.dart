import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kounslr/src/models/journal_entry.dart';
import 'package:kounslr/src/providers/journal_entries_stream_provider.dart';
import 'package:kounslr/src/providers/student_repository_provider.dart';
import 'package:kounslr/src/ui/styled_components/something_went_wrong.dart';
import 'package:kounslr/src/ui/views/journal_view/components/journal_view_components.dart';
import 'package:kounslr/src/ui/views/journal_view/components/journal_view_header.dart';
import 'package:kounslr/src/ui/views/journal_view/journal_entries_view.dart';

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
    return Consumer(
      builder: (context, watch, child) {
        final entryRepo = watch(journalEntriesStreamProvider);

        return entryRepo.when(
          loading: () => Loading(),
          error: (e, s) {
            return SomethingWentWrong();
          },
          data: (data) {
            List<JournalEntry> entries = [];

            data.docs.forEach((element) {
              entries.add(JournalEntry.fromDocumentSnapshot(element));
            });

            final tags = context
                .read(studentRepositoryProvider)
                .getTopThreeMostUsedTags(entries);

            if (entries.length < 1) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  JournalViewHeader(),
                  SizedBox(height: 20),
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        child: Text(
                          'Click the "+" button to create your first journal entry',
                          style: Theme.of(context).textTheme.headline5,
                          textAlign: TextAlign.center,
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
                JournalViewHeader(),
                SizedBox(height: 10),
                HorizontalBarChart(tags: tags),
                SizedBox(height: 10),
                ViewCard(view: JournalEntriesView(), text: 'View all entries'),
              ],
            );
          },
        );
      },
    );
  }
}

import 'package:canton_design_system/canton_design_system.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kounslr/src/models/journal_entry.dart';
import 'package:kounslr/src/ui/providers/journal_entries_stream_provider.dart';
import 'package:kounslr/src/ui/providers/student_repository_provider.dart';
import 'package:kounslr/src/ui/styled_components/something_went_wrong.dart';
import 'package:kounslr/src/ui/views/journal_entries_view.dart';
import 'package:kounslr/src/ui/views/journal_entry_view.dart';

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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _header(context),
                SizedBox(height: 20),
                entries.length > 0
                    ? _horizontalBarChart(
                        context,
                        context
                            .read(studentRepositoryProvider)
                            .getTopThreeMostUsedTags(entries),
                      )
                    : Expanded(
                        child: Center(
                          child: Text(
                            'Click the "+" button to create your first journal entry',
                            style: Theme.of(context).textTheme.headline5,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                SizedBox(height: 20),
                entries.length > 0
                    ? _viewCard(
                        context,
                        'View all entries',
                        JournalEntriesView(),
                      )
                    : Container(),
              ],
            );
          },
        );
      },
    );
  }

  Widget _header(BuildContext context) {
    return ViewHeaderOne(
      title: 'Journal',
      button: CantonHeaderButton(
        isClear: true,
        icon: Icon(
          FeatherIcons.plus,
          color: Theme.of(context).primaryColor,
          size: 27,
        ),
        onPressed: () => CantonMethods.viewTransition(
          context,
          JournalEntryView(new JournalEntry()),
        ),
      ),
    );
  }

  Widget _horizontalBarChart(BuildContext context, Map<String?, int?> tags) {
    var data = tags.entries.toList();

    charts.Color? seriesColor = charts.Color(
      r: Theme.of(context).primaryColor.red,
      g: Theme.of(context).primaryColor.green,
      b: Theme.of(context).primaryColor.blue,
    );

    List<charts.Series<dynamic, String>> series = [
      new charts.Series(
        id: 'Tags',
        seriesColor: seriesColor,
        domainFn: (tag, _) => tag.key,
        measureFn: (tag, _) => tag.value,
        data: data,
      )
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Most Used Tags',
          style: Theme.of(context).textTheme.headline5,
        ),
        AspectRatio(
          aspectRatio: 2,
          child: charts.BarChart(series, vertical: false),
        ),
      ],
    );
  }

  Widget _viewCard(BuildContext context, String text, Widget view) {
    return GestureDetector(
      onTap: () => CantonMethods.viewTransition(context, view),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Text(
                text,
                style: Theme.of(context).textTheme.headline6!.copyWith(),
              ),
              Spacer(),
              IconlyIcon(
                IconlyBold.ArrowRight1,
                color: Theme.of(context).colorScheme.secondaryVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

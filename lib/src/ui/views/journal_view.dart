import 'package:canton_design_system/canton_design_system.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kounslr/src/models/journal_entry.dart';
import 'package:kounslr/src/ui/providers/student_repository_provider.dart';
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
        User user = FirebaseAuth.instance.currentUser!;

        var _stream = FirebaseFirestore.instance
            .collection('customers')
            .doc('lcps')
            .collection('schools')
            .doc('independence')
            .collection('students')
            .doc(user.uid)
            .collection('journal entries')
            .snapshots();

        return StreamBuilder<QuerySnapshot>(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ViewHeaderOne(
                    title: 'Journal',
                    button: CantonHeaderButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      icon: Icon(
                        FeatherIcons.plus,
                        color: CantonColors.white,
                        size: 24,
                      ),
                      onPressed: () => CantonMethods.viewTransition(
                        context,
                        JournalEntryView(new JournalEntry()),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // _graphJournalStatistics(
                  //   context,
                  //   context
                  //       .read(studentRepositoryProvider)
                  //       .getTopThreeMostUsedTags(snapshot.data!.docs),
                  // ),
                  _horizontalBarChart(
                    context,
                    context
                        .read(studentRepositoryProvider)
                        .getTopThreeMostUsedTags(snapshot.data!.docs),
                  ),
                  SizedBox(height: 20),
                  snapshot.data!.docs.length != 0
                      ? _viewCard(
                          context, 'View all entries', JournalEntriesView())
                      : Container(),
                ],
              );
            } else {
              return Loading();
            }
          },
        );
      },
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
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Text(
                text,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    //color: Theme.of(context).primaryColor,
                    ),
              ),
              Spacer(),
              IconlyIcon(
                IconlyBold.ArrowRight1,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

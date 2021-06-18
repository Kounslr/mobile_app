import 'dart:collection';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/journal_entry.dart';
import 'package:kounslr/src/ui/views/journal_entries_view.dart';
import 'package:kounslr/src/ui/views/journal_entry_view.dart';
import 'package:fl_chart/fl_chart.dart';

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
        User user = FirebaseAuth.instance.currentUser;

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
                  _graphJournalStatistics(
                    context,
                    _getTopThreeMostUsedTags(snapshot.data.docs),
                  ),
                  SizedBox(height: 20),
                  _viewCard(context, 'View all entries', JournalEntriesView()),
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

  Widget _graphJournalStatistics(BuildContext context, Map<String, int> tags) {
    Color _bgColor = Theme.of(context).primaryColor;
    Color _barColor = CantonColors.white;
    Color _barTooltipColor = Theme.of(context).colorScheme.primaryVariant;
    Color _xAxisTitleColor = CantonColors.white;
    List<BarChartGroupData> _barGroups = [];

    for (int i = 0; i < tags.values.length; i++) {
      _barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              y: tags.values.toList()[i].toDouble(),
              borderRadius: BorderRadius.circular(5),
              colors: [_barColor],
              width: 15,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 0,
        shape: SquircleBorder(radius: BorderRadius.circular(50)),
        color: _bgColor,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 20,
            axisTitleData: FlAxisTitleData(
              show: true,
              topTitle: AxisTitle(
                titleText: 'Most used tags',
                textStyle: Theme.of(context).textTheme.headline4.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ),
            barTouchData: BarTouchData(
              enabled: false,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.transparent,
                tooltipPadding: const EdgeInsets.all(0),
                tooltipMargin: 8,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    rod.y.round().toString(),
                    Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: _barTooltipColor),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) {
                  return Theme.of(context).textTheme.bodyText1.copyWith(
                        height: 0.9,
                        color: _xAxisTitleColor,
                      );
                },
                margin: 20,
                getTitles: (double value) {
                  switch (value.toInt()) {
                    case 0:
                      return tags.keys.toList(growable: false)[0];
                    case 1:
                      return tags.keys.toList(growable: false)[1];
                    case 2:
                      return tags.keys.toList(growable: false)[2];
                    default:
                      return '';
                  }
                },
              ),
              leftTitles: SideTitles(showTitles: false),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: _barGroups,
          ),
        ),
      ),
    );
  }

  Map<String, int> _getTopThreeMostUsedTags(
    List<QueryDocumentSnapshot> entries,
  ) {
    /// Variables
    List<JournalEntry> _entries = [];
    List<Tag> _tags = [];
    var map = <dynamic, dynamic>{};

    /// Convert firebase data to [Journal Entry]
    entries.forEach((element) {
      _entries.add(JournalEntry.fromMap(element.data()));
    });

    /// Adds [Tag] (s) from [JournalEntry] to a list
    _entries.forEach((element) {
      element.tags.forEach((element) {
        _tags.add(element);
      });
    });

    /// Counts the number of times the entry has been used
    for (var x in _tags) map[x.name] = ((map[x.name] ?? 0) + 1);

    var sortedKeys = map.keys.toList()
      ..sort((k1, k2) => map[k2].compareTo(map[k1]));

    for (int i = 0; i < sortedKeys.length; i++) {
      if (i >= 3) {
        sortedKeys.removeAt(i);
      }
    }

    var sortedMap = Map<String, int>.fromIterable(
      sortedKeys,
      key: (k) => k,
      value: (k) => map[k],
    );

    map = sortedMap;

    map.removeWhere((key, value) => false);

    return map;
  }

  Widget _viewCard(BuildContext context, String text, Widget view) {
    return GestureDetector(
      onTap: () {
        CantonMethods.viewTransition(context, view);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Text(
                text,
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Theme.of(context).primaryColor,
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

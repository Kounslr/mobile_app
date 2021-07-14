import 'package:canton_design_system/canton_design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/journal_entry.dart';
import 'package:kounslr/src/ui/providers/student_repository_provider.dart';
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
                  _graphJournalStatistics(
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

  Widget _graphJournalStatistics(
    BuildContext context,
    Map<String?, int?> tags,
  ) {
    /// Variables
    Color _bgColor = Theme.of(context).canvasColor;
    Color _barColor = Theme.of(context).primaryColor;
    Color _barTooltipColor = Theme.of(context).colorScheme.primaryVariant;
    Color _xAxisTitleColor = Theme.of(context).colorScheme.secondaryVariant;
    Color _titleTextColor = Theme.of(context).colorScheme.secondaryVariant;
    List<BarChartGroupData> _barGroups = [];

    int number() {
      if (tags.values.length < 3) return tags.values.length;
      return 3;
    }

    /// Bar group data
    for (int i = 0; i < number(); i++) {
      _barGroups.add(
        BarChartGroupData(
          x: i,
          showingTooltipIndicators: [0],
          barRods: [
            BarChartRodData(
              y: tags.values.toList()[i]!.toDouble(),
              borderRadius: BorderRadius.circular(5),
              colors: [_barColor],
              width: 15,
            ),
          ],
        ),
      );
    }

    /// Graph UI
    return AspectRatio(
      aspectRatio: 2,
      child: Card(
        elevation: 0,
        shape: SquircleBorder(radius: BorderRadius.circular(50)),
        color: _bgColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: _barGroups.length > 0
              ? BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    axisTitleData: FlAxisTitleData(
                      show: true,
                      topTitle: AxisTitle(
                        showTitle: true,
                        titleText: 'Most used tags',
                        textAlign: TextAlign.left,
                        reservedSize: -30,
                        margin: 50,
                        textStyle:
                            Theme.of(context).textTheme.headline6?.copyWith(
                                  color: _titleTextColor,
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
                                .headline5!
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
                          return Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                height: 0.9,
                                color: _xAxisTitleColor,
                              );
                        },
                        margin: 20,
                        getTitles: (double value) {
                          switch (value.toInt()) {
                            case 0:
                              return tags.keys.toList(growable: false)[0]!;
                            case 1:
                              return tags.keys.toList(growable: false)[1]!;
                            case 2:
                              return tags.keys.toList(growable: false)[2]!;
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
                )
              : Text(
                  'Click the "+" button to create your first journal entry',
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                ),
        ),
      ),
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

import 'package:canton_design_system/canton_design_system.dart';
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
              [
                Tag(name: 'basketball'),
                Tag(name: 'computerscience'),
                Tag(name: 'engineeringclub'),
              ],
            ),
            SizedBox(height: 20),
            _viewCard(context, 'View all entries', JournalEntriesView()),
          ],
        );
      },
    );
  }

  Widget _graphJournalStatistics(BuildContext context, List<Tag> tags) {
    Color _bgColor = Theme.of(context).primaryColor;
    Color _barColor = CantonColors.white;
    Color _barTooltipColor = Theme.of(context).colorScheme.primaryVariant;
    Color _xAxisTitleColor = CantonColors.white;
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
                      return tags[0].name;
                    case 1:
                      return tags[1].name;
                    case 2:
                      return tags[2].name;
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
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    y: 8,
                    borderRadius: BorderRadius.circular(5),
                    colors: [_barColor],
                    width: 15,
                  ),
                ],
                showingTooltipIndicators: [0],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    y: 10,
                    borderRadius: BorderRadius.circular(5),
                    colors: [_barColor],
                    width: 15,
                  ),
                ],
                showingTooltipIndicators: [0],
              ),
              BarChartGroupData(
                x: 2,
                barRods: [
                  BarChartRodData(
                    y: 14,
                    borderRadius: BorderRadius.circular(5),
                    colors: [_barColor],
                    width: 15,
                  ),
                ],
                showingTooltipIndicators: [0],
              ),
            ],
          ),
        ),
      ),
    );
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

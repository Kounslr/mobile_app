import 'package:canton_design_system/canton_design_system.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HorizontalBarChart extends StatelessWidget {
  const HorizontalBarChart({required this.tags, Key? key}) : super(key: key);

  final Map<String?, int?> tags;

  @override
  Widget build(BuildContext context) {
    var data = tags.entries.toList();

    final charts.Color? seriesColor = charts.Color(
      r: Theme.of(context).primaryColor.red,
      g: Theme.of(context).primaryColor.green,
      b: Theme.of(context).primaryColor.blue,
    );

    final charts.Color? labelColor = charts.Color(
      r: Theme.of(context).colorScheme.primary.red,
      g: Theme.of(context).colorScheme.primary.green,
      b: Theme.of(context).colorScheme.primary.blue,
    );

    final List<charts.Series<dynamic, String>> series = [
      charts.Series(
        id: 'Tags',
        seriesColor: seriesColor,
        domainFn: (tag, _) => tag.key,
        measureFn: (tag, _) => tag.value,
        data: data,
      ),
    ];

    return Column(
      children: [
        const Divider(),
        Container(
          color: Theme.of(context).colorScheme.secondary,
          padding: const EdgeInsets.only(left: 17, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 17, right: 17, top: 10),
                child: Text(
                  'Most Used Tags',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              AspectRatio(
                aspectRatio: 2,
                child: charts.BarChart(
                  series,
                  vertical: false,
                  secondaryMeasureAxis: charts.NumericAxisSpec(
                    renderSpec: charts.GridlineRendererSpec(
                      labelStyle: charts.TextStyleSpec(
                        color: labelColor,
                        fontSize: 12,
                      ),
                      lineStyle: charts.LineStyleSpec(color: labelColor),
                    ),
                  ),
                  domainAxis: charts.OrdinalAxisSpec(
                    renderSpec: charts.GridlineRendererSpec(
                      labelStyle: charts.TextStyleSpec(
                        color: labelColor,
                        fontSize: 12,
                      ),
                      lineStyle: const charts.LineStyleSpec(color: charts.MaterialPalette.transparent),
                    ),
                  ),
                  primaryMeasureAxis: charts.NumericAxisSpec(
                    renderSpec: charts.GridlineRendererSpec(
                      labelStyle: charts.TextStyleSpec(
                        color: labelColor,
                        fontSize: 12,
                      ),
                      lineStyle: charts.LineStyleSpec(color: labelColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}

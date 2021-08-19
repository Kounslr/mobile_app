import 'package:canton_design_system/canton_design_system.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HorizontalBarChart extends StatelessWidget {
  const HorizontalBarChart({required this.tags});

  final Map<String?, int?> tags;

  @override
  Widget build(BuildContext context) {
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
}

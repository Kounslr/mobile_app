import 'package:canton_design_system/canton_design_system.dart';
import 'package:intl/intl.dart';
import 'package:kounslr/src/models/school.dart';

class DateCard extends StatelessWidget {
  const DateCard({required this.school});

  final School school;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Row(
        children: [
          ![6, 7].contains(DateTime.now().weekday)
              ? Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7.5 * 2.5, vertical: 7.5),
                  decoration: ShapeDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: SquircleBorder(radius: BorderRadius.circular(37)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        school.currentDay?.dayType ?? 'M',
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: CantonColors.white,
                            ),
                      ),
                      Text(
                        'Day',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              color: CantonColors.white,
                            ),
                      ),
                    ],
                  ),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(vertical: 7.5),
                ),
          ![6, 7].contains(DateTime.now().weekday)
              ? SizedBox(width: 15)
              : Container(),
          Text(
            DateFormat.yMMMMEEEEd().format(
              DateTime.now(),
            ),
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}

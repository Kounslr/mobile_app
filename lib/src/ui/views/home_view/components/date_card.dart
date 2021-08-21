import 'package:canton_design_system/canton_design_system.dart';
import 'package:intl/intl.dart';
import 'package:kounslr/src/models/school.dart';

class DateCard extends StatelessWidget {
  const DateCard({required this.school});

  final School school;

  @override
  Widget build(BuildContext context) {
    String dayType() {
      if (school.currentDay?.dayType == null ||
          [6, 7].contains(DateTime.now().weekday)) return '';

      return (school.currentDay?.dayType ?? '') + ' Day';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Text.rich(
        TextSpan(
          text: DateFormat.yMMMMEEEEd().format(
            DateTime.now(),
          ),
          children: [
            TextSpan(
              text: ' • ',
            ),
            TextSpan(
                text: dayType(),
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Theme.of(context).primaryColor)),
          ],
        ),
        textAlign: TextAlign.right,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}

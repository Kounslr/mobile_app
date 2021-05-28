import 'package:canton_design_system/canton_design_system.dart';
import 'package:intl/intl.dart';

class CurrentDateCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
          decoration: ShapeDecoration(
            color: Theme.of(context).primaryColor,
            shape: SquircleBorder(radius: 30),
          ),
          child: Column(
            children: [
              Text(
                DateFormat.EEEE().format(DateTime.now()),
                style: Theme.of(context).textTheme.headline5.copyWith(
                  color: CantonColors.white,
                ),
              ),
              Text(
                DateFormat.MMM().format(DateTime.now()) + ' ' + DateFormat.d().format(DateTime.now()),
                style: Theme.of(context).textTheme.caption.copyWith(
                      color: CantonColors.white,
                    ),
              ),
              /*Text(
                DateFormat.MMM().format(DateTime.now()),
                style: Theme.of(context).textTheme.caption.copyWith(
                      color: CantonColors.white,
                    ),
              ),*/
            ],
          ),
        ),
        SizedBox(width: 15),
        Text("B-Day",
            style: Theme.of(context).textTheme.headline6,
            textScaleFactor: 2,
        ),
      ],
    );
  }

  String _modifyDateFormat(DateTime dt) {
    String formattedDateTimeString = DateFormat.yMMMMEEEEd().format(dt);

    return formattedDateTimeString;
  }
}

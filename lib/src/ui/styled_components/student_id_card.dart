// ignore: import_of_legacy_library_into_null_safe
import 'package:canton_design_system/canton_design_system.dart';

class StudentIDCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: SquircleBorder(radius: 65),
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                ClipSquircleBorder(
                  radius: 40,
                  child: Container(
                    height: 80,
                    width: 80,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                SizedBox(width: 15),
                Text(
                  'SCHOOL NAME',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(color: CantonColors.white),
                ),
              ],
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _titleUserText(context, 'Name', 'NAME HERE'),
                _titleUserText(context, 'Grade', 'GRADE HERE'),
                _titleUserText(context, 'ID', 'ID HERE')
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleUserText(
    BuildContext context,
    String title,
    String description,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Theme.of(context).colorScheme.primaryVariant,
              ),
        ),
        Text(
          description,
          style: Theme.of(context).textTheme.headline6.copyWith(
                color: CantonColors.white,
              ),
        ),
      ],
    );
  }
}

import 'package:canton_design_system/canton_design_system.dart';

import 'package:kounslr/src/models/class.dart';

class AssignmentCard extends StatelessWidget {
  final Class schoolClass;
  const AssignmentCard(this.schoolClass);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: ShapeDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: SquircleBorder(radius: BorderRadius.circular(30)),
              ),
              child: IconlyIcon(
                IconlyBold.EditSquare,
                color: Theme.of(context).colorScheme.secondaryVariant,
              ),
            ),
            SizedBox(height: 7),
            Text(
              'TIME',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Theme.of(context).colorScheme.secondaryVariant,
                  ),
            ),
          ],
        ),
        SizedBox(width: 10),
        Flexible(
          child: Card(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CLASS NAME',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        'ASSIGNMENT NAME',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(height: 7),
                      Text(
                        'DUE DATE',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryVariant,
                            ),
                      ),
                    ],
                  ),
                  //Spacer(),
                  //Container(width: 5, height: 5, color: CantonColors.blue)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

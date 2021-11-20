import 'package:canton_design_system/canton_design_system.dart';
import 'package:kounslr/src/models/block.dart';
import 'package:kounslr/src/models/class.dart';
import 'package:kounslr/src/models/staff_member.dart';
import 'package:kounslr/src/ui/views/home_view/components/class_card.dart';
import 'package:kounslr/src/ui/views/schedule_view/schedule_view.dart';

class NextClassCard extends StatelessWidget {
  const NextClassCard({required this.schoolClass, required this.block, required this.teacher, Key? key})
      : super(key: key);

  final Class schoolClass;
  final Block block;
  final StaffMember teacher;

  @override
  Widget build(BuildContext context) {
    if ([DateTime.saturday, DateTime.sunday].contains(DateTime.now().weekday)) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 17),
        child: Card(
          color: Theme.of(context).colorScheme.secondary,
          margin: const EdgeInsets.only(top: 15),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enjoy your weekend! 🤗',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
        ),
      );
    } else if ((schoolClass.id == 'done') || (block.period == 0)) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 17),
        child: Card(
          color: Theme.of(context).colorScheme.secondary,
          margin: const EdgeInsets.only(top: 12),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No more classes for today! 😃',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
        ),
      );
    } else if (schoolClass.id == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 17),
        child: Card(
          color: Theme.of(context).colorScheme.secondary,
          margin: const EdgeInsets.only(top: 15),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sorry! We couldn\'t figure out your next class', style: Theme.of(context).textTheme.headline6),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 17),
        child: Column(
          children: [
            Row(
              children: [
                Text('Next Class', style: Theme.of(context).textTheme.headline6),
                const Spacer(),
                TextButton(
                  style: ButtonStyle(
                    alignment: Alignment.centerRight,
                    animationDuration: Duration.zero,
                    elevation: MaterialStateProperty.all<double>(0),
                    overlayColor: MaterialStateProperty.all<Color>(
                      CantonColors.transparent,
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.zero,
                    ),
                  ),
                  child: Text(
                    'View Full Schedule',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                  onPressed: () {
                    CantonMethods.viewTransition(context, const ScheduleView());
                  },
                ),
                CantonActionButton(
                  icon: Icon(
                    Iconsax.arrow_right_2,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    CantonMethods.viewTransition(context, const ScheduleView());
                  },
                ),
              ],
            ),
            ClassCard(schoolClass: schoolClass, teacher: teacher, block: block)
          ],
        ),
      );
    }
  }
}

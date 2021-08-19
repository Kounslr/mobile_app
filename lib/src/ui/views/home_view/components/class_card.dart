import 'package:canton_design_system/canton_design_system.dart';
import 'package:intl/intl.dart';
import 'package:kounslr/src/models/block.dart';
import 'package:kounslr/src/models/class.dart';
import 'package:kounslr/src/models/staff_member.dart';

class ClassCard extends StatelessWidget {
  const ClassCard(
      {required this.schoolClass, required this.block, required this.teacher});

  final Class schoolClass;
  final Block block;
  final StaffMember teacher;

  @override
  Widget build(BuildContext context) {
    String _className(String? string) {
      if (string == null) {
        return 'Class Name';
      }

      if (string.length > 21) {
        return string.substring(0, 21) + '...';
      }

      return string;
    }

    String _teacherName(StaffMember teacher) {
      String string = teacher.name!.substring(teacher.name!.indexOf(' '));
      if (teacher.gender == 'Male') {
        return 'Mr.' + string;
      }
      return 'Ms.' + string;
    }

    String _nextClassTime(DateTime date) {
      return DateFormat("h:mm a").format(date).toString();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _className(schoolClass.name),
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    IconlyIcon(
                      IconlyBold.Location,
                      color: Theme.of(context).colorScheme.secondaryVariant,
                      size: 17,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      schoolClass.roomNumber ?? 'LOCATION',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color:
                                Theme.of(context).colorScheme.secondaryVariant,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    IconlyIcon(
                      IconlyBold.Profile,
                      color: Theme.of(context).colorScheme.secondaryVariant,
                      size: 17,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      _teacherName(teacher),
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color:
                                Theme.of(context).colorScheme.secondaryVariant,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Text(
              _nextClassTime(block.time!.toLocal()),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

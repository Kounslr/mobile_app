import 'package:canton_design_system/canton_design_system.dart';
import 'package:intl/intl.dart';
import 'package:kounslr/src/models/block.dart';
import 'package:kounslr/src/models/class.dart';
import 'package:kounslr/src/models/staff_member.dart';

class ClassCard extends StatefulWidget {
  const ClassCard(
      {required this.schoolClass, required this.block, required this.teacher});

  final Class schoolClass;
  final Block block;
  final StaffMember teacher;

  @override
  _ClassCardState createState() => _ClassCardState();
}

class _ClassCardState extends State<ClassCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.schoolClass.name ?? 'CLASS',
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
                      widget.schoolClass.roomNumber ?? 'LOCATION',
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
                      widget.teacher.name!,
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
              _nextClassTime(widget.block.time!),
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }

  String _nextClassTime(DateTime date) {
    return DateFormat("h:mm a").format(date).toString();
  }
}

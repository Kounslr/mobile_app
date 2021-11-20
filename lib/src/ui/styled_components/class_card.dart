import 'package:canton_design_system/canton_design_system.dart';
import 'package:intl/intl.dart';

import 'package:kounslr/src/models/block.dart';
import 'package:kounslr/src/models/class.dart';
import 'package:kounslr/src/models/staff_member.dart';

class ClassCard extends StatefulWidget {
  const ClassCard({required this.schoolClass, required this.block, required this.teacher, Key? key}) : super(key: key);

  final Class schoolClass;
  final Block block;
  final StaffMember teacher;

  @override
  _ClassCardState createState() => _ClassCardState();
}

class _ClassCardState extends State<ClassCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _className(widget.schoolClass.name!),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(height: 12),
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
                              color: Theme.of(context).colorScheme.secondaryVariant,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
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
                              color: Theme.of(context).colorScheme.secondaryVariant,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Text(
                _classTime(widget.block.time!),
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _classTime(DateTime date) {
    return DateFormat("h:mm a").format(date).toString();
  }

  String _className(String? string) {
    if (string == null) {
      return 'Class Name';
    }

    if (string.length > 21) {
      return string.substring(0, 21) + '...';
    }

    return string;
  }
}

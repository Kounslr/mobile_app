import 'package:canton_design_system/canton_design_system.dart';
import 'package:intl/intl.dart';
import 'package:kounslr/src/models/assignment.dart';
import 'package:kounslr/src/models/class.dart';

class AssignmentCard extends StatelessWidget {
  final Class? schoolClass;
  final Assignment? assignment;
  const AssignmentCard(this.schoolClass, this.assignment);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: Border(
        top: BorderSide(
          color: Theme.of(context).colorScheme.onSecondary,
          width: 1.5,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schoolClass?.name ?? 'CLASS NAME',
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                SizedBox(height: 7),
                Text(
                  _assignmentName(assignment?.name),
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(height: 7),
                Text(
                  _assignmentDate(assignment?.dueDate) +
                      ' • ' +
                      _assignmentTime(
                          DateFormat.jm().format(assignment!.dueDate!)),
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Theme.of(context).colorScheme.secondaryVariant,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _assignmentName(String? string) {
    if (string == null) {
      return 'ASSIGNMENT NAME';
    } else if (string.length > 37) {
      return string.substring(0, 36) + '...';
    }
    return string;
  }

  String _assignmentDate(DateTime? date) {
    if (date == null) {
      return 'DUE DATE';
    }
    return DateFormat.yMMMd().format(date).toString();
  }

  String _assignmentTime(String? time) {
    if (time == null) {
      return 'TIME';
    }
    return time;
  }
}

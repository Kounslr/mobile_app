/*
Kounslr iOS & Android App
Copyright (C) 2021 Kounslr

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'package:kounslr_design_system/kounslr_design_system.dart';
import 'package:intl/intl.dart';

import 'package:kounslr/src/models/assignment.dart';
import 'package:kounslr/src/models/class.dart';

class AssignmentCard extends StatelessWidget {
  final Class? schoolClass;
  final Assignment? assignment;
  final BorderRadius? radius;
  const AssignmentCard(this.schoolClass, this.assignment, {this.radius, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 17),
      color: KounslrMethods.alternateCanvasColorType2(context),
      shape: RoundedRectangleBorder(
        borderRadius: radius ?? BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _assignmentName(assignment?.name),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(height: 8.5),
                Text(
                  schoolClass?.name ?? 'CLASS NAME',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(height: 8.5),
                Text(
                  _assignmentDate(assignment?.dueDate) +
                      ' • ' +
                      _assignmentTime(DateFormat.jm().format(assignment!.dueDate!)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
